import 'package:flutter/material.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16151C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2D2C38), width: 0.5),
      ),
      child: Row(
        children: const [
          Icon(Icons.cloud_done_outlined, size: 16, color: Color(0xFF22C55E)),
          SizedBox(width: 8),
          Text(
            'All changes synced',
            style: TextStyle(
              color: Color(0xFF8E8D9A),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            ' · Updated at 9:41',
            style: TextStyle(color: Color(0xFF5E5D6A), fontSize: 12),
          ),
        ],
      ),
    );
  }
}