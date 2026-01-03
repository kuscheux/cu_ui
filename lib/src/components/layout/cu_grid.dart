import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Grid Component
/// Matches Geist UI Grid - responsive grid container
class CuGrid extends StatefulWidget {
  /// Child widgets
  final List<Widget> children;

  /// Gap between grid items (multiplier of base spacing)
  final double gap;

  /// Number of columns (null for auto)
  final int? columns;

  /// Responsive column counts
  final int? xs;
  final int? sm;
  final int? md;
  final int? lg;
  final int? xl;

  /// Main axis alignment
  final MainAxisAlignment mainAxisAlignment;

  /// Cross axis alignment
  final CrossAxisAlignment crossAxisAlignment;

  const CuGrid({
    super.key,
    required this.children,
    this.gap = 1,
    this.columns,
    this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  /// Create a grid container (same as CuGrid)
  factory CuGrid.container({
    Key? key,
    required List<Widget> children,
    double gap = 1,
    int? columns,
    int? xs,
    int? sm,
    int? md,
    int? lg,
    int? xl,
  }) {
    return CuGrid(
      key: key,
      gap: gap,
      columns: columns,
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      children: children,
    );
  }

  @override
  State<CuGrid> createState() => _CuGridState();
}

class _CuGridState extends State<CuGrid> with CuComponentMixin {
  int _getColumns(double width) {
    final bp = breakpoints.fromWidth(width);

    switch (bp) {
      case CuBreakpoint.xl:
        return widget.xl ?? widget.lg ?? widget.md ?? widget.sm ?? widget.xs ?? widget.columns ?? 12;
      case CuBreakpoint.lg:
        return widget.lg ?? widget.md ?? widget.sm ?? widget.xs ?? widget.columns ?? 12;
      case CuBreakpoint.md:
        return widget.md ?? widget.sm ?? widget.xs ?? widget.columns ?? 12;
      case CuBreakpoint.sm:
        return widget.sm ?? widget.xs ?? widget.columns ?? 6;
      case CuBreakpoint.xs:
        return widget.xs ?? widget.columns ?? 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _getColumns(constraints.maxWidth);
        final gapSize = widget.gap * spacing.unit;

        return Wrap(
          spacing: gapSize,
          runSpacing: gapSize,
          alignment: WrapAlignment.start,
          children: widget.children.map((child) {
            if (child is CuGridItem) {
              return _buildGridItem(child, columns, gapSize, constraints.maxWidth);
            }
            return child;
          }).toList(),
        );
      },
    );
  }

  Widget _buildGridItem(CuGridItem item, int totalColumns, double gap, double containerWidth) {
    final span = item.span ?? 1;
    final totalGaps = (totalColumns - 1) * gap;
    final itemWidth = ((containerWidth - totalGaps) / totalColumns) * span + (gap * (span - 1));

    return SizedBox(
      width: itemWidth,
      child: item.child,
    );
  }
}

/// CU UI Grid Item Component
/// Represents a single item within a CuGrid
class CuGridItem extends StatelessWidget {
  /// Child widget
  final Widget child;

  /// Number of columns to span
  final int? span;

  /// Responsive span values
  final int? xs;
  final int? sm;
  final int? md;
  final int? lg;
  final int? xl;

  const CuGridItem({
    super.key,
    required this.child,
    this.span,
    this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
