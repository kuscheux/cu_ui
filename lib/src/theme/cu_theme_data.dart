import 'package:flutter/widgets.dart';
import '../tokens/cu_tokens.dart';

/// Complete CU UI theme configuration
@immutable
class CuThemeData {
  final CuColorTokens colors;
  final CuTypographyTokens typography;
  final CuSpacingTokens spacing;
  final CuRadiusTokens radius;
  final CuShadowTokens shadows;
  final CuBreakpointTokens breakpoints;
  final CuAnimationTokens animation;
  final CuBorderTokens borders;
  final Brightness brightness;

  const CuThemeData({
    required this.colors,
    this.typography = const CuTypographyTokens(),
    this.spacing = const CuSpacingTokens(),
    this.radius = const CuRadiusTokens(),
    required this.shadows,
    this.breakpoints = const CuBreakpointTokens(),
    this.animation = const CuAnimationTokens(),
    this.borders = const CuBorderTokens(),
    required this.brightness,
  });

  /// Light theme preset
  factory CuThemeData.light() => const CuThemeData(
        colors: lightColorTokens,
        shadows: lightShadowTokens,
        brightness: Brightness.light,
      );

  /// Dark theme preset
  factory CuThemeData.dark() => const CuThemeData(
        colors: darkColorTokens,
        shadows: darkShadowTokens,
        brightness: Brightness.dark,
      );

  /// Create copy with overrides
  CuThemeData copyWith({
    CuColorTokens? colors,
    CuTypographyTokens? typography,
    CuSpacingTokens? spacing,
    CuRadiusTokens? radius,
    CuShadowTokens? shadows,
    CuBreakpointTokens? breakpoints,
    CuAnimationTokens? animation,
    CuBorderTokens? borders,
    Brightness? brightness,
  }) {
    return CuThemeData(
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
      shadows: shadows ?? this.shadows,
      breakpoints: breakpoints ?? this.breakpoints,
      animation: animation ?? this.animation,
      borders: borders ?? this.borders,
      brightness: brightness ?? this.brightness,
    );
  }

  /// Check if theme is dark
  bool get isDark => brightness == Brightness.dark;

  /// Check if theme is light
  bool get isLight => brightness == Brightness.light;

  /// Portal/overlay opacity based on theme
  double get portalOpacity => isDark ? 0.75 : 0.25;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CuThemeData && other.brightness == brightness;
  }

  @override
  int get hashCode => brightness.hashCode;
}
