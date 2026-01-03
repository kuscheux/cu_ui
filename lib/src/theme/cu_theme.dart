import 'package:flutter/widgets.dart';
import 'cu_theme_data.dart';
import '../tokens/cu_tokens.dart';

// Re-export for convenience
export 'cu_theme_data.dart';
export '../tokens/cu_tokens.dart';

/// CuTheme InheritedWidget for theme propagation
class CuTheme extends InheritedWidget {
  final CuThemeData theme;

  const CuTheme({
    super.key,
    required this.theme,
    required super.child,
  });

  /// Access theme from context (with listening)
  static CuThemeData of(BuildContext context) {
    final CuTheme? result =
        context.dependOnInheritedWidgetOfExactType<CuTheme>();
    assert(result != null, 'No CuTheme found in context');
    return result!.theme;
  }

  /// Access theme from context (without listening)
  static CuThemeData read(BuildContext context) {
    final CuTheme? result =
        context.findAncestorWidgetOfExactType<CuTheme>();
    assert(result != null, 'No CuTheme found in context');
    return result!.theme;
  }

  /// Try to access theme, returns null if not found
  static CuThemeData? maybeOf(BuildContext context) {
    final CuTheme? result =
        context.dependOnInheritedWidgetOfExactType<CuTheme>();
    return result?.theme;
  }

  @override
  bool updateShouldNotify(CuTheme oldWidget) => theme != oldWidget.theme;
}

/// Extension for convenient theme access
extension CuThemeExtension on BuildContext {
  /// Access full theme data
  CuThemeData get cu => CuTheme.of(this);

  /// Access color tokens
  CuColorTokens get cuColors => cu.colors;

  /// Access typography tokens
  CuTypographyTokens get cuTypography => cu.typography;

  /// Access spacing tokens
  CuSpacingTokens get cuSpacing => cu.spacing;

  /// Access radius tokens
  CuRadiusTokens get cuRadius => cu.radius;

  /// Access shadow tokens
  CuShadowTokens get cuShadows => cu.shadows;

  /// Access breakpoint tokens
  CuBreakpointTokens get cuBreakpoints => cu.breakpoints;

  /// Access animation tokens
  CuAnimationTokens get cuAnimation => cu.animation;

  /// Access border tokens
  CuBorderTokens get cuBorders => cu.borders;

  /// Check if current theme is dark
  bool get cuIsDark => cu.isDark;

  /// Check if current theme is light
  bool get cuIsLight => cu.isLight;

  /// Get current breakpoint based on screen width
  CuBreakpoint get cuBreakpoint {
    final width = MediaQuery.of(this).size.width;
    return cu.breakpoints.fromWidth(width);
  }

  /// Check if screen is mobile size
  bool get cuIsMobile => cuBreakpoint.isMobile;

  /// Check if screen is tablet size
  bool get cuIsTablet => cuBreakpoint.isTablet;

  /// Check if screen is desktop size
  bool get cuIsDesktop => cuBreakpoint.isDesktop;
}
