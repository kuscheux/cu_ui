import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';
import '../navigation/cu_app_bar.dart';
import '../navigation/cu_bottom_nav.dart';
import 'cu_safe_area.dart';

/// CuScaffold - Main page scaffold component
///
/// A complete page layout with:
/// - App bar
/// - Body content
/// - Bottom navigation
/// - Floating action button
/// - Safe area handling
///
/// ## Example
/// ```dart
/// CuScaffold(
///   appBar: CuAppBar(title: 'Home'),
///   body: MyContent(),
///   bottomNav: CuBottomNav(items: myItems),
/// )
/// ```
class CuScaffold extends StatefulWidget {
  /// App bar widget
  final CuAppBar? appBar;

  /// Main body content
  final Widget body;

  /// Bottom navigation bar
  final CuBottomNav? bottomNav;

  /// Floating action button
  final Widget? floatingActionButton;

  /// Position of floating action button
  final CuFabPosition floatingActionButtonPosition;

  /// Background color
  final Color? backgroundColor;

  /// Whether body extends behind app bar
  final bool extendBodyBehindAppBar;

  /// Whether body extends behind bottom nav
  final bool extendBodyBehindBottomNav;

  /// Drawer widget
  final Widget? drawer;

  /// End drawer widget
  final Widget? endDrawer;

  /// Whether to resize body when keyboard appears
  final bool resizeToAvoidBottomInset;

  /// Custom safe area configuration
  final bool useSafeArea;

  const CuScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNav,
    this.floatingActionButton,
    this.floatingActionButtonPosition = CuFabPosition.bottomRight,
    this.backgroundColor,
    this.extendBodyBehindAppBar = false,
    this.extendBodyBehindBottomNav = false,
    this.drawer,
    this.endDrawer,
    this.resizeToAvoidBottomInset = true,
    this.useSafeArea = true,
  });

  @override
  State<CuScaffold> createState() => _CuScaffoldState();
}

class _CuScaffoldState extends State<CuScaffold> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? colors.background;
    final mediaQuery = MediaQuery.of(context);

    // Calculate body padding
    var bodyPadding = EdgeInsets.zero;

    if (!widget.extendBodyBehindAppBar && widget.appBar != null) {
      bodyPadding = bodyPadding.copyWith(
        top: widget.appBar!.height +
            (widget.appBar!.useSafeArea ? mediaQuery.padding.top : 0),
      );
    }

    if (!widget.extendBodyBehindBottomNav && widget.bottomNav != null) {
      bodyPadding = bodyPadding.copyWith(
        bottom: widget.bottomNav!.height + mediaQuery.padding.bottom,
      );
    }

    return Container(
      color: bgColor,
      child: Stack(
        children: [
          // Body
          Positioned.fill(
            child: Padding(
              padding: bodyPadding,
              child: widget.useSafeArea && widget.appBar == null && widget.bottomNav == null
                  ? CuSafeArea(child: widget.body)
                  : widget.body,
            ),
          ),

          // App Bar
          if (widget.appBar != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: widget.appBar!,
            ),

          // Bottom Nav
          if (widget.bottomNav != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: widget.bottomNav!,
            ),

          // Floating Action Button
          if (widget.floatingActionButton != null)
            Positioned(
              bottom: _getFabBottom(mediaQuery),
              right: _getFabRight(),
              left: _getFabLeft(),
              child: widget.floatingActionButton!,
            ),
        ],
      ),
    );
  }

  double _getFabBottom(MediaQueryData mediaQuery) {
    var bottom = spacing.space4;

    if (widget.bottomNav != null) {
      bottom += widget.bottomNav!.height + mediaQuery.padding.bottom;
    } else {
      bottom += mediaQuery.padding.bottom;
    }

    return bottom;
  }

  double? _getFabRight() {
    switch (widget.floatingActionButtonPosition) {
      case CuFabPosition.bottomRight:
      case CuFabPosition.topRight:
        return spacing.space4;
      case CuFabPosition.bottomCenter:
      case CuFabPosition.topCenter:
      case CuFabPosition.bottomLeft:
      case CuFabPosition.topLeft:
        return null;
    }
  }

  double? _getFabLeft() {
    switch (widget.floatingActionButtonPosition) {
      case CuFabPosition.bottomLeft:
      case CuFabPosition.topLeft:
        return spacing.space4;
      case CuFabPosition.bottomCenter:
      case CuFabPosition.topCenter:
      case CuFabPosition.bottomRight:
      case CuFabPosition.topRight:
        return null;
    }
  }
}

/// Floating action button position
enum CuFabPosition {
  bottomRight,
  bottomLeft,
  bottomCenter,
  topRight,
  topLeft,
  topCenter,
}

/// Floating action button widget
class CuFloatingActionButton extends StatefulWidget {
  /// Child widget (usually an icon)
  final Widget child;

  /// Called when button is pressed
  final VoidCallback? onPressed;

  /// Background color
  final Color? backgroundColor;

  /// Foreground color
  final Color? foregroundColor;

  /// Size of the button
  final double size;

  /// Whether button is extended (pill shape)
  final bool extended;

  /// Label for extended button
  final String? label;

  /// Whether button is loading
  final bool loading;

  const CuFloatingActionButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.size = 56,
    this.extended = false,
    this.label,
    this.loading = false,
  });

  /// Create an extended floating action button
  factory CuFloatingActionButton.extended({
    Key? key,
    required Widget icon,
    required String label,
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? foregroundColor,
    bool loading = false,
  }) {
    return CuFloatingActionButton(
      key: key,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      extended: true,
      label: label,
      loading: loading,
      child: icon,
    );
  }

  @override
  State<CuFloatingActionButton> createState() => _CuFloatingActionButtonState();
}

class _CuFloatingActionButtonState extends State<CuFloatingActionButton>
    with CuComponentMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? colors.foreground;
    final fgColor = widget.foregroundColor ?? colors.background;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.loading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: widget.size,
        padding: widget.extended
            ? EdgeInsets.symmetric(horizontal: spacing.space4)
            : null,
        constraints: BoxConstraints(
          minWidth: widget.size,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(widget.size / 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: _isPressed ? 0.2 : 0.3),
              blurRadius: _isPressed ? 8 : 12,
              offset: Offset(0, _isPressed ? 2 : 4),
            ),
          ],
        ),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        child: Center(
          child: widget.loading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: _LoadingIndicator(color: fgColor),
                )
              : widget.extended
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(fgColor, BlendMode.srcIn),
                          child: widget.child,
                        ),
                        SizedBox(width: spacing.space2),
                        Text(
                          widget.label ?? '',
                          style: typography.body.copyWith(
                            color: fgColor,
                            fontWeight: typography.weightSemibold,
                          ),
                        ),
                      ],
                    )
                  : ColorFiltered(
                      colorFilter: ColorFilter.mode(fgColor, BlendMode.srcIn),
                      child: widget.child,
                    ),
        ),
      ),
    );
  }
}

/// Simple loading indicator
class _LoadingIndicator extends StatefulWidget {
  final Color color;

  const _LoadingIndicator({required this.color});

  @override
  State<_LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<_LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
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
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.color.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: CustomPaint(
          size: const Size(24, 24),
          painter: _ArcPainter(color: widget.color),
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final Color color;

  _ArcPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -3.14159 / 2,
      3.14159 / 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
