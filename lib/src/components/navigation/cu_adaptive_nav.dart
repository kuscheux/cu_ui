import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../../services/cu_haptics.dart';
import '../../services/cu_sounds.dart';
import '../_base/cu_component.dart';

/// Breakpoint for switching between bottom nav and side nav
const double _desktopBreakpoint = 768.0;

/// CuAdaptiveNav - Responsive navigation with the "One-Two Transition"
///
/// The One-Two Transition: A smooth animated transformation between
/// navigation layouts based on screen width.
///
/// - "One" (Mobile < 768px): Bottom navigation bar - horizontal, minimal
/// - "Two" (Desktop >= 768px): Side navigation panel - vertical, expanded
///
/// The transition animates smoothly when resizing the browser window,
/// providing a seamless responsive experience.
///
/// ## Example
/// ```dart
/// CuAdaptiveNav(
///   currentIndex: _selectedIndex,
///   items: [
///     CuAdaptiveNavItem(icon: '\u{25C9}', label: 'Home'),
///     CuAdaptiveNavItem(icon: '\u{21C4}', label: 'Transfer'),
///     CuAdaptiveNavItem(icon: '\u{2261}', label: 'Activity'),
///     CuAdaptiveNavItem(icon: '\u{2699}', label: 'Settings'),
///   ],
///   onTap: (index) => setState(() => _selectedIndex = index),
///   child: PageContent(),
/// )
/// ```
class CuAdaptiveNav extends StatefulWidget {
  /// Navigation items
  final List<CuAdaptiveNavItem> items;

  /// Currently selected index
  final int currentIndex;

  /// Called when an item is tapped
  final ValueChanged<int>? onTap;

  /// Content to display alongside navigation
  final Widget child;

  /// Header widget for side nav (shown above items on desktop)
  final Widget? header;

  /// Footer widget for side nav (shown below items on desktop)
  final Widget? footer;

  /// Width of the side nav on desktop
  final double sideNavWidth;

  /// Height of the bottom nav on mobile
  final double bottomNavHeight;

  /// Whether to show labels
  final bool showLabels;

  /// Whether to animate the transition
  final bool animateTransition;

  /// Background color
  final Color? backgroundColor;

  /// Active item color
  final Color? activeColor;

  /// Inactive item color
  final Color? inactiveColor;

  /// Border color
  final Color? borderColor;

  /// Whether to show the active indicator
  final bool showActiveIndicator;

  /// Custom breakpoint for switching layouts
  final double? breakpoint;

  const CuAdaptiveNav({
    super.key,
    required this.items,
    required this.child,
    this.currentIndex = 0,
    this.onTap,
    this.header,
    this.footer,
    this.sideNavWidth = 240,
    this.bottomNavHeight = 80,
    this.showLabels = true,
    this.animateTransition = true,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.borderColor,
    this.showActiveIndicator = true,
    this.breakpoint,
  });

  @override
  State<CuAdaptiveNav> createState() => _CuAdaptiveNavState();
}

class _CuAdaptiveNavState extends State<CuAdaptiveNav>
    with SingleTickerProviderStateMixin, CuComponentMixin {
  late AnimationController _controller;
  late Animation<double> _sideNavAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _sideNavAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    if (theme.hapticsEnabled) CuHaptics.light();
    if (theme.soundsEnabled) CuSounds.navigation();
    widget.onTap?.call(index);
  }

  double get _breakpoint => widget.breakpoint ?? _desktopBreakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= _breakpoint;

        // Animate transition
        if (widget.animateTransition) {
          if (isDesktop && _controller.status != AnimationStatus.forward &&
              _controller.status != AnimationStatus.completed) {
            _controller.forward();
          } else if (!isDesktop && _controller.status != AnimationStatus.reverse &&
              _controller.status != AnimationStatus.dismissed) {
            _controller.reverse();
          }
        } else {
          _controller.value = isDesktop ? 1.0 : 0.0;
        }

        return AnimatedBuilder(
          animation: _sideNavAnimation,
          builder: (context, child) {
            final progress = _sideNavAnimation.value;

            if (progress == 0) {
              // Full bottom nav mode
              return _buildBottomNavLayout();
            } else if (progress == 1) {
              // Full side nav mode
              return _buildSideNavLayout();
            } else {
              // Transitioning - crossfade between layouts
              return Stack(
                children: [
                  Opacity(
                    opacity: 1 - progress,
                    child: _buildBottomNavLayout(),
                  ),
                  Opacity(
                    opacity: progress,
                    child: _buildSideNavLayout(),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  Widget _buildBottomNavLayout() {
    final bgColor = widget.backgroundColor ?? colors.background;
    final activeColor = widget.activeColor ?? colors.foreground;
    final inactiveColor = widget.inactiveColor ?? colors.accents4;
    final borderColor = widget.borderColor ?? colors.border;

    return Column(
      children: [
        // Content area
        Expanded(child: widget.child),

        // Bottom navigation
        Container(
          height: widget.bottomNavHeight + MediaQuery.of(context).padding.bottom,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(top: BorderSide(color: borderColor)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: widget.bottomNavHeight,
              child: Row(
                children: List.generate(widget.items.length, (index) {
                  return Expanded(
                    child: _buildBottomNavItem(
                      widget.items[index],
                      index,
                      widget.currentIndex == index,
                      activeColor,
                      inactiveColor,
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavItem(
    CuAdaptiveNavItem item,
    int index,
    bool isActive,
    Color activeColor,
    Color inactiveColor,
  ) {
    final color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: () => _handleTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: spacing.space2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with optional badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                if (item.iconWidget != null)
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    child: item.iconWidget!,
                  )
                else
                  Text(
                    item.icon ?? '',
                    style: TextStyle(fontSize: 22, color: color),
                  ),

                // Badge
                if (item.badge != null)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.error.base,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(minWidth: 16),
                      child: Text(
                        item.badge!,
                        style: typography.caption.copyWith(
                          color: const Color(0xFFFFFFFF),
                          fontSize: 10,
                          fontWeight: typography.weightBold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),

            // Label
            if (widget.showLabels && item.label != null) ...[
              SizedBox(height: spacing.space1),
              Text(
                item.label!,
                style: typography.caption.copyWith(
                  color: color,
                  fontSize: 11,
                  fontWeight: isActive ? typography.weightMedium : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // Active indicator
            if (widget.showActiveIndicator && isActive) ...[
              SizedBox(height: spacing.space1),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSideNavLayout() {
    final bgColor = widget.backgroundColor ?? colors.background;
    final borderColor = widget.borderColor ?? colors.border;

    return Row(
      children: [
        // Side navigation
        Container(
          width: widget.sideNavWidth,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(right: BorderSide(color: borderColor)),
          ),
          child: SafeArea(
            right: false,
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                if (widget.header != null)
                  Padding(
                    padding: EdgeInsets.all(spacing.space4),
                    child: widget.header!,
                  ),

                // Navigation items
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.space3,
                      vertical: spacing.space2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(widget.items.length, (index) {
                        return _buildSideNavItem(
                          widget.items[index],
                          index,
                          widget.currentIndex == index,
                        );
                      }),
                    ),
                  ),
                ),

                // Footer
                if (widget.footer != null)
                  Padding(
                    padding: EdgeInsets.all(spacing.space4),
                    child: widget.footer!,
                  ),
              ],
            ),
          ),
        ),

        // Content area
        Expanded(child: widget.child),
      ],
    );
  }

  Widget _buildSideNavItem(
    CuAdaptiveNavItem item,
    int index,
    bool isActive,
  ) {
    final activeColor = widget.activeColor ?? colors.foreground;
    final inactiveColor = widget.inactiveColor ?? colors.accents5;
    final color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        margin: EdgeInsets.only(bottom: spacing.space1),
        padding: EdgeInsets.symmetric(
          horizontal: spacing.space3,
          vertical: spacing.space2 + 2,
        ),
        decoration: BoxDecoration(
          color: isActive ? colors.accents1 : const Color(0x00000000),
          borderRadius: radius.mdBorder,
        ),
        child: Row(
          children: [
            // Icon
            if (item.iconWidget != null)
              ColorFiltered(
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                child: SizedBox(width: 20, height: 20, child: item.iconWidget!),
              )
            else if (item.icon != null)
              SizedBox(
                width: 24,
                child: Text(
                  item.icon!,
                  style: TextStyle(fontSize: 16, color: color),
                ),
              ),

            SizedBox(width: spacing.space3),

            // Label
            Expanded(
              child: Text(
                item.label ?? '',
                style: typography.body.copyWith(
                  color: color,
                  fontWeight: isActive ? typography.weightMedium : null,
                ),
              ),
            ),

            // Badge
            if (item.badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: colors.error.base,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.badge!,
                  style: typography.caption.copyWith(
                    color: const Color(0xFFFFFFFF),
                    fontSize: 11,
                    fontWeight: typography.weightMedium,
                  ),
                ),
              ),

            // Active indicator
            if (widget.showActiveIndicator && isActive) ...[
              SizedBox(width: spacing.space2),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Navigation item for CuAdaptiveNav
class CuAdaptiveNavItem {
  /// Icon character (emoji or unicode)
  final String? icon;

  /// Custom icon widget
  final Widget? iconWidget;

  /// Label text
  final String? label;

  /// Badge text (shown as notification badge)
  final String? badge;

  /// Optional subtitle (shown in side nav only)
  final String? subtitle;

  const CuAdaptiveNavItem({
    this.icon,
    this.iconWidget,
    this.label,
    this.badge,
    this.subtitle,
  }) : assert(icon != null || iconWidget != null);
}

/// CuAdaptiveNavGroup - Group of navigation items with a header
///
/// Used with CuAdaptiveNavGrouped for grouped side navigation
class CuAdaptiveNavGroup {
  /// Group header label
  final String label;

  /// Items in this group
  final List<CuAdaptiveNavItem> items;

  /// Whether the group is expanded (side nav only)
  final bool expanded;

  const CuAdaptiveNavGroup({
    required this.label,
    required this.items,
    this.expanded = true,
  });
}

/// CuAdaptiveNavGrouped - Responsive navigation with grouped items
///
/// Similar to CuAdaptiveNav but supports grouping items with headers
/// On mobile, groups are flattened to a simple bottom nav
/// On desktop, groups are shown as expandable sections
class CuAdaptiveNavGrouped extends StatefulWidget {
  /// Navigation groups
  final List<CuAdaptiveNavGroup> groups;

  /// Currently selected group index
  final int currentGroupIndex;

  /// Currently selected item index within the group
  final int currentItemIndex;

  /// Called when an item is tapped
  final void Function(int groupIndex, int itemIndex)? onTap;

  /// Content to display alongside navigation
  final Widget child;

  /// Header widget for side nav
  final Widget? header;

  /// Footer widget for side nav
  final Widget? footer;

  /// Width of the side nav on desktop
  final double sideNavWidth;

  /// Height of the bottom nav on mobile
  final double bottomNavHeight;

  /// Whether to animate the transition
  final bool animateTransition;

  /// Background color
  final Color? backgroundColor;

  /// Active item color
  final Color? activeColor;

  /// Inactive item color
  final Color? inactiveColor;

  /// Custom breakpoint for switching layouts
  final double? breakpoint;

  const CuAdaptiveNavGrouped({
    super.key,
    required this.groups,
    required this.child,
    this.currentGroupIndex = 0,
    this.currentItemIndex = 0,
    this.onTap,
    this.header,
    this.footer,
    this.sideNavWidth = 240,
    this.bottomNavHeight = 80,
    this.animateTransition = true,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.breakpoint,
  });

  @override
  State<CuAdaptiveNavGrouped> createState() => _CuAdaptiveNavGroupedState();
}

class _CuAdaptiveNavGroupedState extends State<CuAdaptiveNavGrouped>
    with SingleTickerProviderStateMixin, CuComponentMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Set<int> _expandedGroups;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    // Initialize with all groups expanded
    _expandedGroups = Set.from(
      List.generate(widget.groups.length, (i) => widget.groups[i].expanded ? i : -1)
        ..removeWhere((i) => i == -1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(int groupIndex, int itemIndex) {
    if (theme.hapticsEnabled) CuHaptics.light();
    if (theme.soundsEnabled) CuSounds.navigation();
    widget.onTap?.call(groupIndex, itemIndex);
  }

  void _toggleGroup(int index) {
    if (theme.hapticsEnabled) CuHaptics.light();
    if (theme.soundsEnabled) CuSounds.tap();
    setState(() {
      if (_expandedGroups.contains(index)) {
        _expandedGroups.remove(index);
      } else {
        _expandedGroups.add(index);
      }
    });
  }

  double get _breakpoint => widget.breakpoint ?? _desktopBreakpoint;

  // Get flattened items for bottom nav (first item from each group)
  List<(int, int, CuAdaptiveNavItem)> get _flattenedPrimaryItems {
    final items = <(int, int, CuAdaptiveNavItem)>[];
    for (var gi = 0; gi < widget.groups.length; gi++) {
      final group = widget.groups[gi];
      if (group.items.isNotEmpty) {
        items.add((gi, 0, group.items.first));
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= _breakpoint;

        if (widget.animateTransition) {
          if (isDesktop && _controller.status != AnimationStatus.forward &&
              _controller.status != AnimationStatus.completed) {
            _controller.forward();
          } else if (!isDesktop && _controller.status != AnimationStatus.reverse &&
              _controller.status != AnimationStatus.dismissed) {
            _controller.reverse();
          }
        } else {
          _controller.value = isDesktop ? 1.0 : 0.0;
        }

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final progress = _animation.value;

            if (progress == 0) {
              return _buildBottomNavLayout();
            } else if (progress == 1) {
              return _buildSideNavLayout();
            } else {
              return Stack(
                children: [
                  Opacity(opacity: 1 - progress, child: _buildBottomNavLayout()),
                  Opacity(opacity: progress, child: _buildSideNavLayout()),
                ],
              );
            }
          },
        );
      },
    );
  }

  Widget _buildBottomNavLayout() {
    final bgColor = widget.backgroundColor ?? colors.background;
    final activeColor = widget.activeColor ?? colors.foreground;
    final inactiveColor = widget.inactiveColor ?? colors.accents4;
    final items = _flattenedPrimaryItems;

    return Column(
      children: [
        Expanded(child: widget.child),
        Container(
          height: widget.bottomNavHeight + MediaQuery.of(context).padding.bottom,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(top: BorderSide(color: colors.border)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: widget.bottomNavHeight,
              child: Row(
                children: items.map((entry) {
                  final (gi, ii, item) = entry;
                  final isActive = gi == widget.currentGroupIndex;
                  final color = isActive ? activeColor : inactiveColor;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _handleTap(gi, ii),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (item.iconWidget != null)
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                              child: item.iconWidget!,
                            )
                          else
                            Text(
                              item.icon ?? '',
                              style: TextStyle(fontSize: 22, color: color),
                            ),
                          SizedBox(height: spacing.space1),
                          Text(
                            item.label ?? widget.groups[gi].label,
                            style: typography.caption.copyWith(
                              color: color,
                              fontSize: 11,
                              fontWeight: isActive ? typography.weightMedium : null,
                            ),
                          ),
                          if (isActive) ...[
                            SizedBox(height: spacing.space1),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: activeColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSideNavLayout() {
    final bgColor = widget.backgroundColor ?? colors.background;
    final activeColor = widget.activeColor ?? colors.foreground;
    final inactiveColor = widget.inactiveColor ?? colors.accents5;

    return Row(
      children: [
        Container(
          width: widget.sideNavWidth,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(right: BorderSide(color: colors.border)),
          ),
          child: SafeArea(
            right: false,
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.header != null)
                  Padding(
                    padding: EdgeInsets.all(spacing.space4),
                    child: widget.header!,
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(spacing.space3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(widget.groups.length, (gi) {
                        final group = widget.groups[gi];
                        final isExpanded = _expandedGroups.contains(gi);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Group header
                            GestureDetector(
                              onTap: () => _toggleGroup(gi),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: spacing.space3,
                                  vertical: spacing.space2,
                                ),
                                decoration: BoxDecoration(
                                  color: isExpanded ? colors.accents1 : const Color(0x00000000),
                                  borderRadius: radius.mdBorder,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      isExpanded ? '\u{25BC}' : '\u{25B6}',
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: isExpanded ? activeColor : inactiveColor,
                                      ),
                                    ),
                                    SizedBox(width: spacing.space2),
                                    Expanded(
                                      child: Text(
                                        group.label,
                                        style: typography.body.copyWith(
                                          color: isExpanded ? activeColor : inactiveColor,
                                          fontWeight: isExpanded ? typography.weightMedium : null,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${group.items.length}',
                                      style: typography.caption.copyWith(
                                        color: colors.accents4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Group items
                            if (isExpanded)
                              Padding(
                                padding: EdgeInsets.only(
                                  left: spacing.space4,
                                  top: spacing.space1,
                                  bottom: spacing.space2,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: List.generate(group.items.length, (ii) {
                                    final item = group.items[ii];
                                    final isActive = gi == widget.currentGroupIndex &&
                                        ii == widget.currentItemIndex;
                                    final color = isActive ? activeColor : inactiveColor;

                                    return GestureDetector(
                                      onTap: () => _handleTap(gi, ii),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: spacing.space3,
                                          vertical: spacing.space2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? activeColor
                                              : const Color(0x00000000),
                                          borderRadius: radius.smBorder,
                                        ),
                                        child: Text(
                                          item.label ?? '',
                                          style: typography.body.copyWith(
                                            color: isActive
                                                ? colors.background
                                                : color,
                                            fontWeight: isActive
                                                ? typography.weightMedium
                                                : null,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),

                            SizedBox(height: spacing.space1),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                if (widget.footer != null)
                  Padding(
                    padding: EdgeInsets.all(spacing.space4),
                    child: widget.footer!,
                  ),
              ],
            ),
          ),
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}
