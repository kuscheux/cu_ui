import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Justify content options (maps to MainAxisAlignment)
enum CuJustify {
  start,
  end,
  center,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

/// Align items options (maps to CrossAxisAlignment)
enum CuAlign {
  start,
  end,
  center,
  stretch,
  baseline,
}

/// CU UI Row Component
/// Matches Geist UI Row - horizontal flex container
class CuRow extends StatefulWidget {
  /// Child widgets
  final List<Widget> children;

  /// Gap between items (multiplier of base spacing)
  final double gap;

  /// Justify content
  final CuJustify justify;

  /// Align items
  final CuAlign align;

  /// Wrap items
  final bool wrap;

  const CuRow({
    super.key,
    required this.children,
    this.gap = 0,
    this.justify = CuJustify.start,
    this.align = CuAlign.start,
    this.wrap = false,
  });

  @override
  State<CuRow> createState() => _CuRowState();
}

class _CuRowState extends State<CuRow> with CuComponentMixin {
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

    if (widget.wrap) {
      return Wrap(
        spacing: gapSize,
        runSpacing: gapSize,
        alignment: _wrapAlignment,
        crossAxisAlignment: _wrapCrossAlignment,
        children: widget.children,
      );
    }

    // Build children with gaps
    final List<Widget> spacedChildren = [];
    for (int i = 0; i < widget.children.length; i++) {
      spacedChildren.add(widget.children[i]);
      if (i < widget.children.length - 1 && gapSize > 0) {
        spacedChildren.add(SizedBox(width: gapSize));
      }
    }

    return Row(
      mainAxisAlignment: _mainAxisAlignment,
      crossAxisAlignment: _crossAxisAlignment,
      textBaseline: TextBaseline.alphabetic,
      children: spacedChildren,
    );
  }

  WrapAlignment get _wrapAlignment {
    switch (widget.justify) {
      case CuJustify.start:
        return WrapAlignment.start;
      case CuJustify.end:
        return WrapAlignment.end;
      case CuJustify.center:
        return WrapAlignment.center;
      case CuJustify.spaceBetween:
        return WrapAlignment.spaceBetween;
      case CuJustify.spaceAround:
        return WrapAlignment.spaceAround;
      case CuJustify.spaceEvenly:
        return WrapAlignment.spaceEvenly;
    }
  }

  WrapCrossAlignment get _wrapCrossAlignment {
    switch (widget.align) {
      case CuAlign.start:
        return WrapCrossAlignment.start;
      case CuAlign.end:
        return WrapCrossAlignment.end;
      case CuAlign.center:
        return WrapCrossAlignment.center;
      case CuAlign.stretch:
      case CuAlign.baseline:
        return WrapCrossAlignment.center;
    }
  }
}
