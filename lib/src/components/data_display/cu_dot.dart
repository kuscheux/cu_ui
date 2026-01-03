import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Dot type variants
enum CuDotType {
  default_,
  secondary,
  success,
  warning,
  error,
}

/// CU UI Dot Component
/// Matches Geist UI Dot - status indicator dot with optional label
class CuDot extends StatefulWidget {
  /// Dot type
  final CuDotType type;

  /// Optional label text
  final String? label;

  /// Size in pixels
  final double size;

  const CuDot({
    super.key,
    this.type = CuDotType.default_,
    this.label,
    this.size = 10,
  });

  /// Create a success dot
  factory CuDot.success([String? label]) {
    return CuDot(type: CuDotType.success, label: label);
  }

  /// Create a warning dot
  factory CuDot.warning([String? label]) {
    return CuDot(type: CuDotType.warning, label: label);
  }

  /// Create an error dot
  factory CuDot.error([String? label]) {
    return CuDot(type: CuDotType.error, label: label);
  }

  @override
  State<CuDot> createState() => _CuDotState();
}

class _CuDotState extends State<CuDot> with CuComponentMixin {
  Color get _color {
    switch (widget.type) {
      case CuDotType.default_:
        return colors.foreground;
      case CuDotType.secondary:
        return colors.secondary;
      case CuDotType.success:
        return colors.success.base;
      case CuDotType.warning:
        return colors.warning.base;
      case CuDotType.error:
        return colors.error.base;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.label == null) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: _color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: spacing.space2),
        Text(
          widget.label!,
          style: typography.bodySmall.copyWith(color: colors.foreground),
        ),
      ],
    );
  }
}
