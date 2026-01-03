import 'package:flutter/widgets.dart';
import 'dart:math' as math;

/// CuSplash - Custom ripple/splash effect without Material dependency
///
/// A Geist-inspired tap feedback effect that creates an expanding
/// circle from the tap point. Cleaner and more subtle than Material's InkWell.
///
/// ## Example
/// ```dart
/// CuSplash(
///   onTap: () => print('Tapped!'),
///   child: Container(
///     padding: EdgeInsets.all(16),
///     child: Text('Tap me'),
///   ),
/// )
/// ```
class CuSplash extends StatefulWidget {
  /// Child widget to wrap
  final Widget child;

  /// Called when tapped
  final VoidCallback? onTap;

  /// Called when long pressed
  final VoidCallback? onLongPress;

  /// Splash color (defaults to foreground with low opacity)
  final Color? splashColor;

  /// Hover color (defaults to transparent)
  final Color? hoverColor;

  /// Border radius for clipping
  final BorderRadius? borderRadius;

  /// Whether splash is disabled
  final bool disabled;

  /// Duration of the splash animation
  final Duration duration;

  /// Mouse cursor when hovering
  final MouseCursor cursor;

  /// Whether to show hover effect
  final bool showHover;

  const CuSplash({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.splashColor,
    this.hoverColor,
    this.borderRadius,
    this.disabled = false,
    this.duration = const Duration(milliseconds: 300),
    this.cursor = SystemMouseCursors.click,
    this.showHover = true,
  });

  @override
  State<CuSplash> createState() => _CuSplashState();
}

class _CuSplashState extends State<CuSplash> with TickerProviderStateMixin {
  final List<_SplashController> _splashes = [];
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void dispose() {
    for (final splash in _splashes) {
      splash.dispose();
    }
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.disabled) return;
    setState(() => _isPressed = true);
    _addSplash(details.localPosition);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  void _handleTap() {
    if (widget.disabled) return;
    widget.onTap?.call();
  }

  void _addSplash(Offset position) {
    final controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    final splash = _SplashController(
      position: position,
      controller: controller,
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _splashes.remove(splash);
        });
        splash.dispose();
      }
    });

    setState(() {
      _splashes.add(splash);
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSplashColor = widget.splashColor ??
        const Color(0xFFFFFFFF).withValues(alpha: 0.1);
    final effectiveHoverColor = widget.hoverColor ??
        const Color(0xFFFFFFFF).withValues(alpha: 0.05);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.disabled ? SystemMouseCursors.forbidden : widget.cursor,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        onLongPress: widget.disabled ? null : widget.onLongPress,
        behavior: HitTestBehavior.opaque,
        child: ClipRRect(
          borderRadius: widget.borderRadius ?? BorderRadius.zero,
          child: Stack(
            children: [
              // Child
              widget.child,

              // Hover overlay
              if (widget.showHover && _isHovered && !widget.disabled)
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      color: effectiveHoverColor,
                    ),
                  ),
                ),

              // Splash effects
              ..._splashes.map((splash) => Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: splash.controller,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _SplashPainter(
                          center: splash.position,
                          progress: splash.controller.value,
                          color: effectiveSplashColor,
                        ),
                      );
                    },
                  ),
                ),
              )),

              // Press overlay
              if (_isPressed && !widget.disabled)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: effectiveSplashColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashController {
  final Offset position;
  final AnimationController controller;

  _SplashController({
    required this.position,
    required this.controller,
  });

  void dispose() {
    controller.dispose();
  }
}

class _SplashPainter extends CustomPainter {
  final Offset center;
  final double progress;
  final Color color;

  _SplashPainter({
    required this.center,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate max radius to cover entire widget
    final maxRadius = math.sqrt(
      math.pow(math.max(center.dx, size.width - center.dx), 2) +
      math.pow(math.max(center.dy, size.height - center.dy), 2),
    ) * 1.2;

    final currentRadius = maxRadius * progress;
    final opacity = (1.0 - progress) * color.alpha / 255;

    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, currentRadius, paint);
  }

  @override
  bool shouldRepaint(_SplashPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.center != center ||
           oldDelegate.color != color;
  }
}
