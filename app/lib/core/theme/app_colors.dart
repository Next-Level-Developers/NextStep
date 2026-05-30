// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFFEDE9FF);
  static const Color primaryDark = Color(0xFF4A42D6);

  static const Color secondary = Color(0xFFFF6584);
  static const Color secondaryLight = Color(0xFFFFE8ED);

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  // ── Surface & Background ───────────────────────────────────────────────────
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF9F9FB);
  static const Color surfaceVariant = Color(0xFFF4F4F8);
  static const Color outline = Color(0xFFF1F1F5);
  static const Color outlineMedium = Color(0xFFE2E2E8);

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color onSurface = Color(0xFF1A1A2E);
  static const Color onSurfaceVariant = Color(0xFF3D3D56);
  static const Color muted = Color(0xFF6B7280);
  static const Color mutedLight = Color(0xFF9CA3AF);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ── Interest Dimension Colours ─────────────────────────────────────────────
  static const Color dimensionCreative = Color(0xFFF472B6);       // C — pink
  static const Color dimensionAnalytical = Color(0xFF60A5FA);     // A — blue
  static const Color dimensionSocial = Color(0xFF34D399);         // S — green
  static const Color dimensionTechnical = Color(0xFFFBBF24);      // T — amber
  static const Color dimensionEntrepreneurial = Color(0xFFA78BFA); // E — violet
  static const Color dimensionPhysical = Color(0xFFFB923C);       // P — orange

  // Light variants for dimension chip backgrounds
  static const Color dimensionCreativeLight = Color(0xFFFCE7F3);
  static const Color dimensionAnalyticalLight = Color(0xFFDBEAFE);
  static const Color dimensionSocialLight = Color(0xFFD1FAE5);
  static const Color dimensionTechnicalLight = Color(0xFFFEF3C7);
  static const Color dimensionEntrepreneurialLight = Color(0xFFEDE9FE);
  static const Color dimensionPhysicalLight = Color(0xFFFFEDD5);

  // ── Match Score Gradient ───────────────────────────────────────────────────
  static const List<Color> matchScoreGradient = [
    Color(0xFF6C63FF),
    Color(0xFF9C88FF),
  ];

  // ── Shimmer ────────────────────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFFE8E8EE);
  static const Color shimmerHighlight = Color(0xFFF4F4F8);

  /// Returns the foreground color for a dimension code (C/A/S/T/E/P).
  static Color forDimension(String code) {
    switch (code.toUpperCase()) {
      case 'C': return dimensionCreative;
      case 'A': return dimensionAnalytical;
      case 'S': return dimensionSocial;
      case 'T': return dimensionTechnical;
      case 'E': return dimensionEntrepreneurial;
      case 'P': return dimensionPhysical;
      default:  return primary;
    }
  }

  /// Returns the background/light color for a dimension code.
  static Color lightForDimension(String code) {
    switch (code.toUpperCase()) {
      case 'C': return dimensionCreativeLight;
      case 'A': return dimensionAnalyticalLight;
      case 'S': return dimensionSocialLight;
      case 'T': return dimensionTechnicalLight;
      case 'E': return dimensionEntrepreneurialLight;
      case 'P': return dimensionPhysicalLight;
      default:  return primaryLight;
    }
  }
}
