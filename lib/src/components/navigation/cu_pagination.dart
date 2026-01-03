import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Pagination Component
/// Matches Geist UI Pagination - page navigation
class CuPagination extends StatefulWidget {
  /// Total number of pages
  final int count;

  /// Initial page (1-indexed)
  final int initialPage;

  /// Controlled page value
  final int? page;

  /// Page change callback
  final ValueChanged<int>? onChange;

  /// Number of pages to show (odd number recommended)
  final int limit;

  /// Size variant
  final CuSize size;

  const CuPagination({
    super.key,
    required this.count,
    this.initialPage = 1,
    this.page,
    this.onChange,
    this.limit = 7,
    this.size = CuSize.medium,
  });

  @override
  State<CuPagination> createState() => _CuPaginationState();
}

class _CuPaginationState extends State<CuPagination> with CuComponentMixin {
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.page ?? widget.initialPage;
  }

  @override
  void didUpdateWidget(CuPagination oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.page != null && widget.page != _currentPage) {
      _currentPage = widget.page!;
    }
  }

  void _setPage(int page) {
    if (page < 1 || page > widget.count) return;
    if (widget.page == null) {
      setState(() => _currentPage = page);
    }
    widget.onChange?.call(page);
  }

  List<int?> _getPageNumbers() {
    final List<int?> pages = [];
    final total = widget.count;
    final current = _currentPage;
    final limit = widget.limit;

    if (total <= limit) {
      // Show all pages
      for (int i = 1; i <= total; i++) {
        pages.add(i);
      }
    } else {
      // Show pages with ellipsis
      final sideCount = (limit - 3) ~/ 2;

      if (current <= sideCount + 2) {
        // Near start
        for (int i = 1; i <= limit - 2; i++) {
          pages.add(i);
        }
        pages.add(null); // Ellipsis
        pages.add(total);
      } else if (current >= total - sideCount - 1) {
        // Near end
        pages.add(1);
        pages.add(null); // Ellipsis
        for (int i = total - limit + 3; i <= total; i++) {
          pages.add(i);
        }
      } else {
        // In middle
        pages.add(1);
        pages.add(null); // Ellipsis
        for (int i = current - sideCount; i <= current + sideCount; i++) {
          pages.add(i);
        }
        pages.add(null); // Ellipsis
        pages.add(total);
      }
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final itemSize = widget.size.resolve(
      small: 28.0,
      medium: 36.0,
      large: 44.0,
    );

    final fontSize = widget.size.resolve(
      small: 12.0,
      medium: 14.0,
      large: 16.0,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous button
        _PaginationButton(
          onTap: _currentPage > 1 ? () => _setPage(_currentPage - 1) : null,
          size: itemSize,
          child: Text(
            '\u{2039}',
            style: TextStyle(
              fontSize: fontSize + 4,
              color: _currentPage > 1 ? colors.foreground : colors.accents4,
            ),
          ),
        ),

        SizedBox(width: spacing.space1),

        // Page numbers
        ..._getPageNumbers().map((page) {
          if (page == null) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.space1),
              child: SizedBox(
                width: itemSize,
                height: itemSize,
                child: Center(
                  child: Text(
                    '...',
                    style: typography.body.copyWith(
                      fontSize: fontSize,
                      color: colors.accents5,
                    ),
                  ),
                ),
              ),
            );
          }

          final isActive = page == _currentPage;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.space1 / 2),
            child: _PaginationButton(
              onTap: () => _setPage(page),
              size: itemSize,
              isActive: isActive,
              child: Text(
                '$page',
                style: typography.body.copyWith(
                  fontSize: fontSize,
                  fontWeight: isActive ? typography.weightSemibold : typography.weightRegular,
                  color: isActive ? colors.background : colors.foreground,
                ),
              ),
            ),
          );
        }),

        SizedBox(width: spacing.space1),

        // Next button
        _PaginationButton(
          onTap: _currentPage < widget.count ? () => _setPage(_currentPage + 1) : null,
          size: itemSize,
          child: Text(
            '\u{203A}',
            style: TextStyle(
              fontSize: fontSize + 4,
              color: _currentPage < widget.count ? colors.foreground : colors.accents4,
            ),
          ),
        ),
      ],
    );
  }
}

class _PaginationButton extends StatefulWidget {
  final VoidCallback? onTap;
  final double size;
  final Widget child;
  final bool isActive;

  const _PaginationButton({
    required this.onTap,
    required this.size,
    required this.child,
    this.isActive = false,
  });

  @override
  State<_PaginationButton> createState() => _PaginationButtonState();
}

class _PaginationButtonState extends State<_PaginationButton> with CuComponentMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onTap == null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: animation.fast,
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.isActive
                ? colors.foreground
                : _isHovered && !isDisabled
                    ? colors.accents2
                    : const Color(0x00000000),
            borderRadius: radius.smBorder,
            border: Border.all(
              color: widget.isActive ? colors.foreground : colors.border,
            ),
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

/// Pagination Previous Button
class CuPaginationPrevious extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget? child;

  const CuPaginationPrevious({super.key, this.onTap, this.child});

  @override
  State<CuPaginationPrevious> createState() => _CuPaginationPreviousState();
}

class _CuPaginationPreviousState extends State<CuPaginationPrevious> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: widget.child ?? const Text('\u{2039}', style: TextStyle(fontSize: 18)),
    );
  }
}

/// Pagination Next Button
class CuPaginationNext extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget? child;

  const CuPaginationNext({super.key, this.onTap, this.child});

  @override
  State<CuPaginationNext> createState() => _CuPaginationNextState();
}

class _CuPaginationNextState extends State<CuPaginationNext> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: widget.child ?? const Text('\u{203A}', style: TextStyle(fontSize: 18)),
    );
  }
}
