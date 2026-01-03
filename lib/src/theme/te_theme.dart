import 'package:flutter/widgets.dart';

/// TETheme - Teenage Engineering inspired theme
///
/// Industrial minimal aesthetic inspired by Teenage Engineering products.
/// Features stark black/white contrast with zinc accent colors.
///
/// Uses Geist font exclusively (no monospace).
/// Zero Material dependency - only uses flutter/widgets.dart.
///
/// ## Colors
/// - [background]: Pure black (#000000)
/// - [surface]: Near black for cards (#0A0A0A)
/// - [surfaceElevated]: Elevated surfaces (#141414)
/// - [border]: Subtle zinc border (#27272A)
/// - [text]: Pure white (#FFFFFF)
/// - [textMuted]: Muted zinc (#71717A)
///
/// ## Typography
/// All text uses Geist font with tight tracking.
/// Display styles for large numbers, body for content, labels for UI.
///
/// ## Usage
/// ```dart
/// Container(
///   decoration: TETheme.cardDecoration,
///   child: Text('Content', style: TETheme.body),
/// )
/// ```
class TETheme {
  TETheme._();

  // ============================================
  // COLORS - Stark contrast, industrial
  // ============================================

  /// Pure black background
  static const Color background = Color(0xFF000000);

  /// Near black surface for cards/containers
  static const Color surface = Color(0xFF0A0A0A);

  /// Elevated surface (modal, dropdown)
  static const Color surfaceElevated = Color(0xFF141414);

  /// Border color - zinc-800
  static const Color border = Color(0xFF27272A);

  /// Subtle border for dividers
  static const Color borderSubtle = Color(0xFF1C1C1E);

  /// Primary text - pure white
  static const Color text = Color(0xFFFFFFFF);

  /// Muted text - zinc-500
  static const Color textMuted = Color(0xFF71717A);

  /// Dim text for disabled states - zinc-600
  static const Color textDim = Color(0xFF52525B);

  /// Accent color - white on black
  static const Color accent = Color(0xFFFFFFFF);

  /// Muted accent - zinc-700
  static const Color accentMuted = Color(0xFF3F3F46);

  /// Success state color
  static const Color success = Color(0xFF22C55E);

  /// Warning state color
  static const Color warning = Color(0xFFF59E0B);

  /// Error state color
  static const Color error = Color(0xFFEF4444);

  /// Info state color
  static const Color info = Color(0xFF3B82F6);

  // ============================================
  // TYPOGRAPHY - Geist only (NO mono)
  // ============================================

  /// Font family - Geist
  static const String fontFamily = 'Geist';

  /// Display large - for big numbers/scores (64px)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 64,
    fontWeight: FontWeight.w500,
    letterSpacing: -2,
    height: 1,
    color: text,
  );

  /// Display medium - for featured numbers (48px)
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w500,
    letterSpacing: -1.5,
    height: 1,
    color: text,
  );

  /// Headline - section headers (18px)
  static const TextStyle headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.3,
    color: text,
  );

  /// Headline small - subsection headers (15px)
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.2,
    color: text,
  );

  /// Body text - primary content (13px)
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: textMuted,
  );

  /// Body small - secondary content (12px)
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: textMuted,
  );

  /// Label - UI labels, all caps style (11px)
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
    color: textMuted,
  );

  /// Label small - tiny labels (10px)
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1,
    color: textDim,
  );

  // ============================================
  // SPACING - Dense, industrial
  // ============================================

  /// Extra extra small spacing (2px)
  static const double spacingXxs = 2;

  /// Extra small spacing (4px)
  static const double spacingXs = 4;

  /// Small spacing (8px)
  static const double spacingSm = 8;

  /// Medium spacing (12px)
  static const double spacingMd = 12;

  /// Large spacing (16px)
  static const double spacingLg = 16;

  /// Extra large spacing (24px)
  static const double spacingXl = 24;

  /// Extra extra large spacing (32px)
  static const double spacingXxl = 32;

  // ============================================
  // BORDERS & RADIUS - Thin, minimal
  // ============================================

  /// Border width (1px)
  static const double borderWidth = 1;

  /// Extra small radius (2px)
  static const double radiusXs = 2;

  /// Small radius (4px)
  static const double radiusSm = 4;

  /// Medium radius (6px)
  static const double radiusMd = 6;

  /// Large radius (8px)
  static const double radiusLg = 8;

  // ============================================
  // COMPONENT DECORATIONS
  // ============================================

  /// Standard card decoration - dark surface with border
  static BoxDecoration cardDecoration = BoxDecoration(
    color: surface,
    border: Border.all(color: border, width: borderWidth),
    borderRadius: BorderRadius.circular(radiusMd),
  );

  /// Elevated card decoration - lighter surface
  static BoxDecoration cardDecorationElevated = BoxDecoration(
    color: surfaceElevated,
    border: Border.all(color: border, width: borderWidth),
    borderRadius: BorderRadius.circular(radiusMd),
  );

  /// Input container decoration (unfocused)
  static BoxDecoration inputDecoration = BoxDecoration(
    color: surface,
    border: Border.all(color: border, width: borderWidth),
    borderRadius: BorderRadius.circular(radiusSm),
  );

  /// Input container decoration (focused)
  static BoxDecoration inputDecorationFocused = BoxDecoration(
    color: surface,
    border: Border.all(color: text, width: borderWidth),
    borderRadius: BorderRadius.circular(radiusSm),
  );

  /// Input container decoration (error)
  static BoxDecoration inputDecorationError = BoxDecoration(
    color: surface,
    border: Border.all(color: error, width: borderWidth),
    borderRadius: BorderRadius.circular(radiusSm),
  );

  /// Primary button decoration
  static BoxDecoration primaryButtonDecoration = BoxDecoration(
    color: text,
    borderRadius: BorderRadius.circular(radiusSm),
  );

  /// Primary button decoration (disabled)
  static BoxDecoration primaryButtonDecorationDisabled = BoxDecoration(
    color: accentMuted,
    borderRadius: BorderRadius.circular(radiusSm),
  );

  /// Secondary button decoration
  static BoxDecoration secondaryButtonDecoration = BoxDecoration(
    color: const Color(0x00000000),
    border: Border.all(color: border, width: borderWidth),
    borderRadius: BorderRadius.circular(radiusSm),
  );

  // ============================================
  // PADDING PRESETS
  // ============================================

  /// Button padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: spacingLg,
    vertical: spacingMd,
  );

  /// Input padding
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: spacingMd,
    vertical: spacingSm,
  );

  /// Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(spacingLg);

  // ============================================
  // STATUS COLORS
  // ============================================

  /// Get color for a status string
  static Color statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONNECTED':
      case 'COMPLIANT':
      case 'ENABLED':
        return success;
      case 'DISCONNECTED':
      case 'PENDING':
        return textDim;
      case 'ERROR':
      case 'NON_COMPLIANT':
      case 'DISABLED':
        return error;
      case 'WARNING':
        return warning;
      default:
        return textMuted;
    }
  }
}
