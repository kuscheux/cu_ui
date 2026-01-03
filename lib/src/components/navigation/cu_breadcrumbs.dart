import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Breadcrumbs Component
/// Matches Geist UI Breadcrumbs - navigation path display
class CuBreadcrumbs extends StatefulWidget {
  /// Breadcrumb items
  final List<CuBreadcrumbItem> items;

  /// Custom separator widget
  final Widget? separator;

  /// Size variant
  final CuSize size;

  const CuBreadcrumbs({
    super.key,
    required this.items,
    this.separator,
    this.size = CuSize.medium,
  });

  @override
  State<CuBreadcrumbs> createState() => _CuBreadcrumbsState();
}

class _CuBreadcrumbsState extends State<CuBreadcrumbs> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    final textStyle = widget.size.resolve(
      small: typography.bodySmall,
      medium: typography.body,
      large: typography.bodyLarge,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _buildItems(textStyle),
    );
  }

  List<Widget> _buildItems(TextStyle textStyle) {
    final List<Widget> items = [];

    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      final isLast = i == widget.items.length - 1;

      items.add(
        _BreadcrumbItemWidget(
          item: item,
          isLast: isLast,
          textStyle: textStyle,
        ),
      );

      if (!isLast) {
        items.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.space2),
            child: widget.separator ??
                Text(
                  '/',
                  style: textStyle.copyWith(color: colors.accents5),
                ),
          ),
        );
      }
    }

    return items;
  }
}

class _BreadcrumbItemWidget extends StatefulWidget {
  final CuBreadcrumbItem item;
  final bool isLast;
  final TextStyle textStyle;

  const _BreadcrumbItemWidget({
    required this.item,
    required this.isLast,
    required this.textStyle,
  });

  @override
  State<_BreadcrumbItemWidget> createState() => _BreadcrumbItemWidgetState();
}

class _BreadcrumbItemWidgetState extends State<_BreadcrumbItemWidget> with CuComponentMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isClickable = widget.item.onTap != null && !widget.isLast;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isClickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: isClickable ? widget.item.onTap : null,
        child: Text(
          widget.item.label,
          style: widget.textStyle.copyWith(
            color: widget.isLast
                ? colors.foreground
                : _isHovered
                    ? colors.foreground
                    : colors.accents5,
            decoration: _isHovered && isClickable ? TextDecoration.underline : null,
          ),
        ),
      ),
    );
  }
}

/// Individual breadcrumb item
class CuBreadcrumbItem {
  /// Display text
  final String label;

  /// Tap callback
  final VoidCallback? onTap;

  /// Optional href (for web)
  final String? href;

  const CuBreadcrumbItem({
    required this.label,
    this.onTap,
    this.href,
  });
}

/// Breadcrumb Separator Component
class CuBreadcrumbSeparator extends StatefulWidget {
  final Widget? child;

  const CuBreadcrumbSeparator({super.key, this.child});

  @override
  State<CuBreadcrumbSeparator> createState() => _CuBreadcrumbSeparatorState();
}

class _CuBreadcrumbSeparatorState extends State<CuBreadcrumbSeparator> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child ??
        Text(
          '/',
          style: typography.body.copyWith(color: colors.accents5),
        );
  }
}
