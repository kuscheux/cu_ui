import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Divider type variants
enum CuDividerType {
  default_,
  secondary,
  success,
  warning,
  error,
  dark,
  lite,
}

/// Divider text alignment
enum CuDividerAlign {
  center,
  start,
  end,
}

/// CU UI Divider Component
/// Matches Geist UI Divider - horizontal line separator
class CuDivider extends StatefulWidget {
  /// Divider type/color variant
  final CuDividerType type;

  /// Text alignment when using child text
  final CuDividerAlign align;

  /// Optional text to display on divider
  final Widget? child;

  /// Vertical margin
  final double? margin;

  /// Custom height/thickness
  final double? thickness;

  const CuDivider({
    super.key,
    this.type = CuDividerType.default_,
    this.align = CuDividerAlign.center,
    this.child,
    this.margin,
    this.thickness,
  });

  @override
  State<CuDivider> createState() => _CuDividerState();
}

class _CuDividerState extends State<CuDivider> with CuComponentMixin {
  Color get _color {
    switch (widget.type) {
      case CuDividerType.default_:
        return colors.border;
      case CuDividerType.secondary:
        return colors.secondary;
      case CuDividerType.success:
        return colors.success.light;
      case CuDividerType.warning:
        return colors.warning.light;
      case CuDividerType.error:
        return colors.error.light;
      case CuDividerType.dark:
        return colors.foreground;
      case CuDividerType.lite:
        return colors.accents1;
    }
  }

  Color get _textColor {
    if (widget.type == CuDividerType.default_) {
      return colors.foreground;
    }
    return _color;
  }

  @override
  Widget build(BuildContext context) {
    final margin = widget.margin ?? spacing.space2;
    final thickness = widget.thickness ?? 1.0;

    if (widget.child == null) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: margin),
        height: thickness,
        color: _color,
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: margin),
      child: Row(
        children: [
          if (widget.align != CuDividerAlign.start)
            Expanded(
              flex: widget.align == CuDividerAlign.center ? 1 : 9,
              child: Container(height: thickness, color: _color),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.space3),
            child: DefaultTextStyle(
              style: typography.body.copyWith(
                color: _textColor,
                fontWeight: FontWeight.bold,
              ),
              child: widget.child!,
            ),
          ),
          if (widget.align != CuDividerAlign.end)
            Expanded(
              flex: widget.align == CuDividerAlign.center ? 1 : 9,
              child: Container(height: thickness, color: _color),
            ),
        ],
      ),
    );
  }
}
