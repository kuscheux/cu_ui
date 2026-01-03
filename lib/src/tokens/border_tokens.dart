import 'package:flutter/widgets.dart';

/// CU UI Border Tokens
@immutable
class CuBorderTokens {
  final double widthNone; // 0px
  final double widthThin; // 1px (standard)
  final double widthMedium; // 2px
  final double widthThick; // 4px

  const CuBorderTokens({
    this.widthNone = 0.0,
    this.widthThin = 1.0,
    this.widthMedium = 2.0,
    this.widthThick = 4.0,
  });

  /// Standard border width
  double get width => widthThin;

  /// Create a border with default width
  Border all(Color color, {double? width}) => Border.all(
        color: color,
        width: width ?? widthThin,
      );

  /// Create a border on specific sides
  Border only({
    Color? top,
    Color? right,
    Color? bottom,
    Color? left,
    double? width,
  }) {
    final w = width ?? widthThin;
    return Border(
      top: top != null ? BorderSide(color: top, width: w) : BorderSide.none,
      right:
          right != null ? BorderSide(color: right, width: w) : BorderSide.none,
      bottom: bottom != null
          ? BorderSide(color: bottom, width: w)
          : BorderSide.none,
      left: left != null ? BorderSide(color: left, width: w) : BorderSide.none,
    );
  }

  /// Create a horizontal border (top and bottom)
  Border horizontal(Color color, {double? width}) {
    final w = width ?? widthThin;
    return Border(
      top: BorderSide(color: color, width: w),
      bottom: BorderSide(color: color, width: w),
    );
  }

  /// Create a vertical border (left and right)
  Border vertical(Color color, {double? width}) {
    final w = width ?? widthThin;
    return Border(
      left: BorderSide(color: color, width: w),
      right: BorderSide(color: color, width: w),
    );
  }

  /// Create bottom border only
  Border bottom(Color color, {double? width}) {
    return Border(
      bottom: BorderSide(color: color, width: width ?? widthThin),
    );
  }

  /// Create top border only
  Border top(Color color, {double? width}) {
    return Border(
      top: BorderSide(color: color, width: width ?? widthThin),
    );
  }

  CuBorderTokens copyWith({
    double? widthNone,
    double? widthThin,
    double? widthMedium,
    double? widthThick,
  }) {
    return CuBorderTokens(
      widthNone: widthNone ?? this.widthNone,
      widthThin: widthThin ?? this.widthThin,
      widthMedium: widthMedium ?? this.widthMedium,
      widthThick: widthThick ?? this.widthThick,
    );
  }
}
