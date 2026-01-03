import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Drawer placement options
enum CuDrawerPlacement {
  left,
  right,
  top,
  bottom,
}

/// CU UI Drawer Component
/// Matches Geist UI Drawer - sliding panel overlay
class CuDrawer extends StatefulWidget {
  /// Drawer content
  final Widget child;

  /// Whether drawer is visible
  final bool visible;

  /// Close callback
  final VoidCallback? onClose;

  /// Drawer placement
  final CuDrawerPlacement placement;

  /// Disable backdrop click to close
  final bool disableBackdropClick;

  /// Enable keyboard (Escape to close)
  final bool keyboard;

  /// Drawer width (for left/right placement)
  final double? width;

  /// Drawer height (for top/bottom placement)
  final double? height;

  const CuDrawer({
    super.key,
    required this.child,
    this.visible = false,
    this.onClose,
    this.placement = CuDrawerPlacement.right,
    this.disableBackdropClick = false,
    this.keyboard = true,
    this.width,
    this.height,
  });

  /// Show a drawer
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    CuDrawerPlacement placement = CuDrawerPlacement.right,
    bool disableBackdropClick = false,
    double? width,
    double? height,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: !disableBackdropClick,
      barrierLabel: 'Drawer',
      barrierColor: const Color(0x8A000000),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _DrawerOverlay(
          placement: placement,
          width: width,
          height: height,
          animation: animation,
          onClose: () => Navigator.of(context).pop(),
          child: child,
        );
      },
    );
  }

  @override
  State<CuDrawer> createState() => _CuDrawerState();
}

class _CuDrawerState extends State<CuDrawer> with SingleTickerProviderStateMixin, CuComponentMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _updateAnimation();

    if (widget.visible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CuDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.placement != oldWidget.placement) {
      _updateAnimation();
    }
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _updateAnimation() {
    final begin = _getSlideOffset();
    _slideAnimation = Tween<Offset>(
      begin: begin,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  Offset _getSlideOffset() {
    switch (widget.placement) {
      case CuDrawerPlacement.left:
        return const Offset(-1, 0);
      case CuDrawerPlacement.right:
        return const Offset(1, 0);
      case CuDrawerPlacement.top:
        return const Offset(0, -1);
      case CuDrawerPlacement.bottom:
        return const Offset(0, 1);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_controller.isDismissed) return const SizedBox.shrink();

        return Stack(
          children: [
            // Backdrop
            Positioned.fill(
              child: GestureDetector(
                onTap: widget.disableBackdropClick ? null : widget.onClose,
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.54 * _controller.value),
                ),
              ),
            ),

            // Drawer
            _buildDrawer(),
          ],
        );
      },
    );
  }

  Widget _buildDrawer() {
    final drawerWidth = widget.width ?? 300;
    final drawerHeight = widget.height ?? 300;

    Alignment alignment;
    double? width;
    double? height;

    switch (widget.placement) {
      case CuDrawerPlacement.left:
        alignment = Alignment.centerLeft;
        width = drawerWidth;
        height = double.infinity;
        break;
      case CuDrawerPlacement.right:
        alignment = Alignment.centerRight;
        width = drawerWidth;
        height = double.infinity;
        break;
      case CuDrawerPlacement.top:
        alignment = Alignment.topCenter;
        width = double.infinity;
        height = drawerHeight;
        break;
      case CuDrawerPlacement.bottom:
        alignment = Alignment.bottomCenter;
        width = double.infinity;
        height = drawerHeight;
        break;
    }

    return Align(
      alignment: alignment,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: colors.background,
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class _DrawerOverlay extends StatefulWidget {
  final Widget child;
  final CuDrawerPlacement placement;
  final double? width;
  final double? height;
  final Animation<double> animation;
  final VoidCallback? onClose;

  const _DrawerOverlay({
    required this.child,
    required this.placement,
    required this.animation,
    this.width,
    this.height,
    this.onClose,
  });

  @override
  State<_DrawerOverlay> createState() => _DrawerOverlayState();
}

class _DrawerOverlayState extends State<_DrawerOverlay> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    final drawerWidth = widget.width ?? 300;
    final drawerHeight = widget.height ?? 300;

    Alignment alignment;
    Offset beginOffset;
    double? width;
    double? height;

    switch (widget.placement) {
      case CuDrawerPlacement.left:
        alignment = Alignment.centerLeft;
        beginOffset = const Offset(-1, 0);
        width = drawerWidth;
        height = double.infinity;
        break;
      case CuDrawerPlacement.right:
        alignment = Alignment.centerRight;
        beginOffset = const Offset(1, 0);
        width = drawerWidth;
        height = double.infinity;
        break;
      case CuDrawerPlacement.top:
        alignment = Alignment.topCenter;
        beginOffset = const Offset(0, -1);
        width = double.infinity;
        height = drawerHeight;
        break;
      case CuDrawerPlacement.bottom:
        alignment = Alignment.bottomCenter;
        beginOffset = const Offset(0, 1);
        width = double.infinity;
        height = drawerHeight;
        break;
    }

    return Stack(
      children: [
        Align(
          alignment: alignment,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: beginOffset,
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: widget.animation,
              curve: Curves.easeOutCubic,
            )),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: colors.background,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}
