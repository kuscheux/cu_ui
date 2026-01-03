import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Badge type variants
enum CuBadgeType {
  default_,
  secondary,
  success,
  warning,
  error,
}

/// CU UI Badge Component
/// Matches Geist UI Badge - status indicator label
class CuBadge extends StatefulWidget {
  /// Badge content
  final Widget? child;

  /// Simple text content
  final String? text;

  /// Badge type
  final CuBadgeType type;

  /// Dot style (no content, just colored dot)
  final bool dot;

  /// Size variant
  final CuSize size;

  const CuBadge({
    super.key,
    this.child,
    this.text,
    this.type = CuBadgeType.default_,
    this.dot = false,
    this.size = CuSize.medium,
  });

  /// Create a badge with text
  factory CuBadge.text(
    String text, {
    Key? key,
    CuBadgeType type = CuBadgeType.default_,
    CuSize size = CuSize.medium,
  }) {
    return CuBadge(
      key: key,
      text: text,
      type: type,
      size: size,
    );
  }

  /// Create a success badge
  factory CuBadge.success([String? text]) {
    return CuBadge(text: text, type: CuBadgeType.success);
  }

  /// Create a warning badge
  factory CuBadge.warning([String? text]) {
    return CuBadge(text: text, type: CuBadgeType.warning);
  }

  /// Create an error badge
  factory CuBadge.error([String? text]) {
    return CuBadge(text: text, type: CuBadgeType.error);
  }

  /// Create a dot badge
  factory CuBadge.dot({
    Key? key,
    CuBadgeType type = CuBadgeType.default_,
  }) {
    return CuBadge(key: key, type: type, dot: true);
  }

  @override
  State<CuBadge> createState() => _CuBadgeState();
}

class _CuBadgeState extends State<CuBadge> with CuComponentMixin {
  Color get _backgroundColor {
    switch (widget.type) {
      case CuBadgeType.default_:
        return colors.foreground;
      case CuBadgeType.secondary:
        return colors.secondary;
      case CuBadgeType.success:
        return colors.success.base;
      case CuBadgeType.warning:
        return colors.warning.base;
      case CuBadgeType.error:
        return colors.error.base;
    }
  }

  Color get _textColor {
    if (widget.type == CuBadgeType.default_) {
      return colors.background;
    }
    return const Color(0xFFFFFFFF);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dot) {
      final dotSize = widget.size.resolve(
        small: 6.0,
        medium: 8.0,
        large: 10.0,
      );
      return Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(
          color: _backgroundColor,
          shape: BoxShape.circle,
        ),
      );
    }

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
        borderRadius: radius.fullBorder,
      ),
      child: DefaultTextStyle(
        style: textStyle.copyWith(color: _textColor, fontWeight: typography.weightMedium),
        child: widget.child ?? Text(widget.text ?? ''),
      ),
    );
  }
}

/// Badge Anchor Component - wraps content with positioned badge
class CuBadgeAnchor extends StatefulWidget {
  /// Main content
  final Widget child;

  /// Badge to show
  final CuBadge badge;

  /// Badge placement
  final Alignment placement;

  const CuBadgeAnchor({
    super.key,
    required this.child,
    required this.badge,
    this.placement = Alignment.topRight,
  });

  @override
  State<CuBadgeAnchor> createState() => _CuBadgeAnchorState();
}

class _CuBadgeAnchorState extends State<CuBadgeAnchor> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    double? top, right, bottom, left;

    if (widget.placement.y < 0) {
      top = 0;
    } else if (widget.placement.y > 0) {
      bottom = 0;
    }

    if (widget.placement.x < 0) {
      left = 0;
    } else if (widget.placement.x > 0) {
      right = 0;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        Positioned(
          top: top,
          right: right,
          bottom: bottom,
          left: left,
          child: Transform.translate(
            offset: Offset(
              widget.placement.x > 0 ? 8 : (widget.placement.x < 0 ? -8 : 0),
              widget.placement.y < 0 ? -8 : (widget.placement.y > 0 ? 8 : 0),
            ),
            child: widget.badge,
          ),
        ),
      ],
    );
  }
}
