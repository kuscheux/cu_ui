import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Spinner Component
/// Matches Geist UI Spinner - loading spinner with rotating bars
class CuSpinner extends StatefulWidget {
  /// Spinner size
  final double size;

  /// Custom color
  final Color? color;

  const CuSpinner({
    super.key,
    this.size = 20,
    this.color,
  });

  /// Create a small spinner
  factory CuSpinner.small({Key? key, Color? color}) {
    return CuSpinner(key: key, size: 16, color: color);
  }

  /// Create a large spinner
  factory CuSpinner.large({Key? key, Color? color}) {
    return CuSpinner(key: key, size: 32, color: color);
  }

  @override
  State<CuSpinner> createState() => _CuSpinnerState();
}

class _CuSpinnerState extends State<CuSpinner>
    with SingleTickerProviderStateMixin, CuComponentMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _SpinnerPainter(
              progress: _controller.value,
              color: widget.color ?? colors.foreground,
              barRadius: widget.size * 0.1,
            ),
          );
        },
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double barRadius;

  _SpinnerPainter({
    required this.progress,
    required this.color,
    required this.barRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final barCount = 12;
    final barWidth = size.width * 0.08;
    final barHeight = size.height * 0.24;

    for (int i = 0; i < barCount; i++) {
      final angle = (i / barCount) * 2 * math.pi;
      final opacity = (1 - ((i / barCount) + progress) % 1) * 0.85 + 0.15;

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);

      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(0, -size.height * 0.35),
          width: barWidth,
          height: barHeight,
        ),
        Radius.circular(barRadius),
      );

      canvas.drawRRect(rect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_SpinnerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}
