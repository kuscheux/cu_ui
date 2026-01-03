import 'package:flutter/widgets.dart';

/// CU UI Spacing Token System
/// Base unit: 16px
@immutable
class CuSpacingTokens {
  // ============================================
  // BASE UNIT
  // ============================================
  final double unit; // 16px base

  const CuSpacingTokens({
    this.unit = 16.0,
  });

  // ============================================
  // GAP SCALE (derived from unit)
  // ============================================
  double get gapQuarter => unit * 0.25; // 4px
  double get gapHalf => unit * 0.5; // 8px
  double get gap => unit; // 16px (standard)
  double get gapDouble => unit * 2; // 32px

  // Negative versions
  double get gapQuarterNegative => -gapQuarter;
  double get gapHalfNegative => -gapHalf;
  double get gapNegative => -gap;
  double get gapDoubleNegative => -gapDouble;

  // ============================================
  // NAMED SPACING SCALE
  // ============================================
  double get space0 => 0;
  double get space1 => unit * 0.25; // 4px
  double get space2 => unit * 0.5; // 8px
  double get space3 => unit * 0.75; // 12px
  double get space4 => unit; // 16px
  double get space5 => unit * 1.25; // 20px
  double get space6 => unit * 1.5; // 24px
  double get space8 => unit * 2; // 32px
  double get space10 => unit * 2.5; // 40px
  double get space12 => unit * 3; // 48px
  double get space16 => unit * 4; // 64px
  double get space20 => unit * 5; // 80px
  double get space24 => unit * 6; // 96px

  // ============================================
  // COMPONENT-SPECIFIC SPACING
  // ============================================
  double get pageHorizontalPadding => space6; // 24px
  double get pageVerticalPadding => space8; // 32px
  double get pageMargin => space4; // 16px
  double get cardPadding => space4; // 16px
  double get inputPaddingX => space3; // 12px
  double get inputPaddingY => space2; // 8px
  double get buttonPaddingX => space4; // 16px
  double get buttonPaddingY => space2; // 8px

  // ============================================
  // PAGE LAYOUT
  // ============================================
  double get pageWidth => 750; // 750pt
  double get pageWidthWithMargin => 782; // 782pt

  // ============================================
  // EDGE INSETS HELPERS
  // ============================================
  EdgeInsets get insets0 => EdgeInsets.zero;
  EdgeInsets get insets1 => EdgeInsets.all(space1);
  EdgeInsets get insets2 => EdgeInsets.all(space2);
  EdgeInsets get insets3 => EdgeInsets.all(space3);
  EdgeInsets get insets4 => EdgeInsets.all(space4);
  EdgeInsets get insets6 => EdgeInsets.all(space6);
  EdgeInsets get insets8 => EdgeInsets.all(space8);

  EdgeInsets insetsHorizontal(double multiplier) =>
      EdgeInsets.symmetric(horizontal: unit * multiplier);

  EdgeInsets insetsVertical(double multiplier) =>
      EdgeInsets.symmetric(vertical: unit * multiplier);

  EdgeInsets insetsSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) =>
      EdgeInsets.symmetric(
        horizontal: unit * horizontal,
        vertical: unit * vertical,
      );

  /// Convenience method for custom multipliers
  double custom(double multiplier) => unit * multiplier;

  CuSpacingTokens copyWith({double? unit}) {
    return CuSpacingTokens(unit: unit ?? this.unit);
  }
}
