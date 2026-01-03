import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Tag type variants
enum CuTagType {
  default_,
  secondary,
  success,
  warning,
  error,
  dark,
  lite,
}

/// CU UI Tag Component
/// Matches Geist UI Tag - keyword label
class CuTag extends StatefulWidget {
  /// Tag content
  final Widget? child;

  /// Simple text content
  final String? text;

  /// Tag type
  final CuTagType type;

  /// Inverted colors
  final bool invert;

  /// Size variant
  final CuSize size;

  const CuTag({
    super.key,
    this.child,
    this.text,
    this.type = CuTagType.default_,
    this.invert = false,
    this.size = CuSize.medium,
  });

  /// Create a tag with text
  factory CuTag.text(
    String text, {
    Key? key,
    CuTagType type = CuTagType.default_,
    CuSize size = CuSize.medium,
    bool invert = false,
  }) {
    return CuTag(
      key: key,
      text: text,
      type: type,
      size: size,
      invert: invert,
    );
  }

  @override
  State<CuTag> createState() => _CuTagState();
}

class _CuTagState extends State<CuTag> with CuComponentMixin {
  Color get _backgroundColor {
    if (widget.invert) return _typeColor;

    switch (widget.type) {
      case CuTagType.default_:
      case CuTagType.lite:
        return colors.background;
      case CuTagType.dark:
        return colors.foreground;
      default:
        return _typeColor.withValues(alpha: 0.1);
    }
  }

  Color get _borderColor {
    switch (widget.type) {
      case CuTagType.default_:
        return colors.border;
      case CuTagType.lite:
        return colors.accents2;
      default:
        return _typeColor;
    }
  }

  Color get _typeColor {
    switch (widget.type) {
      case CuTagType.default_:
        return colors.foreground;
      case CuTagType.secondary:
        return colors.secondary;
      case CuTagType.success:
        return colors.success.base;
      case CuTagType.warning:
        return colors.warning.base;
      case CuTagType.error:
        return colors.error.base;
      case CuTagType.dark:
        return colors.foreground;
      case CuTagType.lite:
        return colors.accents5;
    }
  }

  Color get _textColor {
    if (widget.invert) {
      return widget.type == CuTagType.default_ ? colors.background : const Color(0xFFFFFFFF);
    }

    switch (widget.type) {
      case CuTagType.dark:
        return colors.background;
      default:
        return _typeColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = widget.size.resolve(
      small: EdgeInsets.symmetric(horizontal: spacing.space2, vertical: 2),
      medium: EdgeInsets.symmetric(horizontal: spacing.space3, vertical: spacing.space1),
      large: EdgeInsets.symmetric(horizontal: spacing.space4, vertical: spacing.space2),
    );

    final textStyle = widget.size.resolve(
      small: typography.caption,
      medium: typography.bodySmall,
      large: typography.body,
    );

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _backgroundColor,
        border: Border.all(color: _borderColor),
        borderRadius: radius.smBorder,
      ),
      child: DefaultTextStyle(
        style: textStyle.copyWith(color: _textColor),
        child: widget.child ?? Text(widget.text ?? ''),
      ),
    );
  }
}
