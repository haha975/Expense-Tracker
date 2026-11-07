import 'package:flutter/material.dart';

class IncomeExpenseSummary extends StatelessWidget {
  final double income;
  final double expense;
  final bool isVisible;

  const IncomeExpenseSummary({
    Key? key,
    required this.income,
    required this.expense,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildFlow(
            label: 'Income',
            amount: '+\$${income.toStringAsFixed(2)}',
            isIncome: true,
          ),
        ),
        Expanded(
          child: _buildFlow(
            label: 'Expenses',
            amount: '-\$${expense.toStringAsFixed(2)}',
            isIncome: false,
          ),
        ),
      ],
    );
  }

  Widget _buildFlow({
    required String label,
    required String amount,
    required bool isIncome,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isIncome ? Icons.south_west : Icons.north_east,
              size: 12,
              color: isIncome ? const Color(0xFF22C55E) : const Color(0xFF8E8D9A),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF8E8D9A), fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          isVisible ? amount : '••••••',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}