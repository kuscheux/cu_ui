import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';
import 'cu_row.dart';

/// CU UI Col Component
/// Matches Geist UI Col - vertical flex container
class CuCol extends StatefulWidget {
  /// Child widgets
  final List<Widget> children;

  /// Gap between items (multiplier of base spacing)
  final double gap;

  /// Justify content (main axis for column is vertical)
  final CuJustify justify;

  /// Align items (cross axis for column is horizontal)
  final CuAlign align;

  const CuCol({
    super.key,
    required this.children,
    this.gap = 0,
    this.justify = CuJustify.start,
    this.align = CuAlign.start,
  });

  @override
  State<CuCol> createState() => _CuColState();
}

class _CuColState extends State<CuCol> with CuComponentMixin {
  MainAxisAlignment get _mainAxisAlignment {
    switch (widget.justify) {
      case CuJustify.start:
        return MainAxisAlignment.start;
      case CuJustify.end:
        return MainAxisAlignment.end;
      case CuJustify.center:
        return MainAxisAlignment.center;
      case CuJustify.spaceBetween:
        return MainAxisAlignment.spaceBetween;
      case CuJustify.spaceAround:
        return MainAxisAlignment.spaceAround;
      case CuJustify.spaceEvenly:
        return MainAxisAlignment.spaceEvenly;
    }
  }

  CrossAxisAlignment get _crossAxisAlignment {
    switch (widget.align) {
      case CuAlign.start:
        return CrossAxisAlignment.start;
      case CuAlign.end:
        return CrossAxisAlignment.end;
      case CuAlign.center:
        return CrossAxisAlignment.center;
      case CuAlign.stretch:
        return CrossAxisAlignment.stretch;
      case CuAlign.baseline:
        return CrossAxisAlignment.baseline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gapSize = widget.gap * spacing.unit;

    // Build children with gaps
    final List<Widget> spacedChildren = [];
    for (int i = 0; i < widget.children.length; i++) {
      spacedChildren.add(widget.children[i]);
      if (i < widget.children.length - 1 && gapSize > 0) {
        spacedChildren.add(SizedBox(height: gapSize));
      }
    }

    return Column(
      mainAxisAlignment: _mainAxisAlignment,
      crossAxisAlignment: _crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      textBaseline: TextBaseline.alphabetic,
      children: spacedChildren,
    );
  }
}
