import 'package:flutter/material.dart';
import '../../domain/entities/dashboard_summary.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionListItem({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isIncome = transaction.type == TransactionType.income;
    IconData icon = isIncome ? Icons.work_outline : Icons.shopping_basket_outlined;
    if (transaction.title.contains('Coffee')) {
      icon = Icons.local_cafe_outlined;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF23222B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isIncome ? const Color(0xFF22C55E) : const Color(0xFF8E8D9A),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${transaction.category} · ${transaction.dateText}',
                  style: const TextStyle(color: Color(0xFF5E5D6A), fontSize: 12),
                ),
              ],
            ),
          ),
                    Text(
            '${isIncome ? '+' : '-'}\$${transaction.amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              color: isIncome ? const Color(0xFF22C55E) : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}