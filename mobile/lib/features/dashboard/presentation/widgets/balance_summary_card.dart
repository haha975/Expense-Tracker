import 'package:flutter/material.dart';
import 'income_expense_summary.dart';

class BalanceSummaryCard extends StatelessWidget {
  final double balance;
  final double netMonth;
  final double income;
  final double expense;
  final bool isVisible;
  final VoidCallback onToggleVisibility;

  const BalanceSummaryCard({
    Key? key,
    required this.balance,
    required this.netMonth,
    required this.income,
    required this.expense,
    required this.isVisible,
    required this.onToggleVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1A22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2D2C38), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available balance',
                style: TextStyle(color: Color(0xFF8E8D9A), fontSize: 13, fontWeight: FontWeight.w500),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onToggleVisibility,
                icon: Icon(
                  isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: const Color(0xFF8E8D9A),
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isVisible ? '\$${balance.toStringAsFixed(2)}' : '••••••••',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isVisible ? '+\$${netMonth.toStringAsFixed(2)} net this month' : '•••••• net this month',
            style: const TextStyle(
              color: Color(0xFFA78BFA),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          IncomeExpenseSummary(
            income: income,
            expense: expense,
            isVisible: isVisible,
          ),
        ],
      ),
    );
  }
}