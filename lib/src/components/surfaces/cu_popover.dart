import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Popover placement options
enum CuPopoverPlacement {
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

/// CU UI Popover Component
/// Matches Geist UI Popover - click-triggered popup content
class CuPopover extends StatefulWidget {
  /// Trigger widget
  final Widget child;

  /// Popover content
  final Widget content;

  /// Popover placement
  final CuPopoverPlacement placement;

  /// Visible state (for controlled popover)
  final bool? visible;

  /// On visibility change callback
  final ValueChanged<bool>? onVisibleChange;

  /// Hide arrow
  final bool hideArrow;

  /// Disable portal (render inline)
  final bool disablePortal;

  const CuPopover({
    super.key,
    required this.child,
    required this.content,
    this.placement = CuPopoverPlacement.bottom,
    this.visible,
    this.onVisibleChange,
    this.hideArrow = false,
    this.disablePortal = false,
  });

  @override
  State<CuPopover> createState() => _CuPopoverState();
}

class _CuPopoverState extends State<CuPopover> with CuComponentMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isVisible = false;

  @override
  void dispose() {
    _hidePopover();
    super.dispose();
  }

  void _togglePopover() {
    if (_isVisible) {
      _hidePopover();
    } else {
      _showPopover();
    }
  }

  void _showPopover() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _hidePopover,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              offset: _getOffset(),
              targetAnchor: _getTargetAnchor(),
              followerAnchor: _getFollowerAnchor(),
              child: GestureDetector(
                onTap: () {}, // Prevent tap-through
                child: _PopoverContent(
                  content: widget.content,
                  showArrow: !widget.hideArrow,
                  placement: widget.placement,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isVisible = true);
    widget.onVisibleChange?.call(true);
  }

  void _hidePopover() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => _isVisible = false);
      widget.onVisibleChange?.call(false);
    }
  }

  Offset _getOffset() {
    const gap = 10.0;
    switch (widget.placement) {
      case CuPopoverPlacement.top:
      case CuPopoverPlacement.topStart:
      case CuPopoverPlacement.topEnd:
        return const Offset(0, -gap);
      case CuPopoverPlacement.bottom:
      case CuPopoverPlacement.bottomStart:
      case CuPopoverPlacement.bottomEnd:
        return const Offset(0, gap);
      case CuPopoverPlacement.left:
      case CuPopoverPlacement.leftStart:
      case CuPopoverPlacement.leftEnd:
        return const Offset(-gap, 0);
      case CuPopoverPlacement.right:
      case CuPopoverPlacement.rightStart:
      case CuPopoverPlacement.rightEnd:
        return const Offset(gap, 0);
    }
  }

  Alignment _getTargetAnchor() {
    switch (widget.placement) {
      case CuPopoverPlacement.top:
        return Alignment.topCenter;
      case CuPopoverPlacement.topStart:
        return Alignment.topLeft;
      case CuPopoverPlacement.topEnd:
        return Alignment.topRight;
      case CuPopoverPlacement.bottom:
        return Alignment.bottomCenter;
      case CuPopoverPlacement.bottomStart:
        return Alignment.bottomLeft;
      case CuPopoverPlacement.bottomEnd:
        return Alignment.bottomRight;
      case CuPopoverPlacement.left:
        return Alignment.centerLeft;
      case CuPopoverPlacement.leftStart:
        return Alignment.topLeft;
      case CuPopoverPlacement.leftEnd:
        return Alignment.bottomLeft;
      case CuPopoverPlacement.right:
        return Alignment.centerRight;
      case CuPopoverPlacement.rightStart:
        return Alignment.topRight;
      case CuPopoverPlacement.rightEnd:
        return Alignment.bottomRight;
    }
  }

  Alignment _getFollowerAnchor() {
    switch (widget.placement) {
      case CuPopoverPlacement.top:
        return Alignment.bottomCenter;
      case CuPopoverPlacement.topStart:
        return Alignment.bottomLeft;
      case CuPopoverPlacement.topEnd:
        return Alignment.bottomRight;
      case CuPopoverPlacement.bottom:
        return Alignment.topCenter;
      case CuPopoverPlacement.bottomStart:
        return Alignment.topLeft;
      case CuPopoverPlacement.bottomEnd:
        return Alignment.topRight;
      case CuPopoverPlacement.left:
        return Alignment.centerRight;
      case CuPopoverPlacement.leftStart:
        return Alignment.topRight;
      case CuPopoverPlacement.leftEnd:
        return Alignment.bottomRight;
      case CuPopoverPlacement.right:
        return Alignment.centerLeft;
      case CuPopoverPlacement.rightStart:
        return Alignment.topLeft;
      case CuPopoverPlacement.rightEnd:
        return Alignment.bottomLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle controlled visibility
    if (widget.visible != null) {
      if (widget.visible! && !_isVisible) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _showPopover());
      } else if (!widget.visible! && _isVisible) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _hidePopover());
      }
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.visible == null ? _togglePopover : null,
        child: widget.child,
      ),
    );
  }
}

class _PopoverContent extends StatefulWidget {
  final Widget content;
  final bool showArrow;
  final CuPopoverPlacement placement;

  const _PopoverContent({
    required this.content,
    required this.showArrow,
    required this.placement,
  });

  @override
  State<_PopoverContent> createState() => _PopoverContentState();
}

class _PopoverContentState extends State<_PopoverContent> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: radius.mdBorder,
        border: Border.all(color: colors.border),
        boxShadow: shadows.mediumList,
      ),
      child: widget.content,
    );
  }
}

/// Popover Item Component
class CuPopoverItem extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool disabled;
  final bool divider;

  const CuPopoverItem({
    super.key,
    required this.child,
    this.onTap,
    this.disabled = false,
    this.divider = false,
  });

  /// Create a text item
  factory CuPopoverItem.text(
    String text, {
    Key? key,
    VoidCallback? onTap,
    bool disabled = false,
    bool divider = false,
  }) {
    return CuPopoverItem(
      key: key,
      onTap: onTap,
      disabled: disabled,
      divider: divider,
      child: Text(text),
    );
  }

  @override
  State<CuPopoverItem> createState() => _CuPopoverItemState();
}

class _CuPopoverItemState extends State<CuPopoverItem> with CuComponentMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: widget.disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.disabled ? null : widget.onTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.space4,
                vertical: spacing.space2,
              ),
              color: _isHovered && !widget.disabled
                  ? colors.accents1
                  : const Color(0x00000000),
              child: DefaultTextStyle(
                style: typography.body.copyWith(
                  color: widget.disabled ? colors.accents4 : colors.foreground,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
        if (widget.divider)
          Container(
            height: 1,
            color: colors.border,
          ),
      ],
    );
  }
}
