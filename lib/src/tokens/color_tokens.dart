import 'package:flutter/widgets.dart';

/// Semantic color with light/lighter/dark variants
@immutable
class SemanticColor {
  final Color base;
  final Color light;
  final Color lighter;
  final Color dark;

  const SemanticColor({
    required this.base,
    required this.light,
    required this.lighter,
    required this.dark,
  });

  SemanticColor copyWith({
    Color? base,
    Color? light,
    Color? lighter,
    Color? dark,
  }) {
    return SemanticColor(
      base: base ?? this.base,
      light: light ?? this.light,
      lighter: lighter ?? this.lighter,
      dark: dark ?? this.dark,
    );
  }
}

/// CU UI Color Token System
/// Implements 8-level accent scale with semantic colors
@immutable
class CuColorTokens {
  // ============================================
  // ACCENT SCALE (8 levels) - Primary brand colors
  // ============================================
  final Color accents1; // Lightest - backgrounds
  final Color accents2; // Light hover states
  final Color accents3; // Subtle borders
  final Color accents4; // Muted text
  final Color accents5; // Secondary text
  final Color accents6; // Primary text
  final Color accents7; // Bold emphasis
  final Color accents8; // Darkest - high contrast

  // ============================================
  // SEMANTIC COLORS (with variants)
  // ============================================
  final SemanticColor error;
  final SemanticColor success;
  final SemanticColor warning;
  final SemanticColor cyan;
  final SemanticColor violet;

  // ============================================
  // SURFACE COLORS
  // ============================================
  final Color background;
  final Color foreground;
  final Color selection;
  final Color secondary;
  final Color code;
  final Color border;
  final Color link;

  // ============================================
  // SPECIAL COLORS
  // ============================================
  final Color purple;
  final Color magenta;
  final Color alert;

  const CuColorTokens({
    required this.accents1,
    required this.accents2,
    required this.accents3,
    required this.accents4,
    required this.accents5,
    required this.accents6,
    required this.accents7,
    required this.accents8,
    required this.error,
    required this.success,
    required this.warning,
    required this.cyan,
    required this.violet,
    required this.background,
    required this.foreground,
    required this.selection,
    required this.secondary,
    required this.code,
    required this.border,
    required this.link,
    required this.purple,
    required this.magenta,
    required this.alert,
  });

  CuColorTokens copyWith({
    Color? accents1,
    Color? accents2,
    Color? accents3,
    Color? accents4,
    Color? accents5,
    Color? accents6,
    Color? accents7,
    Color? accents8,
    SemanticColor? error,
    SemanticColor? success,
    SemanticColor? warning,
    SemanticColor? cyan,
    SemanticColor? violet,
    Color? background,
    Color? foreground,
    Color? selection,
    Color? secondary,
    Color? code,
    Color? border,
    Color? link,
    Color? purple,
    Color? magenta,
    Color? alert,
  }) {
    return CuColorTokens(
      accents1: accents1 ?? this.accents1,
      accents2: accents2 ?? this.accents2,
      accents3: accents3 ?? this.accents3,
      accents4: accents4 ?? this.accents4,
      accents5: accents5 ?? this.accents5,
      accents6: accents6 ?? this.accents6,
      accents7: accents7 ?? this.accents7,
      accents8: accents8 ?? this.accents8,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      cyan: cyan ?? this.cyan,
      violet: violet ?? this.violet,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      selection: selection ?? this.selection,
      secondary: secondary ?? this.secondary,
      code: code ?? this.code,
      border: border ?? this.border,
      link: link ?? this.link,
      purple: purple ?? this.purple,
      magenta: magenta ?? this.magenta,
      alert: alert ?? this.alert,
    );
  }
}

/// Light theme color tokens
const lightColorTokens = CuColorTokens(
  // Accent scale (light to dark)
  accents1: Color(0xFFFAFAFA), // #fafafa
  accents2: Color(0xFFEAEAEA), // #eaeaea
  accents3: Color(0xFF999999), // #999
  accents4: Color(0xFF888888), // #888
  accents5: Color(0xFF666666), // #666
  accents6: Color(0xFF444444), // #444
  accents7: Color(0xFF333333), // #333
  accents8: Color(0xFF111111), // #111

  // Semantic colors
  error: SemanticColor(
    base: Color(0xFFEE0000), // #e00
    light: Color(0xFFFF1A1A), // #ff1a1a
    lighter: Color(0xFFF7D4D6), // #f7d4d6
    dark: Color(0xFFC50000), // #c50000
  ),
  success: SemanticColor(
    base: Color(0xFF0070F3), // #0070f3
    light: Color(0xFF3291FF), // #3291ff
    lighter: Color(0xFFD3E5FF), // #d3e5ff
    dark: Color(0xFF0761D1), // #0761d1
  ),
  warning: SemanticColor(
    base: Color(0xFFF5A623), // #f5a623
    light: Color(0xFFF7B955), // #f7b955
    lighter: Color(0xFFFFEFCF), // #ffefcf
    dark: Color(0xFFAB570A), // #ab570a
  ),
  cyan: SemanticColor(
    base: Color(0xFF50E3C2), // #50e3c2
    light: Color(0xFF79FFE1), // #79ffe1
    lighter: Color(0xFFAAFFEC), // #aaffec
    dark: Color(0xFF29BC9B), // #29bc9b
  ),
  violet: SemanticColor(
    base: Color(0xFF7928CA), // #7928ca
    light: Color(0xFF8A63D2), // #8a63d2
    lighter: Color(0xFFE3D7FC), // #e3d7fc
    dark: Color(0xFF4C2889), // #4c2889
  ),

  // Surface colors
  background: Color(0xFFFFFFFF), // #fff
  foreground: Color(0xFF000000), // #000
  selection: Color(0xFF79FFE1), // #79ffe1
  secondary: Color(0xFF666666), // #666
  code: Color(0xFFF81CE5), // #f81ce5
  border: Color(0xFFEAEAEA), // #eaeaea
  link: Color(0xFF0070F3), // #0070f3

  // Special colors
  purple: Color(0xFFF81CE5), // #f81ce5
  magenta: Color(0xFFEB367F), // #eb367f
  alert: Color(0xFFFF0080), // #ff0080
);

/// Dark theme color tokens
const darkColorTokens = CuColorTokens(
  // Accent scale (inverted - dark to light)
  accents1: Color(0xFF111111), // #111
  accents2: Color(0xFF333333), // #333
  accents3: Color(0xFF444444), // #444
  accents4: Color(0xFF666666), // #666
  accents5: Color(0xFF888888), // #888
  accents6: Color(0xFF999999), // #999
  accents7: Color(0xFFEAEAEA), // #eaeaea
  accents8: Color(0xFFFAFAFA), // #fafafa

  // Semantic colors (same as light)
  error: SemanticColor(
    base: Color(0xFFEE0000),
    light: Color(0xFFFF1A1A),
    lighter: Color(0xFFF7D4D6),
    dark: Color(0xFFC50000),
  ),
  success: SemanticColor(
    base: Color(0xFF0070F3),
    light: Color(0xFF3291FF),
    lighter: Color(0xFFD3E5FF),
    dark: Color(0xFF0761D1),
  ),
  warning: SemanticColor(
    base: Color(0xFFF5A623),
    light: Color(0xFFF7B955),
    lighter: Color(0xFFFFEFCF),
    dark: Color(0xFFAB570A),
  ),
  cyan: SemanticColor(
    base: Color(0xFF50E3C2),
    light: Color(0xFF79FFE1),
    lighter: Color(0xFFAAFFEC),
    dark: Color(0xFF29BC9B),
  ),
  violet: SemanticColor(
    base: Color(0xFF7928CA),
    light: Color(0xFF8A63D2),
    lighter: Color(0xFFE3D7FC),
    dark: Color(0xFF4C2889),
  ),

  // Surface colors (inverted)
  background: Color(0xFF000000), // #000
  foreground: Color(0xFFFFFFFF), // #fff
  selection: Color(0xFFF81CE5), // #f81ce5
  secondary: Color(0xFF888888), // #888
  code: Color(0xFF79FFE1), // #79ffe1
  border: Color(0xFF333333), // #333
  link: Color(0xFF3291FF), // #3291ff

  // Special colors
  purple: Color(0xFFF81CE5),
  magenta: Color(0xFFEB367F),
  alert: Color(0xFFFF0080),
);

/// Animation-specific color palette
class CuAnimationColors {
  CuAnimationColors._();

  // Mode-specific gradient colors
  static const Color purple500 = Color(0xFFa855f7);
  static const Color pink500 = Color(0xFFec4899);
  static const Color indigo900 = Color(0xFF312e81);
  static const Color indigo950 = Color(0xFF1e1b4b);
  static const Color teal400 = Color(0xFF2dd4bf);
  static const Color cyan500 = Color(0xFF06b6d4);
  static const Color blue900 = Color(0xFF1e3a8a);
  static const Color emerald400 = Color(0xFF34d399);
  static const Color green500 = Color(0xFF22c55e);
  static const Color red500 = Color(0xFFef4444);
  static const Color orange500 = Color(0xFFf97316);
  static const Color amber400 = Color(0xFFfbbf24);
  static const Color violet950 = Color(0xFF2e1065);
  static const Color purple950 = Color(0xFF3b0764);
  static const Color slate900 = Color(0xFF0f172a);
  static const Color slate950 = Color(0xFF020617);

  // Glass UI colors
  static const Color glassBackground = Color(0x0DFFFFFF); // 5% white
  static const Color glassBorder = Color(0x1AFFFFFF); // 10% white
  static const Color glassHover = Color(0x26FFFFFF); // 15% white
  static const Color textMuted = Color(0x99FFFFFF); // 60% white
  static const Color textSubtle = Color(0x80FFFFFF); // 50% white
}
