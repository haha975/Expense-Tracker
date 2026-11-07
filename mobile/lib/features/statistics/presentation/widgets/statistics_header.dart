import 'package:flutter/material.dart';

class StatisticsHeader extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;
  final String dateRangeLabel;
  final String subDateLabel;
  final VoidCallback onDownloadPressed;

  const StatisticsHeader({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.dateRangeLabel,
    required this.subDateLabel,
    required this.onDownloadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App bar top section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EXPENSE TRACKER',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Statistics',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
              onPressed: onDownloadPressed,
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E24),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              icon: const Icon(Icons.download_rounded, color: Colors.white, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Week / Month / Year Switcher
        Container(
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF16161A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: ['Week', 'Month', 'Year'].map((period) {
              final isSelected = selectedPeriod == period;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onPeriodChanged(period),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF262630) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      period,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[400],
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Date selector < October 2026 >
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.grey[400], size: 20),
              onPressed: () {},
            ),
            Column(
              children: [
                Text(
                  dateRangeLabel,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  subDateLabel,
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
