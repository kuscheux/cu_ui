import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Capacity Component
/// Matches Geist UI Capacity - capacity/usage indicator bar
class CuCapacity extends StatefulWidget {
  /// Value between 0 and 100
  final double value;

  /// Color based on value thresholds
  final bool colorful;

  /// Custom color
  final Color? color;

  /// Width of the capacity bar
  final double? width;

  /// Height of the capacity bar
  final double height;

  const CuCapacity({
    super.key,
    required this.value,
    this.colorful = false,
    this.color,
    this.width,
    this.height = 10,
  });

  @override
  State<CuCapacity> createState() => _CuCapacityState();
}

class _CuCapacityState extends State<CuCapacity> with CuComponentMixin {
  Color get _color {
    if (widget.color != null) return widget.color!;

    if (!widget.colorful) return colors.foreground;

    // Color based on value thresholds
    if (widget.value >= 90) {
      return colors.error.base;
    } else if (widget.value >= 75) {
      return colors.warning.base;
    } else if (widget.value >= 50) {
      return colors.success.base;
    }
    return colors.cyan.base;
  }

  @override
  Widget build(BuildContext context) {
    final normalizedValue = widget.value.clamp(0, 100) / 100;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: colors.accents2,
        borderRadius: radius.fullBorder,
      ),
      clipBehavior: Clip.antiAlias,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: normalizedValue,
        child: Container(
          decoration: BoxDecoration(
            color: _color,
            borderRadius: radius.fullBorder,
          ),
        ),
      ),
    );
  }
}
