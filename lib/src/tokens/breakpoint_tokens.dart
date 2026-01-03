import 'package:flutter/widgets.dart';

/// CU UI Responsive Breakpoint Tokens
@immutable
class CuBreakpointTokens {
  final double xs; // 0px - Mobile small
  final double sm; // 650px - Mobile large/Tablet
  final double md; // 900px - Tablet landscape
  final double lg; // 1280px - Desktop
  final double xl; // 1920px - Large desktop

  const CuBreakpointTokens({
    this.xs = 0,
    this.sm = 650,
    this.md = 900,
    this.lg = 1280,
    this.xl = 1920,
  });

  /// Get current breakpoint from width
  CuBreakpoint fromWidth(double width) {
    if (width >= xl) return CuBreakpoint.xl;
    if (width >= lg) return CuBreakpoint.lg;
    if (width >= md) return CuBreakpoint.md;
    if (width >= sm) return CuBreakpoint.sm;
    return CuBreakpoint.xs;
  }

  /// Check if width is at or above breakpoint
  bool isAtLeast(double width, CuBreakpoint breakpoint) {
    switch (breakpoint) {
      case CuBreakpoint.xs:
        return width >= xs;
      case CuBreakpoint.sm:
        return width >= sm;
      case CuBreakpoint.md:
        return width >= md;
      case CuBreakpoint.lg:
        return width >= lg;
      case CuBreakpoint.xl:
        return width >= xl;
    }
  }

  /// Check if width is below breakpoint
  bool isBelow(double width, CuBreakpoint breakpoint) {
    switch (breakpoint) {
      case CuBreakpoint.xs:
        return false; // Nothing is below xs
      case CuBreakpoint.sm:
        return width < sm;
      case CuBreakpoint.md:
        return width < md;
      case CuBreakpoint.lg:
        return width < lg;
      case CuBreakpoint.xl:
        return width < xl;
    }
  }

  /// Get max width for breakpoint
  double maxWidth(CuBreakpoint breakpoint) {
    switch (breakpoint) {
      case CuBreakpoint.xs:
        return sm - 1;
      case CuBreakpoint.sm:
        return md - 1;
      case CuBreakpoint.md:
        return lg - 1;
      case CuBreakpoint.lg:
        return xl - 1;
      case CuBreakpoint.xl:
        return double.infinity;
    }
  }

  /// Get min width for breakpoint
  double minWidth(CuBreakpoint breakpoint) {
    switch (breakpoint) {
      case CuBreakpoint.xs:
        return xs;
      case CuBreakpoint.sm:
        return sm;
      case CuBreakpoint.md:
        return md;
      case CuBreakpoint.lg:
        return lg;
      case CuBreakpoint.xl:
        return xl;
    }
  }

  CuBreakpointTokens copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
  }) {
    return CuBreakpointTokens(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }
}

/// Breakpoint enum
enum CuBreakpoint {
  xs, // Mobile
  sm, // Tablet
  md, // Tablet landscape
  lg, // Desktop
  xl, // Large desktop
}

/// Extension for responsive values
extension CuBreakpointExtension on CuBreakpoint {
  /// Resolve value based on breakpoint
  T resolve<T>({
    required T xs,
    T? sm,
    T? md,
    T? lg,
    T? xl,
  }) {
    switch (this) {
      case CuBreakpoint.xl:
        return xl ?? lg ?? md ?? sm ?? xs;
      case CuBreakpoint.lg:
        return lg ?? md ?? sm ?? xs;
      case CuBreakpoint.md:
        return md ?? sm ?? xs;
      case CuBreakpoint.sm:
        return sm ?? xs;
      case CuBreakpoint.xs:
        return xs;
    }
  }

  /// Check if this breakpoint is at least the given breakpoint
  bool isAtLeast(CuBreakpoint other) {
    return index >= other.index;
  }

  /// Check if this breakpoint is below the given breakpoint
  bool isBelow(CuBreakpoint other) {
    return index < other.index;
  }

  /// Is mobile (xs or sm)
  bool get isMobile => this == CuBreakpoint.xs || this == CuBreakpoint.sm;

  /// Is tablet (md)
  bool get isTablet => this == CuBreakpoint.md;

  /// Is desktop (lg or xl)
  bool get isDesktop => this == CuBreakpoint.lg || this == CuBreakpoint.xl;
}
