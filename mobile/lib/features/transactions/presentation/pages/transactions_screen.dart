
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


import '../../domain/entities/transaction.dart';
import '../bloc/transaction_cubit.dart';
import '../bloc/transaction_state.dart';
import 'add_transaction_page.dart';
import 'search_filters_screen.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TransactionsView();
  }
}

class _TransactionsView extends StatelessWidget {
  const _TransactionsView();

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF0F1115),
      colorScheme: const ColorScheme.dark(
        surface: Color(0xFF16191E),
        primary: Color(0xFF2A2D36),
      ),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: BlocBuilder<TransactionCubit, TransactionState>(
                  builder: (context, state) {
                    if (state is! TransactionLoaded) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final cubit = context.read<TransactionCubit>();

                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        const SizedBox(height: 12),
                        if (state.pendingSyncCount > 0)
                          _buildOfflineBanner(state.pendingSyncCount),
                        const SizedBox(height: 16),
                        _buildSearchBar(context, cubit),
                        const SizedBox(height: 16),
                        _buildFilterTabs(state, cubit),
                        const SizedBox(height: 20),
                        ..._buildGroupedTransactionList(
                          cubit.getFilteredTransactions(state),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXPENSE TRACKER',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transactions',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF21252D),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => const AddTransactionPage(),
    ),
  );
},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineBanner(int pendingCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF231E12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF382E19)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            color: Color(0xFFD39E00),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Offline · $pendingCount changes waiting to sync',
              style: const TextStyle(
                color: Color(0xFFD39E00),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  
Widget _buildSearchBar(
  BuildContext context,
  TransactionCubit cubit,
) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF1B1E24),
      borderRadius: BorderRadius.circular(12),
    ),
    child: TextField(
      onChanged: cubit.setSearchQuery,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Search transactions',
        hintStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey.shade600,
          size: 20,
        ),
        suffixIcon: IconButton(
          tooltip: 'Search & filters',
          icon: const Icon(
            Icons.tune,
            color: Color(0xFF9D65FF),
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const SearchAndFiltersScreen(),
              ),
            );
          },
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );
}


  Widget _buildFilterTabs(
    TransactionLoaded state,
    TransactionCubit cubit,
  ) {
    const options = ['All', 'Expenses', 'Income'];

    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1E24),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(options.length, (index) {
          final isSelected = state.selectedFilterIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => cubit.setFilterIndex(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF2C303B)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  options[index],
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.grey.shade500,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _buildGroupedTransactionList(
    List<TransactionEntity> transactions,
  ) {
    if (transactions.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Text(
              'No transactions found',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ];
    }

    final Map<String, List<TransactionEntity>> grouped = {};

    for (final tx in transactions) {
      final dateKey = _formatGroupDate(tx.date);
      grouped.putIfAbsent(dateKey, () => []).add(tx);
    }

    final widgets = <Widget>[];

    grouped.forEach((dateString, list) {
      final groupTotal = list.fold<double>(
        0,
        (sum, item) => sum + item.amount,
      );

      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateString.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                _formatAmount(groupTotal, showSign: true),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );

      for (var i = 0; i < list.length; i++) {
        widgets.add(_buildTransactionTile(list[i]));

        if (i < list.length - 1) {
          widgets.add(
            Divider(
              color: Colors.grey.shade900,
              height: 1,
              indent: 52,
            ),
          );
        }
      }

      widgets.add(const SizedBox(height: 12));
    });

    return widgets;
  }

  Widget _buildTransactionTile(TransactionEntity tx) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF21252D),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getCategoryIcon(tx.title),
              color: Colors.grey.shade300,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '${tx.category} · ${tx.time}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                    if (tx.syncStatus == SyncStatus.pending)
                      const Text(
                        ' · Pending sync',
                        style: TextStyle(
                          color: Color(0xFFD39E00),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatAmount(tx.amount, showSign: true),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: tx.amount > 0
                  ? const Color(0xFF34C759)
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String title) {
    final lower = title.toLowerCase();

    if (lower.contains('market') || lower.contains('food')) {
      return Icons.shopping_basket_outlined;
    } else if (lower.contains('coffee')) {
      return Icons.local_cafe_outlined;
    } else if (lower.contains('green') ||
        lower.contains('restaurant')) {
      return Icons.restaurant_outlined;
    } else if (lower.contains('cos') || lower.contains('shop')) {
      return Icons.local_mall_outlined;
    } else if (lower.contains('uber') ||
        lower.contains('transport')) {
      return Icons.directions_car_outlined;
    } else if (lower.contains('salary') ||
        lower.contains('income')) {
      return Icons.work_outline;
    }

    return Icons.receipt_long_outlined;
  }

  String _formatGroupDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'TODAY, ${DateFormat('MMM d').format(date)}';
    } else if (targetDate == yesterday) {
      return 'YESTERDAY, ${DateFormat('MMM d').format(date)}';
    }

    return DateFormat('MMM d').format(date);
  }

  String _formatAmount(double amount, {bool showSign = false}) {
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    if (amount < 0) {
      return '-${formatter.format(amount.abs())}';
    } else if (amount > 0 && showSign) {
      return '+${formatter.format(amount)}';
    }

    return formatter.format(amount);
  }
}
