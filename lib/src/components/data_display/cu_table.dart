import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Table column definition
class CuTableColumn<T> {
  /// Column header text
  final String title;

  /// Property key or index
  final String prop;

  /// Column width
  final double? width;

  /// Custom cell builder
  final Widget Function(T data, int index)? render;

  /// Text alignment
  final TextAlign align;

  const CuTableColumn({
    required this.title,
    required this.prop,
    this.width,
    this.render,
    this.align = TextAlign.left,
  });
}

/// CU UI Table Component
/// Matches Geist UI Table - data table display
class CuTable<T> extends StatefulWidget {
  /// Table data
  final List<T> data;

  /// Column definitions
  final List<CuTableColumn<T>> columns;

  /// Row key extractor
  final String Function(T)? rowKey;

  /// On row tap callback
  final void Function(T, int)? onRowTap;

  /// Hover effect
  final bool hover;

  /// Show border
  final bool bordered;

  /// Empty state text
  final String emptyText;

  const CuTable({
    super.key,
    required this.data,
    required this.columns,
    this.rowKey,
    this.onRowTap,
    this.hover = true,
    this.bordered = true,
    this.emptyText = 'No data',
  });

  @override
  State<CuTable<T>> createState() => _CuTableState<T>();
}

class _CuTableState<T> extends State<CuTable<T>> with CuComponentMixin {
  int? _hoveredRow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.bordered
          ? BoxDecoration(
              border: Border.all(color: colors.border),
              borderRadius: radius.mdBorder,
            )
          : null,
      child: ClipRRect(
        borderRadius: widget.bordered ? radius.mdBorder : BorderRadius.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              color: colors.accents1,
              padding: EdgeInsets.symmetric(
                horizontal: spacing.space4,
                vertical: spacing.space3,
              ),
              child: Row(
                children: widget.columns.map((column) {
                  return _buildHeaderCell(column);
                }).toList(),
              ),
            ),

            // Divider
            Container(height: 1, color: colors.border),

            // Body
            if (widget.data.isEmpty)
              _buildEmptyState()
            else
              ...widget.data.asMap().entries.map((entry) {
                final index = entry.key;
                final row = entry.value;
                final isLast = index == widget.data.length - 1;
                return _buildRow(row, index, isLast);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(CuTableColumn<T> column) {
    return Expanded(
      flex: column.width != null ? 0 : 1,
      child: SizedBox(
        width: column.width,
        child: Text(
          column.title,
          style: typography.bodySmall.copyWith(
            fontWeight: typography.weightSemibold,
            color: colors.accents6,
          ),
          textAlign: column.align,
        ),
      ),
    );
  }

  Widget _buildRow(T row, int index, bool isLast) {
    final isHovered = _hoveredRow == index;

    return MouseRegion(
      onEnter: widget.hover ? (_) => setState(() => _hoveredRow = index) : null,
      onExit: widget.hover ? (_) => setState(() => _hoveredRow = null) : null,
      cursor: widget.onRowTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onRowTap != null ? () => widget.onRowTap!(row, index) : null,
        child: Container(
          color: isHovered ? colors.accents1 : colors.background,
          padding: EdgeInsets.symmetric(
            horizontal: spacing.space4,
            vertical: spacing.space3,
          ),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(bottom: BorderSide(color: colors.border)),
          ),
          child: Row(
            children: widget.columns.map((column) {
              return _buildCell(row, column, index);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCell(T row, CuTableColumn<T> column, int index) {
    Widget content;

    if (column.render != null) {
      content = column.render!(row, index);
    } else {
      // Try to get value from map or use toString
      String value = '';
      if (row is Map) {
        value = row[column.prop]?.toString() ?? '';
      } else {
        value = row.toString();
      }
      content = Text(
        value,
        style: typography.body,
        textAlign: column.align,
      );
    }

    return Expanded(
      flex: column.width != null ? 0 : 1,
      child: SizedBox(
        width: column.width,
        child: content,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(spacing.space6),
      child: Center(
        child: Text(
          widget.emptyText,
          style: typography.body.copyWith(color: colors.accents5),
        ),
      ),
    );
  }
}
