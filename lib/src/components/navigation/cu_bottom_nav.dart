import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../../services/cu_haptics.dart';
import '../../services/cu_sounds.dart';
import '../_base/cu_component.dart';

/// CuBottomNav - Bottom navigation bar with optional balance display
///
/// A financial-app focused bottom navigation with:
/// - Balance display in center
/// - Up to 5 navigation items
/// - Active/inactive states
/// - Badge support
///
/// ## Example
/// ```dart
/// CuBottomNav(
///   currentIndex: 0,
///   balance: 12543.67,
///   showBalance: true,
///   items: [
///     CuBottomNavItem(icon: '\u{25C9}', label: 'Home'),
///     CuBottomNavItem(icon: '\u{21C4}', label: 'Transfer'),
///     CuBottomNavItem(icon: '\u{2261}', label: 'Activity'),
///     CuBottomNavItem(icon: '\u{2699}', label: 'Settings'),
///   ],
///   onTap: (index) => setState(() => _currentIndex = index),
/// )
/// ```
class CuBottomNav extends StatefulWidget {
  /// Navigation items
  final List<CuBottomNavItem> items;

  /// Currently selected index
  final int currentIndex;

  /// Called when an item is tapped
  final ValueChanged<int>? onTap;

  /// Balance to display (only shown if showBalance is true)
  final double? balance;

  /// Whether to show balance in center
  final bool showBalance;

  /// Called when balance is tapped
  final VoidCallback? onBalanceTap;

  /// Currency symbol
  final String currencySymbol;

  /// Background color
  final Color? backgroundColor;

  /// Active item color
  final Color? activeColor;

  /// Inactive item color
  final Color? inactiveColor;

  /// Height of the nav bar
  final double height;

  /// Whether to show labels
  final bool showLabels;

  /// Custom center widget (replaces balance)
  final Widget? centerWidget;

  const CuBottomNav({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
    this.balance,
    this.showBalance = false,
    this.onBalanceTap,
    this.currencySymbol = '\$',
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.height = 80,
    this.showLabels = true,
    this.centerWidget,
  }) : assert(items.length >= 2 && items.length <= 5);

  @override
  State<CuBottomNav> createState() => _CuBottomNavState();
}

class _CuBottomNavState extends State<CuBottomNav> with CuComponentMixin {
  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '${widget.currencySymbol}$formatted';
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? colors.background;
    final activeColor = widget.activeColor ?? colors.foreground;
    final inactiveColor = widget.inactiveColor ?? colors.accents4;

    final hasBalance = widget.showBalance && (widget.balance != null || widget.centerWidget != null);
    final itemCount = widget.items.length;

    return Container(
      height: widget.height + MediaQuery.of(context).padding.bottom,
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
          height: widget.height,
          child: hasBalance
              ? _buildWithBalance(activeColor, inactiveColor, itemCount)
              : _buildSimple(activeColor, inactiveColor, itemCount),
        ),
      ),
    );
  }

  Widget _buildSimple(Color activeColor, Color inactiveColor, int itemCount) {
    return Row(
      children: List.generate(itemCount, (index) {
        return Expanded(
          child: _buildNavItem(
            widget.items[index],
            index,
            widget.currentIndex == index,
            activeColor,
            inactiveColor,
          ),
        );
      }),
    );
  }

  Widget _buildWithBalance(Color activeColor, Color inactiveColor, int itemCount) {
    final halfCount = itemCount ~/ 2;
    final leftItems = widget.items.sublist(0, halfCount);
    final rightItems = widget.items.sublist(halfCount);

    return Row(
      children: [
        // Left items
        ...List.generate(leftItems.length, (index) {
          return Expanded(
            child: _buildNavItem(
              leftItems[index],
              index,
              widget.currentIndex == index,
              activeColor,
              inactiveColor,
            ),
          );
        }),

        // Center balance
        Expanded(
          flex: 2,
          child: _buildBalanceCenter(),
        ),

        // Right items
        ...List.generate(rightItems.length, (index) {
          final actualIndex = halfCount + index;
          return Expanded(
            child: _buildNavItem(
              rightItems[index],
              actualIndex,
              widget.currentIndex == actualIndex,
              activeColor,
              inactiveColor,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBalanceCenter() {
    if (widget.centerWidget != null) {
      return widget.centerWidget!;
    }

    return GestureDetector(
      onTap: widget.onBalanceTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: spacing.space2,
          vertical: spacing.space2,
        ),
        decoration: BoxDecoration(
          color: colors.foreground,
          borderRadius: radius.lgBorder,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Balance',
              style: typography.caption.copyWith(
                color: colors.background.withValues(alpha: 0.6),
                fontSize: 10,
              ),
            ),
            SizedBox(height: spacing.space1 / 2),
            Text(
              _formatCurrency(widget.balance ?? 0),
              style: typography.body.copyWith(
                color: colors.background,
                fontWeight: typography.weightBold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    CuBottomNavItem item,
    int index,
    bool isActive,
    Color activeColor,
    Color inactiveColor,
  ) {
    final color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: () {
        if (theme.hapticsEnabled) CuHaptics.light();
        if (theme.soundsEnabled) CuSounds.navigation();
        widget.onTap?.call(index);
      },
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
                    style: TextStyle(
                      fontSize: 22,
                      color: color,
                    ),
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
  }
}

/// Navigation item for CuBottomNav
class CuBottomNavItem {
  /// Icon character (emoji or unicode)
  final String? icon;

  /// Custom icon widget
  final Widget? iconWidget;

  /// Label text
  final String? label;

  /// Badge text (shown as notification badge)
  final String? badge;

  const CuBottomNavItem({
    this.icon,
    this.iconWidget,
    this.label,
    this.badge,
  }) : assert(icon != null || iconWidget != null);
}
