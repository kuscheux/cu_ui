import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Progress type variants
enum CuProgressType {
  default_,
  secondary,
  success,
  warning,
  error,
}

/// CU UI Progress Component
/// Matches Geist UI Progress - progress bar indicator
class CuProgress extends StatefulWidget {
  /// Progress value (0-100)
  final double value;

  /// Maximum value
  final double max;

  /// Indeterminate/loading state
  final bool indeterminate;

  /// Progress type
  final CuProgressType type;

  /// Bar height
  final double height;

  /// Show value text
  final bool showValue;

  /// Fixed colors based on type (no transitions)
  final bool fixedColors;

  const CuProgress({
    super.key,
    this.value = 0,
    this.max = 100,
    this.indeterminate = false,
    this.type = CuProgressType.default_,
    this.height = 8,
    this.showValue = false,
    this.fixedColors = true,
  });

  @override
  State<CuProgress> createState() => _CuProgressState();
}

class _CuProgressState extends State<CuProgress>
    with SingleTickerProviderStateMixin, CuComponentMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    if (widget.indeterminate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(CuProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.indeterminate != oldWidget.indeterminate) {
      if (widget.indeterminate) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _color {
    switch (widget.type) {
      case CuProgressType.default_:
        return colors.foreground;
      case CuProgressType.secondary:
        return colors.secondary;
      case CuProgressType.success:
        return colors.success.base;
      case CuProgressType.warning:
        return colors.warning.base;
      case CuProgressType.error:
        return colors.error.base;
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.value / widget.max).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: colors.accents2,
            borderRadius: radius.fullBorder,
          ),
          clipBehavior: Clip.antiAlias,
          child: widget.indeterminate
              ? AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      alignment: Alignment(
                        (_controller.value * 3) - 1,
                        0,
                      ),
                      widthFactor: 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _color,
                          borderRadius: radius.fullBorder,
                        ),
                      ),
                    );
                  },
                )
              : AnimatedFractionallySizedBox(
                  duration: animation.normal,
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _color,
                      borderRadius: radius.fullBorder,
                    ),
                  ),
                ),
        ),
        if (widget.showValue && !widget.indeterminate) ...[
          SizedBox(height: spacing.space1),
          Text(
            '${(percentage * 100).round()}%',
            style: typography.bodySmall.copyWith(color: colors.accents5),
          ),
        ],
      ],
    );
  }
}
