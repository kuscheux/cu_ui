import 'package:flutter/widgets.dart';

/// CU UI Border Radius Tokens
@immutable
class CuRadiusTokens {
  final double none; // 0px
  final double sm; // 4px
  final double md; // 6px (standard)
  final double lg; // 8px
  final double xl; // 12px
  final double xxl; // 16px
  final double full; // 9999px (pill shape)

  const CuRadiusTokens({
    this.none = 0.0,
    this.sm = 4.0,
    this.md = 6.0,
    this.lg = 8.0,
    this.xl = 12.0,
    this.xxl = 16.0,
    this.full = 9999.0,
  });

  // ============================================
  // BORDER RADIUS HELPERS
  // ============================================
  BorderRadius get noneBorder => BorderRadius.zero;
  BorderRadius get smBorder => BorderRadius.circular(sm);
  BorderRadius get mdBorder => BorderRadius.circular(md);
  BorderRadius get lgBorder => BorderRadius.circular(lg);
  BorderRadius get xlBorder => BorderRadius.circular(xl);
  BorderRadius get xxlBorder => BorderRadius.circular(xxl);
  BorderRadius get fullBorder => BorderRadius.circular(full);

  // ============================================
  // DIRECTIONAL HELPERS
  // ============================================
  BorderRadius topOnly(double radius) => BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      );

  BorderRadius bottomOnly(double radius) => BorderRadius.only(
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );

  BorderRadius leftOnly(double radius) => BorderRadius.only(
        topLeft: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
      );

  BorderRadius rightOnly(double radius) => BorderRadius.only(
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      );

  /// Custom radius
  BorderRadius custom(double radius) => BorderRadius.circular(radius);

  CuRadiusTokens copyWith({
    double? none,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? full,
  }) {
    return CuRadiusTokens(
      none: none ?? this.none,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      full: full ?? this.full,
    );
  }
}
