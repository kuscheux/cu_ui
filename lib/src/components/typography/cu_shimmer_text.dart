import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CuShimmerText - Text with animated shimmer/gradient effect
///
/// Creates text with a sweeping gradient animation effect.
/// Great for loading states, branding, or emphasis.
///
/// ## Example
/// ```dart
/// CuShimmerText(
///   'Loading...',
///   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
/// )
/// ```
class CuShimmerText extends StatefulWidget {
  /// Text to display
  final String text;

  /// Base text style
  final TextStyle? style;

  /// Primary shimmer color
  final Color? shimmerColor;

  /// Secondary shimmer color (highlight)
  final Color? highlightColor;

  /// Duration of one shimmer cycle
  final Duration duration;

  /// Whether shimmer is enabled
  final bool enabled;

  /// Text alignment
  final TextAlign? textAlign;

  /// Max lines
  final int? maxLines;

  /// Overflow behavior
  final TextOverflow? overflow;

  const CuShimmerText(
    this.text, {
    super.key,
    this.style,
    this.shimmerColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 2000),
    this.enabled = true,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  /// Create a gold/premium shimmer text
  factory CuShimmerText.gold(
    String text, {
    Key? key,
    TextStyle? style,
    Duration duration = const Duration(milliseconds: 2000),
    bool enabled = true,
    TextAlign? textAlign,
  }) {
    return CuShimmerText(
      text,
      key: key,
      style: style,
      shimmerColor: const Color(0xFFD4AF37),
      highlightColor: const Color(0xFFF5E6A3),
      duration: duration,
      enabled: enabled,
      textAlign: textAlign,
    );
  }

  /// Create a silver shimmer text
  factory CuShimmerText.silver(
    String text, {
    Key? key,
    TextStyle? style,
    Duration duration = const Duration(milliseconds: 2000),
    bool enabled = true,
    TextAlign? textAlign,
  }) {
    return CuShimmerText(
      text,
      key: key,
      style: style,
      shimmerColor: const Color(0xFFC0C0C0),
      highlightColor: const Color(0xFFFFFFFF),
      duration: duration,
      enabled: enabled,
      textAlign: textAlign,
    );
  }

  /// Create a gradient rainbow shimmer text
  factory CuShimmerText.rainbow(
    String text, {
    Key? key,
    TextStyle? style,
    Duration duration = const Duration(milliseconds: 3000),
    bool enabled = true,
    TextAlign? textAlign,
  }) {
    return _CuRainbowShimmerText(
      text,
      key: key,
      style: style,
      duration: duration,
      enabled: enabled,
      textAlign: textAlign,
    );
  }

  @override
  State<CuShimmerText> createState() => _CuShimmerTextState();
}

class _CuShimmerTextState extends State<CuShimmerText>
    with SingleTickerProviderStateMixin, CuComponentMixin {
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
  void didUpdateWidget(CuShimmerText oldWidget) {
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
    final baseStyle = widget.style ?? typography.body;
    final shimmerColor = widget.shimmerColor ?? colors.foreground;
    final highlightColor = widget.highlightColor ??
        colors.foreground.withValues(alpha: 0.5);

    if (!widget.enabled) {
      return Text(
        widget.text,
        style: baseStyle.copyWith(color: shimmerColor),
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            final value = _controller.value;
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                shimmerColor,
                shimmerColor,
                highlightColor,
                shimmerColor,
                shimmerColor,
              ],
              stops: [
                math.max(0.0, value - 0.3),
                math.max(0.0, value - 0.1),
                value,
                math.min(1.0, value + 0.1),
                math.min(1.0, value + 0.3),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Text(
        widget.text,
        style: baseStyle,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      ),
    );
  }
}

/// Rainbow shimmer text variant
class _CuRainbowShimmerText extends CuShimmerText {
  const _CuRainbowShimmerText(
    super.text, {
    super.key,
    super.style,
    super.duration,
    super.enabled,
    super.textAlign,
  });

  @override
  State<CuShimmerText> createState() => _CuRainbowShimmerTextState();
}

class _CuRainbowShimmerTextState extends State<_CuRainbowShimmerText>
    with SingleTickerProviderStateMixin, CuComponentMixin {
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = widget.style ?? typography.body;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            final offset = _controller.value;
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFFF6B6B),
                Color(0xFFFFE66D),
                Color(0xFF4ECDC4),
                Color(0xFF45B7D1),
                Color(0xFF96C93D),
                Color(0xFFFF6B6B),
              ],
              stops: [
                (0.0 + offset) % 1.0,
                (0.2 + offset) % 1.0,
                (0.4 + offset) % 1.0,
                (0.6 + offset) % 1.0,
                (0.8 + offset) % 1.0,
                (1.0 + offset) % 1.0,
              ]..sort(),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Text(
        widget.text,
        style: baseStyle,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      ),
    );
  }
}
