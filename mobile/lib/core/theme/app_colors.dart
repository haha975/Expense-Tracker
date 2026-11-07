import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF0D0D11);
  static const Color surface = Color(0xFF16161D);
  static const Color surfaceCard = Color(0xFF1C1C24);
  static const Color cardBg = Color(0xFF1B1A22);
  static const Color subCardBg = Color(0xFF16151C);
  static const Color elevatedSurface = surfaceCard;

  // Primary colors
  static const Color primary = Color(0xFF8B5CF6);
  static const Color primaryVariant = Color(0xFF7C3AED);
  static const Color primaryPurple = primary;
  static const Color accentPurpleLight = Color(0xFFA78BFA);

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF5E5D6A);

  // Compatibility aliases
  static const Color primaryText = textPrimary;
  static const Color secondaryText = textSecondary;
  static const Color onPrimary = Colors.white;

  // Borders and outlines
  static const Color border = Color(0xFF2E2E38);
  static const Color outline = border;

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color greenPositive = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Icon backgrounds
  static const Color iconBg = Color(0xFF23222B);
}
