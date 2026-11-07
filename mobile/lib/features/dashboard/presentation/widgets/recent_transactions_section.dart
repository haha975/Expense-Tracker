import 'package:flutter/material.dart';
import '../../domain/entities/dashboard_summary.dart';
import 'transaction_list_item.dart';

class RecentTransactionsSection extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const RecentTransactionsSection({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent transactions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Color(0xFFA78BFA),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          separatorBuilder: (context, index) => const Divider(
            color: Color(0xFF2D2C38),
            height: 1,
            thickness: 0.5,
          ),
          itemBuilder: (context, index) {
            return TransactionListItem(transaction: transactions[index]);
          },
        ),
      ],
    );
  }
}