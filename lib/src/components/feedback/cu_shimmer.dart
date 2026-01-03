import 'package:flutter/widgets.dart';
import 'dart:math' as math;

/// CuShimmer - Animated shimmer/skeleton loading effect
///
/// Creates a shimmering gradient animation for loading states.
/// Can be used standalone or wrap skeleton placeholders.
///
/// ## Example
/// ```dart
/// CuShimmer(
///   child: Container(
///     width: 200,
///     height: 20,
///     color: Colors.grey,
///   ),
/// )
/// ```
class CuShimmer extends StatefulWidget {
  /// Child widget to apply shimmer effect to
  final Widget child;

  /// Base color for shimmer (darker)
  final Color? baseColor;

  /// Highlight color for shimmer (lighter)
  final Color? highlightColor;

  /// Duration of one shimmer cycle
  final Duration duration;

  /// Direction of shimmer movement
  final ShimmerDirection direction;

  /// Whether shimmer is enabled
  final bool enabled;

  const CuShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
    this.enabled = true,
  });

  /// Create a shimmer effect for dark theme
  factory CuShimmer.dark({
    Key? key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
    ShimmerDirection direction = ShimmerDirection.ltr,
    bool enabled = true,
  }) {
    return CuShimmer(
      key: key,
      baseColor: const Color(0xFF1A1A1A),
      highlightColor: const Color(0xFF2A2A2A),
      duration: duration,
      direction: direction,
      enabled: enabled,
      child: child,
    );
  }

  /// Create a shimmer effect for light theme
  factory CuShimmer.light({
    Key? key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
    ShimmerDirection direction = ShimmerDirection.ltr,
    bool enabled = true,
  }) {
    return CuShimmer(
      key: key,
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      duration: duration,
      direction: direction,
      enabled: enabled,
      child: child,
    );
  }

  @override
  State<CuShimmer> createState() => _CuShimmerState();
}

class _CuShimmerState extends State<CuShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(CuShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    final baseColor = widget.baseColor ?? const Color(0xFF2A2A2A);
    final highlightColor = widget.highlightColor ?? const Color(0xFF3A3A3A);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return _createGradient(baseColor, highlightColor, bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }

  Shader _createGradient(Color baseColor, Color highlightColor, Rect bounds) {
    final dx = widget.direction == ShimmerDirection.ltr ||
            widget.direction == ShimmerDirection.rtl
        ? bounds.width
        : 0.0;
    final dy = widget.direction == ShimmerDirection.ttb ||
            widget.direction == ShimmerDirection.btt
        ? bounds.height
        : 0.0;

    final value = _controller.value;
    final offset = widget.direction == ShimmerDirection.rtl ||
            widget.direction == ShimmerDirection.btt
        ? 1.0 - value
        : value;

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment(dx > 0 ? 1.0 : 0.0, dy > 0 ? 1.0 : 0.0),
      colors: [
        baseColor,
        baseColor,
        highlightColor,
        baseColor,
        baseColor,
      ],
      stops: [
        math.max(0.0, offset - 0.3),
        math.max(0.0, offset - 0.15),
        offset,
        math.min(1.0, offset + 0.15),
        math.min(1.0, offset + 0.3),
      ],
    ).createShader(bounds);
  }
}

/// Direction of shimmer animation
enum ShimmerDirection {
  /// Left to right
  ltr,
  /// Right to left
  rtl,
  /// Top to bottom
  ttb,
  /// Bottom to top
  btt,
}
