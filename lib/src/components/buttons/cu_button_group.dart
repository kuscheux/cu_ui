import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../_base/cu_component.dart';
import '../feedback/cu_spinner.dart';
import 'cu_button.dart';

/// Axis direction for button group layout
enum CuButtonGroupDirection {
  horizontal,
  vertical,
}

/// CU UI Button Group Component
/// Groups multiple buttons together with shared borders
class CuButtonGroup extends StatefulWidget {
  /// The buttons to display in the group
  final List<CuButton> children;

  /// The direction of the button group layout
  final CuButtonGroupDirection direction;

  /// Size of all buttons in the group (overrides individual button sizes)
  final CuSize? size;

  /// Whether the group should expand to fill available space
  final bool expanded;

  const CuButtonGroup({
    super.key,
    required this.children,
    this.direction = CuButtonGroupDirection.horizontal,
    this.size,
    this.expanded = false,
  }) : assert(children.length > 0, 'CuButtonGroup requires at least one child');

  /// Horizontal button group factory
  factory CuButtonGroup.horizontal({
    Key? key,
    required List<CuButton> children,
    CuSize? size,
    bool expanded = false,
  }) {
    return CuButtonGroup(
      key: key,
      direction: CuButtonGroupDirection.horizontal,
      size: size,
      expanded: expanded,
      children: children,
    );
  }

  /// Vertical button group factory
  factory CuButtonGroup.vertical({
    Key? key,
    required List<CuButton> children,
    CuSize? size,
    bool expanded = false,
  }) {
    return CuButtonGroup(
      key: key,
      direction: CuButtonGroupDirection.vertical,
      size: size,
      expanded: expanded,
      children: children,
    );
  }

  @override
  State<CuButtonGroup> createState() => _CuButtonGroupState();
}

class _CuButtonGroupState extends State<CuButtonGroup> with CuComponentMixin {
  bool get _isHorizontal =>
      widget.direction == CuButtonGroupDirection.horizontal;

  @override
  Widget build(BuildContext context) {
    final children = widget.children;
    final count = children.length;

    if (count == 0) return const SizedBox.shrink();

    final wrappedChildren = <Widget>[];

    for (int i = 0; i < count; i++) {
      final isFirst = i == 0;
      final isLast = i == count - 1;

      wrappedChildren.add(
        _CuButtonGroupItem(
          button: children[i],
          isFirst: isFirst,
          isLast: isLast,
          isHorizontal: _isHorizontal,
          size: widget.size ?? children[i].size,
          expanded: widget.expanded,
        ),
      );
    }

    if (_isHorizontal) {
      return widget.expanded
          ? Row(
              mainAxisSize: MainAxisSize.max,
              children: wrappedChildren,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: wrappedChildren,
            );
    } else {
      return widget.expanded
          ? Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: wrappedChildren,
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: wrappedChildren,
            );
    }
  }
}

/// Internal widget for rendering individual buttons within a group
class _CuButtonGroupItem extends StatefulWidget {
  final CuButton button;
  final bool isFirst;
  final bool isLast;
  final bool isHorizontal;
  final CuSize size;
  final bool expanded;

  const _CuButtonGroupItem({
    required this.button,
    required this.isFirst,
    required this.isLast,
    required this.isHorizontal,
    required this.size,
    required this.expanded,
  });

  @override
  State<_CuButtonGroupItem> createState() => _CuButtonGroupItemState();
}

class _CuButtonGroupItemState extends State<_CuButtonGroupItem>
    with CuComponentMixin {
  bool _isHovered = false;

  bool get _isDisabled => widget.button.disabled || widget.button.loading;

  @override
  Widget build(BuildContext context) {
    final button = widget.button;
    final borderRadius = _getBorderRadius();

    Widget child = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor:
          _isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _isDisabled ? null : button.onPressed,
        child: AnimatedContainer(
          duration: animation.normal,
          curve: animation.ease,
          padding: _padding,
          decoration: BoxDecoration(
            color: _backgroundColor,
            border: _getBorder(),
            borderRadius: borderRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (button.loading)
                Padding(
                  padding: EdgeInsets.only(right: spacing.space2),
                  child: CuSpinner(size: _iconSize, color: _textColor),
                )
              else if (button.icon != null)
                Padding(
                  padding: EdgeInsets.only(right: spacing.space2),
                  child: Icon(button.icon, size: _iconSize, color: _textColor),
                ),
              DefaultTextStyle(
                style: _textStyle,
                child: button.child,
              ),
              if (button.iconRight != null)
                Padding(
                  padding: EdgeInsets.only(left: spacing.space2),
                  child:
                      Icon(button.iconRight, size: _iconSize, color: _textColor),
                ),
            ],
          ),
        ),
      ),
    );

    if (widget.expanded && widget.isHorizontal) {
      return Expanded(child: child);
    }

    return child;
  }

  BorderRadius _getBorderRadius() {
    final r = radius.md;

    if (widget.isHorizontal) {
      // Horizontal layout
      if (widget.isFirst && widget.isLast) {
        // Single button - full radius
        return BorderRadius.circular(r);
      } else if (widget.isFirst) {
        // First button - left radius only
        return BorderRadius.only(
          topLeft: Radius.circular(r),
          bottomLeft: Radius.circular(r),
        );
      } else if (widget.isLast) {
        // Last button - right radius only
        return BorderRadius.only(
          topRight: Radius.circular(r),
          bottomRight: Radius.circular(r),
        );
      } else {
        // Middle button - no radius
        return BorderRadius.zero;
      }
    } else {
      // Vertical layout
      if (widget.isFirst && widget.isLast) {
        // Single button - full radius
        return BorderRadius.circular(r);
      } else if (widget.isFirst) {
        // First button - top radius only
        return BorderRadius.only(
          topLeft: Radius.circular(r),
          topRight: Radius.circular(r),
        );
      } else if (widget.isLast) {
        // Last button - bottom radius only
        return BorderRadius.only(
          bottomLeft: Radius.circular(r),
          bottomRight: Radius.circular(r),
        );
      } else {
        // Middle button - no radius
        return BorderRadius.zero;
      }
    }
  }

  Border _getBorder() {
    final borderColor = _borderColor;
    final borderWidth = borders.width;

    if (widget.isHorizontal) {
      // Horizontal layout - remove left border on non-first buttons
      if (widget.isFirst) {
        return Border.all(color: borderColor, width: borderWidth);
      } else {
        return Border(
          top: BorderSide(color: borderColor, width: borderWidth),
          right: BorderSide(color: borderColor, width: borderWidth),
          bottom: BorderSide(color: borderColor, width: borderWidth),
          // No left border - shared with previous button
        );
      }
    } else {
      // Vertical layout - remove top border on non-first buttons
      if (widget.isFirst) {
        return Border.all(color: borderColor, width: borderWidth);
      } else {
        return Border(
          left: BorderSide(color: borderColor, width: borderWidth),
          right: BorderSide(color: borderColor, width: borderWidth),
          bottom: BorderSide(color: borderColor, width: borderWidth),
          // No top border - shared with previous button
        );
      }
    }
  }

  EdgeInsets get _padding => widget.size.resolve(
        small: EdgeInsets.symmetric(
          horizontal: spacing.space3,
          vertical: spacing.space1,
        ),
        medium: EdgeInsets.symmetric(
          horizontal: spacing.space4,
          vertical: spacing.space2,
        ),
        large: EdgeInsets.symmetric(
          horizontal: spacing.space6,
          vertical: spacing.space3,
        ),
      );

  double get _iconSize => widget.size.resolve(
        small: 14.0,
        medium: 16.0,
        large: 20.0,
      );

  Color get _backgroundColor {
    final button = widget.button;
    if (button.ghost) return const Color(0x00000000);
    if (_isDisabled) return colors.accents2;

    switch (button.type) {
      case CuButtonType.default_:
        return _isHovered ? colors.background : colors.foreground;
      case CuButtonType.secondary:
        return _isHovered ? colors.accents2 : colors.background;
      case CuButtonType.success:
        return _isHovered ? colors.success.light : colors.success.base;
      case CuButtonType.warning:
        return _isHovered ? colors.warning.light : colors.warning.base;
      case CuButtonType.error:
        return _isHovered ? colors.error.light : colors.error.base;
      case CuButtonType.secondaryLight:
        return _isHovered ? colors.accents2 : colors.accents1;
      case CuButtonType.successLight:
        return _isHovered ? colors.success.lighter : colors.success.lighter;
      case CuButtonType.warningLight:
        return _isHovered ? colors.warning.lighter : colors.warning.lighter;
      case CuButtonType.errorLight:
        return _isHovered ? colors.error.lighter : colors.error.lighter;
      case CuButtonType.abort:
        return const Color(0x00000000);
    }
  }

  Color get _borderColor {
    final button = widget.button;
    if (button.ghost) {
      return _isHovered ? colors.foreground : colors.border;
    }

    switch (button.type) {
      case CuButtonType.default_:
        return _isHovered ? colors.background : colors.foreground;
      case CuButtonType.secondary:
        return colors.border;
      case CuButtonType.success:
        return _isHovered ? colors.success.light : colors.success.base;
      case CuButtonType.warning:
        return _isHovered ? colors.warning.light : colors.warning.base;
      case CuButtonType.error:
        return _isHovered ? colors.error.light : colors.error.base;
      case CuButtonType.secondaryLight:
        return colors.accents2;
      case CuButtonType.successLight:
        return colors.success.lighter;
      case CuButtonType.warningLight:
        return colors.warning.lighter;
      case CuButtonType.errorLight:
        return colors.error.lighter;
      case CuButtonType.abort:
        return const Color(0x00000000);
    }
  }

  Color get _textColor {
    final button = widget.button;
    if (_isDisabled) return colors.accents4;

    switch (button.type) {
      case CuButtonType.default_:
        return _isHovered ? colors.foreground : colors.background;
      case CuButtonType.secondary:
        return colors.foreground;
      case CuButtonType.success:
      case CuButtonType.warning:
      case CuButtonType.error:
        return const Color(0xFFFFFFFF);
      case CuButtonType.secondaryLight:
        return colors.foreground;
      case CuButtonType.successLight:
        return colors.success.base;
      case CuButtonType.warningLight:
        return colors.warning.base;
      case CuButtonType.errorLight:
        return colors.error.base;
      case CuButtonType.abort:
        return colors.accents5;
    }
  }

  TextStyle get _textStyle => widget.size.resolve(
        small: typography.bodySmall
            .copyWith(color: _textColor, fontWeight: typography.weightMedium),
        medium: typography.body
            .copyWith(color: _textColor, fontWeight: typography.weightMedium),
        large: typography.bodyLarge
            .copyWith(color: _textColor, fontWeight: typography.weightMedium),
      );
}
