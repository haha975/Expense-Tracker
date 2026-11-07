import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/budget_category_entity.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_state.dart';

class BudgetsView extends StatelessWidget {
  const BudgetsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetBloc, BudgetState>(
      builder: (context, state) {
        if (state is BudgetLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
          );
        } else if (state is BudgetLoaded) {
          final categories = state.categories;
          final double totalSpent =
              categories.fold(0, (sum, c) => sum + c.spentAmount);
          final double totalBudgeted =
              categories.fold(0, (sum, c) => sum + c.budgetLimit);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Monthly Budget Summary Card
                _buildBudgetSummaryCard(
                  totalSpent: totalSpent,
                  totalBudgeted: totalBudgeted,
                  monthYear: 'October 2026',
                ),
                const SizedBox(height: 24),

                // Category Budgets Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Category budgets',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${categories.length} active',
                      style: const TextStyle(
                        color: Color(0xFF9D65FF),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Category List Container Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16161A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    children: categories.map((cat) {
                      final bool isLast = categories.last.id == cat.id;
                      return _buildCategoryItem(cat, isLast: isLast);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Reset note footer
                Center(
                  child: Text(
                    'Monthly limits reset on November 1.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        } else if (state is BudgetError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // --- Summary Card Widget ---
  Widget _buildBudgetSummaryCard({
    required double totalSpent,
    required double totalBudgeted,
    required String monthYear,
  }) {
    final double usedPercentage =
        (totalSpent / totalBudgeted * 100).clamp(0.0, 100.0);
    final double remaining = totalBudgeted - totalSpent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    monthYear,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down,
                      color: Colors.grey[400], size: 18),
                ],
              ),
              Text(
                '${usedPercentage.toStringAsFixed(1)}% used',
                style: const TextStyle(
                  color: Color(0xFF9D65FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '\$${_formatCurrency(totalSpent)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (totalSpent / totalBudgeted).clamp(0.0, 1.0),
              backgroundColor: const Color(0xFF2A2A35),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'of \$${_formatCurrency(totalBudgeted)} budgeted',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              Text(
                '\$${_formatCurrency(remaining)} left',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Individual Category Item Widget ---
  Widget _buildCategoryItem(BudgetCategoryEntity category, {required bool isLast}) {
    final bool isWarning = category.isLimitReached;
    final Color barColor =
        isWarning ? const Color(0xFFE5A138) : const Color(0xFF8B5CF6);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF22222C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(category.iconName),
              color: Colors.grey[300],
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category.categoryName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: '\$${_formatCurrency(category.spentAmount)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: ' / \$${_formatCurrency(category.budgetLimit)}',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: category.progressPercentage,
                    backgroundColor: const Color(0xFF2A2A35),
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    minHeight: 5,
                  ),
                ),
                const SizedBox(height: 6),
                if (category.statusMessage != null)
                  Text(
                    category.statusMessage!,
                    style: const TextStyle(
                      color: Color(0xFFE5A138),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                else
                  Text(
                    '\$${_formatCurrency(category.remainingAmount)} left',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for category icons
  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'home':
        return Icons.home_outlined;
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;
      case 'directions_car':
        return Icons.directions_car_outlined;
      case 'sync':
        return Icons.sync_rounded;
      case 'more_horiz':
      default:
        return Icons.more_horiz_rounded;
    }
  }

  // Helper for currency formatting
  String _formatCurrency(double amount) {
    if (amount % 1 == 0) {
      return amount.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    }
    return amount.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}