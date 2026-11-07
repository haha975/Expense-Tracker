import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

class AppBrandLogo extends StatelessWidget {
  const AppBrandLogo({super.key, this.size = 108, this.showGlow = true});

  final double size;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    final radius = size * 0.28;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.45),
                  blurRadius: size * 0.42,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          size * 0.26,
          size * 0.26,
          size * 0.26,
          size * 0.22,
        ),
        child: CustomPaint(painter: _BarsPainter()),
      ),
    );
  }
}

class _BarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const gapRatio = 0.18;
    final barWidth = size.width / (3 + 2 * gapRatio);
    final gap = barWidth * gapRatio;
    final heights = [size.height * 0.46, size.height * 0.72, size.height];

    for (var i = 0; i < 3; i++) {
      final left = i * (barWidth + gap);
      final top = size.height - heights[i];
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, heights[i]),
        Radius.circular(barWidth / 2),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
