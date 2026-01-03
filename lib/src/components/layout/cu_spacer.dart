import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Spacer Component
/// Matches Geist UI Spacer - creates empty space between elements
class CuSpacer extends StatefulWidget {
  /// Inline spacer (horizontal)
  final bool inline;

  /// Width multiplier (relative to base spacing unit)
  final double? width;

  /// Height multiplier (relative to base spacing unit)
  final double? height;

  /// Explicit width in pixels
  final double? w;

  /// Explicit height in pixels
  final double? h;

  const CuSpacer({
    super.key,
    this.inline = false,
    this.width,
    this.height,
    this.w,
    this.h,
  });

  /// Create a horizontal spacer
  factory CuSpacer.x([double multiplier = 1]) {
    return CuSpacer(inline: true, width: multiplier);
  }

  /// Create a vertical spacer
  factory CuSpacer.y([double multiplier = 1]) {
    return CuSpacer(height: multiplier);
  }

  @override
  State<CuSpacer> createState() => _CuSpacerState();
}

class _CuSpacerState extends State<CuSpacer> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    final baseUnit = spacing.unit;

    final computedWidth = widget.w ?? (widget.width != null ? widget.width! * baseUnit : baseUnit);
    final computedHeight = widget.h ?? (widget.height != null ? widget.height! * baseUnit : baseUnit);

    return SizedBox(
      width: widget.inline ? computedWidth : null,
      height: widget.inline ? null : computedHeight,
    );
  }
}
