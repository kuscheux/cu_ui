import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Loading type variants
enum CuLoadingType {
  default_,
  secondary,
  success,
  warning,
  error,
}

/// CU UI Loading Component
/// Matches Geist UI Loading - loading dots animation
class CuLoading extends StatefulWidget {
  /// Loading text
  final String? text;

  /// Loading type
  final CuLoadingType type;

  /// Spinner style (false = dots)
  final bool spinner;

  /// Size variant
  final CuSize size;

  /// Custom color
  final Color? color;

  const CuLoading({
    super.key,
    this.text,
    this.type = CuLoadingType.default_,
    this.spinner = false,
    this.size = CuSize.medium,
    this.color,
  });

  /// Create loading with text
  factory CuLoading.text(String text, {CuLoadingType type = CuLoadingType.default_}) {
    return CuLoading(text: text, type: type);
  }

  @override
  State<CuLoading> createState() => _CuLoadingState();
}

class _CuLoadingState extends State<CuLoading>
    with SingleTickerProviderStateMixin, CuComponentMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _color {
    if (widget.color != null) return widget.color!;

    switch (widget.type) {
      case CuLoadingType.default_:
        return colors.foreground;
      case CuLoadingType.secondary:
        return colors.secondary;
      case CuLoadingType.success:
        return colors.success.base;
      case CuLoadingType.warning:
        return colors.warning.base;
      case CuLoadingType.error:
        return colors.error.base;
    }
  }

  double get _dotSize {
    return widget.size.resolve(
      small: 3.0,
      medium: 4.0,
      large: 6.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                final delay = index * 0.15;
                final animValue = ((_controller.value + delay) % 1);
                final scale = 0.6 + (0.4 * (1 - (animValue - 0.5).abs() * 2).clamp(0.0, 1.0));
                final opacity = 0.3 + (0.7 * (1 - (animValue - 0.5).abs() * 2).clamp(0.0, 1.0));

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: _dotSize * 0.5),
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      width: _dotSize,
                      height: _dotSize,
                      decoration: BoxDecoration(
                        color: _color.withValues(alpha: opacity),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
        if (widget.text != null) ...[
          SizedBox(width: spacing.space2),
          Text(
            widget.text!,
            style: typography.body.copyWith(color: _color),
          ),
        ],
      ],
    );
  }
}
