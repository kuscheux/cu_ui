import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Tooltip placement options
enum CuTooltipPlacement {
  top,
  topStart,
  topEnd,
  bottom,
  bottomStart,
  bottomEnd,
  left,
  leftStart,
  leftEnd,
  right,
  rightStart,
  rightEnd,
}

/// Tooltip type variants
enum CuTooltipType {
  default_,
  success,
  warning,
  error,
  secondary,
  dark,
  lite,
}

/// CU UI Tooltip Component
/// Matches Geist UI Tooltip - hover information popup
class CuTooltip extends StatefulWidget {
  /// Trigger widget
  final Widget child;

  /// Tooltip content
  final Widget content;

  /// Simple text content
  final String? text;

  /// Tooltip placement
  final CuTooltipPlacement placement;

  /// Tooltip type
  final CuTooltipType type;

  /// Show/hide delay
  final Duration enterDelay;
  final Duration leaveDelay;

  /// Visible state (for controlled tooltip)
  final bool? visible;

  /// Trigger on tap instead of hover
  final bool trigger;

  const CuTooltip({
    super.key,
    required this.child,
    Widget? content,
    this.text,
    this.placement = CuTooltipPlacement.top,
    this.type = CuTooltipType.default_,
    this.enterDelay = Duration.zero,
    this.leaveDelay = const Duration(milliseconds: 150),
    this.visible,
    this.trigger = false,
  }) : content = content ?? const SizedBox.shrink();

  /// Create a tooltip with text
  factory CuTooltip.text({
    Key? key,
    required Widget child,
    required String text,
    CuTooltipPlacement placement = CuTooltipPlacement.top,
    CuTooltipType type = CuTooltipType.default_,
  }) {
    return CuTooltip(
      key: key,
      placement: placement,
      type: type,
      text: text,
      child: child,
    );
  }

  @override
  State<CuTooltip> createState() => _CuTooltipState();
}

class _CuTooltipState extends State<CuTooltip> with CuComponentMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isVisible = false;

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  void _showTooltip() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _TooltipOverlay(
        layerLink: _layerLink,
        placement: widget.placement,
        type: widget.type,
        content: widget.text != null ? Text(widget.text!) : widget.content,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isVisible = true);
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => _isVisible = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle controlled visibility
    if (widget.visible != null) {
      if (widget.visible! && !_isVisible) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _showTooltip());
      } else if (!widget.visible! && _isVisible) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _hideTooltip());
      }
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.trigger
          ? GestureDetector(
              onTap: () {
                if (_isVisible) {
                  _hideTooltip();
                } else {
                  _showTooltip();
                }
              },
              child: widget.child,
            )
          : MouseRegion(
              onEnter: (_) {
                if (widget.visible == null) {
                  Future.delayed(widget.enterDelay, () {
                    if (mounted) _showTooltip();
                  });
                }
              },
              onExit: (_) {
                if (widget.visible == null) {
                  Future.delayed(widget.leaveDelay, () {
                    if (mounted) _hideTooltip();
                  });
                }
              },
              child: widget.child,
            ),
    );
  }
}

class _TooltipOverlay extends StatefulWidget {
  final LayerLink layerLink;
  final CuTooltipPlacement placement;
  final CuTooltipType type;
  final Widget content;

  const _TooltipOverlay({
    required this.layerLink,
    required this.placement,
    required this.type,
    required this.content,
  });

  @override
  State<_TooltipOverlay> createState() => _TooltipOverlayState();
}

class _TooltipOverlayState extends State<_TooltipOverlay> with CuComponentMixin {
  Offset get _offset {
    const gap = 8.0;
    switch (widget.placement) {
      case CuTooltipPlacement.top:
      case CuTooltipPlacement.topStart:
      case CuTooltipPlacement.topEnd:
        return const Offset(0, -gap);
      case CuTooltipPlacement.bottom:
      case CuTooltipPlacement.bottomStart:
      case CuTooltipPlacement.bottomEnd:
        return const Offset(0, gap);
      case CuTooltipPlacement.left:
      case CuTooltipPlacement.leftStart:
      case CuTooltipPlacement.leftEnd:
        return const Offset(-gap, 0);
      case CuTooltipPlacement.right:
      case CuTooltipPlacement.rightStart:
      case CuTooltipPlacement.rightEnd:
        return const Offset(gap, 0);
    }
  }

  Alignment get _targetAnchor {
    switch (widget.placement) {
      case CuTooltipPlacement.top:
        return Alignment.topCenter;
      case CuTooltipPlacement.topStart:
        return Alignment.topLeft;
      case CuTooltipPlacement.topEnd:
        return Alignment.topRight;
      case CuTooltipPlacement.bottom:
        return Alignment.bottomCenter;
      case CuTooltipPlacement.bottomStart:
        return Alignment.bottomLeft;
      case CuTooltipPlacement.bottomEnd:
        return Alignment.bottomRight;
      case CuTooltipPlacement.left:
        return Alignment.centerLeft;
      case CuTooltipPlacement.leftStart:
        return Alignment.topLeft;
      case CuTooltipPlacement.leftEnd:
        return Alignment.bottomLeft;
      case CuTooltipPlacement.right:
        return Alignment.centerRight;
      case CuTooltipPlacement.rightStart:
        return Alignment.topRight;
      case CuTooltipPlacement.rightEnd:
        return Alignment.bottomRight;
    }
  }

  Alignment get _followerAnchor {
    switch (widget.placement) {
      case CuTooltipPlacement.top:
        return Alignment.bottomCenter;
      case CuTooltipPlacement.topStart:
        return Alignment.bottomLeft;
      case CuTooltipPlacement.topEnd:
        return Alignment.bottomRight;
      case CuTooltipPlacement.bottom:
        return Alignment.topCenter;
      case CuTooltipPlacement.bottomStart:
        return Alignment.topLeft;
      case CuTooltipPlacement.bottomEnd:
        return Alignment.topRight;
      case CuTooltipPlacement.left:
        return Alignment.centerRight;
      case CuTooltipPlacement.leftStart:
        return Alignment.topRight;
      case CuTooltipPlacement.leftEnd:
        return Alignment.bottomRight;
      case CuTooltipPlacement.right:
        return Alignment.centerLeft;
      case CuTooltipPlacement.rightStart:
        return Alignment.topLeft;
      case CuTooltipPlacement.rightEnd:
        return Alignment.bottomLeft;
    }
  }

  Color get _backgroundColor {
    switch (widget.type) {
      case CuTooltipType.default_:
        return colors.foreground;
      case CuTooltipType.success:
        return colors.success.base;
      case CuTooltipType.warning:
        return colors.warning.base;
      case CuTooltipType.error:
        return colors.error.base;
      case CuTooltipType.secondary:
        return colors.secondary;
      case CuTooltipType.dark:
        return colors.foreground;
      case CuTooltipType.lite:
        return colors.background;
    }
  }

  Color get _textColor {
    switch (widget.type) {
      case CuTooltipType.lite:
        return colors.foreground;
      default:
        return colors.background;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformFollower(
      link: widget.layerLink,
      offset: _offset,
      targetAnchor: _targetAnchor,
      followerAnchor: _followerAnchor,
      child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.space3,
            vertical: spacing.space2,
          ),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: radius.smBorder,
            boxShadow: shadows.mediumList,
            border: widget.type == CuTooltipType.lite
                ? Border.all(color: colors.border)
                : null,
          ),
          child: DefaultTextStyle(
            style: typography.bodySmall.copyWith(color: _textColor),
            child: widget.content,
          ),
      ),
    );
  }
}
