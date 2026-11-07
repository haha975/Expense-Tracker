import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/statistics_entity.dart';

class CategoryBreakdownCard extends StatelessWidget {
  final List<ExpenseCategory> categories;
  final double spentPercentage;

  const CategoryBreakdownCard({
    super.key,
    required this.categories,
    required this.spentPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Multi-Segment Donut Chart
          SizedBox(
            width: 124,
            height: 124,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(124, 124),
                  painter: _DonutChartPainter(
                    categories: categories,
                    strokeWidth: 10,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${spentPercentage.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'of income spent',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Categories List items
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: categories.map((cat) {
                final Color categoryColor = Color(
                  int.parse(cat.colorHex.replaceFirst('#', '0xFF')),
                );

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: categoryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                cat.name,
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${cat.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${cat.percentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter that renders each category as a proportional arc in the ring graph
class _DonutChartPainter extends CustomPainter {
  final List<ExpenseCategory> categories;
  final double strokeWidth;

  _DonutChartPainter({
    required this.categories,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (categories.isEmpty) return;

    final double totalPercentage = categories.fold(
      0.0,
      (sum, item) => sum + item.percentage,
    );

    final double gapAngle = 0.08; // Small gap between segments in radians
    final double radius = (min(size.width, size.height) - strokeWidth) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    // Draw background track ring
    final Paint bgPaint = Paint()
      ..color = const Color(0xFF262630)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Start angle from top (-90 degrees / -pi / 2)
    double startAngle = -pi / 2;

    for (var cat in categories) {
      if (cat.percentage <= 0) continue;

      // Calculate sweep angle based on category percentage relative to total
      final double sweepAngle =
          (cat.percentage / (totalPercentage > 0 ? totalPercentage : 100)) *
              (2 * pi) -
          gapAngle;

      if (sweepAngle <= 0) continue;

      final Color catColor = Color(
        int.parse(cat.colorHex.replaceFirst('#', '0xFF')),
      );

      final Paint segmentPaint = Paint()
        ..color = catColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        startAngle + (gapAngle / 2),
        sweepAngle,
        false,
        segmentPaint,
      );

      // Advance start angle for next category segment
      startAngle += sweepAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.categories != categories ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}