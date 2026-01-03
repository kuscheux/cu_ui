import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';

/// Base mixin for all CU UI components
mixin CuComponentMixin<T extends StatefulWidget> on State<T> {
  /// Access theme tokens
  CuThemeData get theme => context.cu;
  CuColorTokens get colors => theme.colors;
  CuTypographyTokens get typography => theme.typography;
  CuSpacingTokens get spacing => theme.spacing;
  CuRadiusTokens get radius => theme.radius;
  CuShadowTokens get shadows => theme.shadows;
  CuAnimationTokens get animation => theme.animation;
  CuBorderTokens get borders => theme.borders;
  CuBreakpointTokens get breakpoints => theme.breakpoints;

  /// Check if dark mode
  bool get isDark => theme.isDark;

  /// Get current breakpoint
  CuBreakpoint get breakpoint => context.cuBreakpoint;
}

/// Component size variants
enum CuSize {
  small,
  medium,
  large,
}

/// Component type variants (for buttons, badges, notes, etc.)
enum CuVariant {
  default_,
  secondary,
  success,
  warning,
  error,
}

/// Resolve size-specific values
extension CuSizeResolver on CuSize {
  T resolve<T>({
    required T small,
    required T medium,
    required T large,
  }) {
    switch (this) {
      case CuSize.small:
        return small;
      case CuSize.medium:
        return medium;
      case CuSize.large:
        return large;
    }
  }
}

/// Resolve variant-specific colors
extension CuVariantColors on CuVariant {
  Color resolveColor(CuColorTokens colors) {
    switch (this) {
      case CuVariant.default_:
        return colors.foreground;
      case CuVariant.secondary:
        return colors.secondary;
      case CuVariant.success:
        return colors.success.base;
      case CuVariant.warning:
        return colors.warning.base;
      case CuVariant.error:
        return colors.error.base;
    }
  }

  Color resolveLightColor(CuColorTokens colors) {
    switch (this) {
      case CuVariant.default_:
        return colors.accents2;
      case CuVariant.secondary:
        return colors.accents3;
      case CuVariant.success:
        return colors.success.light;
      case CuVariant.warning:
        return colors.warning.light;
      case CuVariant.error:
        return colors.error.light;
    }
  }

  Color resolveLighterColor(CuColorTokens colors) {
    switch (this) {
      case CuVariant.default_:
        return colors.accents1;
      case CuVariant.secondary:
        return colors.accents2;
      case CuVariant.success:
        return colors.success.lighter;
      case CuVariant.warning:
        return colors.warning.lighter;
      case CuVariant.error:
        return colors.error.lighter;
    }
  }
}
