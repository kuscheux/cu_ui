import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Collapse Component
/// Matches Geist UI Collapse - expandable content panel
class CuCollapse extends StatefulWidget {
  /// Collapse title
  final String title;

  /// Optional subtitle
  final String? subtitle;

  /// Collapse content
  final Widget child;

  /// Initial expanded state
  final bool initialExpanded;

  /// Controlled expanded state
  final bool? expanded;

  /// On expand/collapse callback
  final ValueChanged<bool>? onChange;

  /// Show shadow when expanded
  final bool shadow;

  const CuCollapse({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.initialExpanded = false,
    this.expanded,
    this.onChange,
    this.shadow = false,
  });

  @override
  State<CuCollapse> createState() => _CuCollapseState();
}

class _CuCollapseState extends State<CuCollapse>
    with SingleTickerProviderStateMixin, CuComponentMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.expanded ?? widget.initialExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(_expandAnimation);

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CuCollapse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded != null && widget.expanded != _isExpanded) {
      _isExpanded = widget.expanded!;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (widget.expanded == null) {
      setState(() => _isExpanded = !_isExpanded);
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    widget.onChange?.call(!_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: animation.normal,
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: radius.mdBorder,
        boxShadow: widget.shadow && _isExpanded ? shadows.smallList : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _toggle,
              child: Container(
                padding: EdgeInsets.all(spacing.space4),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.title, style: typography.h5),
                          if (widget.subtitle != null) ...[
                            SizedBox(height: spacing.space1),
                            Text(
                              widget.subtitle!,
                              style: typography.bodySmall.copyWith(
                                color: colors.accents5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    RotationTransition(
                      turns: _rotateAnimation,
                      child: Text(
                        '\u{25BC}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.accents5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                spacing.space4,
                0,
                spacing.space4,
                spacing.space4,
              ),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Collapse Group Component
class CuCollapseGroup extends StatefulWidget {
  /// Collapse items
  final List<CuCollapse> children;

  /// Allow multiple items to be expanded
  final bool accordion;

  const CuCollapseGroup({
    super.key,
    required this.children,
    this.accordion = true,
  });

  @override
  State<CuCollapseGroup> createState() => _CuCollapseGroupState();
}

class _CuCollapseGroupState extends State<CuCollapseGroup> with CuComponentMixin {
  final Set<int> _expandedIndices = {};

  void _handleToggle(int index, bool expanded) {
    setState(() {
      if (expanded) {
        if (widget.accordion) {
          _expandedIndices.clear();
        }
        _expandedIndices.add(index);
      } else {
        _expandedIndices.remove(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: radius.mdBorder,
      ),
      child: ClipRRect(
        borderRadius: radius.mdBorder,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: widget.children.asMap().entries.map((entry) {
            final index = entry.key;
            final collapse = entry.value;
            final isLast = index == widget.children.length - 1;

            return Column(
              children: [
                _CollapseGroupItem(
                  title: collapse.title,
                  subtitle: collapse.subtitle,
                  expanded: _expandedIndices.contains(index),
                  onChange: (expanded) => _handleToggle(index, expanded),
                  child: collapse.child,
                ),
                if (!isLast) Container(height: 1, color: colors.border),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CollapseGroupItem extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final bool expanded;
  final ValueChanged<bool> onChange;

  const _CollapseGroupItem({
    required this.title,
    required this.child,
    required this.expanded,
    required this.onChange,
    this.subtitle,
  });

  @override
  State<_CollapseGroupItem> createState() => _CollapseGroupItemState();
}

class _CollapseGroupItemState extends State<_CollapseGroupItem>
    with SingleTickerProviderStateMixin, CuComponentMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(_expandAnimation);

    if (widget.expanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_CollapseGroupItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded != oldWidget.expanded) {
      if (widget.expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => widget.onChange(!widget.expanded),
            child: Container(
              padding: EdgeInsets.all(spacing.space4),
              color: colors.background,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title, style: typography.h5),
                        if (widget.subtitle != null) ...[
                          SizedBox(height: spacing.space1),
                          Text(
                            widget.subtitle!,
                            style: typography.bodySmall.copyWith(
                              color: colors.accents5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  RotationTransition(
                    turns: _rotateAnimation,
                    child: Text(
                      '\u{25BC}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.accents5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Content
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              spacing.space4,
              0,
              spacing.space4,
              spacing.space4,
            ),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
