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
  final CuDensityTokens density;
  final CuLocaleTokens locale;
  final Brightness brightness;
  final bool hapticsEnabled;
  final bool soundsEnabled;

  const CuThemeData({
    required this.colors,
    this.typography = const CuTypographyTokens(),
    this.spacing = const CuSpacingTokens(),
    this.radius = const CuRadiusTokens(),
    required this.shadows,
    this.breakpoints = const CuBreakpointTokens(),
    this.animation = const CuAnimationTokens(),
    this.borders = const CuBorderTokens(),
    this.density = const CuDensityTokens(),
    this.locale = const CuLocaleTokens(),
    required this.brightness,
    this.hapticsEnabled = true,
    this.soundsEnabled = true,
  });

  /// Light theme preset
  factory CuThemeData.light({
    CuDensity density = CuDensity.comfortable,
    CuLanguage language = CuLanguage.english,
    CuVerbosity verbosity = CuVerbosity.standard,
    bool hapticsEnabled = true,
    bool soundsEnabled = true,
  }) => CuThemeData(
        colors: lightColorTokens,
        shadows: lightShadowTokens,
        brightness: Brightness.light,
        density: CuDensityTokens(density: density),
        locale: CuLocaleTokens(
          language: language,
          verbosity: verbosity,
          strings: CuLocaleTokens.getStrings(language, verbosity),
        ),
        hapticsEnabled: hapticsEnabled,
        soundsEnabled: soundsEnabled,
      );

  /// Dark theme preset
  factory CuThemeData.dark({
    CuDensity density = CuDensity.comfortable,
    CuLanguage language = CuLanguage.english,
    CuVerbosity verbosity = CuVerbosity.standard,
    bool hapticsEnabled = true,
    bool soundsEnabled = true,
  }) => CuThemeData(
        colors: darkColorTokens,
        shadows: darkShadowTokens,
        brightness: Brightness.dark,
        density: CuDensityTokens(density: density),
        locale: CuLocaleTokens(
          language: language,
          verbosity: verbosity,
          strings: CuLocaleTokens.getStrings(language, verbosity),
        ),
        hapticsEnabled: hapticsEnabled,
        soundsEnabled: soundsEnabled,
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
    CuDensityTokens? density,
    CuLocaleTokens? locale,
    Brightness? brightness,
    bool? hapticsEnabled,
    bool? soundsEnabled,
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
      density: density ?? this.density,
      locale: locale ?? this.locale,
      brightness: brightness ?? this.brightness,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      soundsEnabled: soundsEnabled ?? this.soundsEnabled,
    );
  }

  /// Get localized strings
  CuLocaleStrings get strings => locale.strings;

  /// Check if theme is dark
  bool get isDark => brightness == Brightness.dark;

  /// Check if theme is light
  bool get isLight => brightness == Brightness.light;

  /// Portal/overlay opacity based on theme
  double get portalOpacity => isDark ? 0.75 : 0.25;

  /// Scale spacing by density
  double scaleSpacing(double value) => value * density.multiplier;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CuThemeData &&
           other.brightness == brightness &&
           other.density.density == density.density &&
           other.locale.language == locale.language;
  }

  @override
  int get hashCode => Object.hash(brightness, density.density, locale.language);
}
