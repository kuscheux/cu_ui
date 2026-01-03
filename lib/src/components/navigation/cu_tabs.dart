import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Tabs Component
/// Matches Geist UI Tabs - tabbed navigation
class CuTabs extends StatefulWidget {
  /// Tab items
  final List<CuTab> tabs;

  /// Initial selected value
  final String? initialValue;

  /// Controlled value
  final String? value;

  /// On tab change callback
  final ValueChanged<String>? onChange;

  /// Hide the divider line
  final bool hideDivider;

  /// Hide the active border
  final bool hideBorder;

  /// Show hover highlight
  final bool highlight;

  /// Tab alignment
  final MainAxisAlignment align;

  /// Left padding
  final double leftSpace;

  const CuTabs({
    super.key,
    required this.tabs,
    this.initialValue,
    this.value,
    this.onChange,
    this.hideDivider = false,
    this.hideBorder = false,
    this.highlight = true,
    this.align = MainAxisAlignment.start,
    this.leftSpace = 12,
  });

  @override
  State<CuTabs> createState() => _CuTabsState();
}

class _CuTabsState extends State<CuTabs> with CuComponentMixin {
  late String _selectedValue;
  String? _hoveredValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value ?? widget.initialValue ?? widget.tabs.first.value;
  }

  @override
  void didUpdateWidget(CuTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != _selectedValue) {
      _selectedValue = widget.value!;
    }
  }

  void _handleTabTap(String value) {
    if (widget.value == null) {
      setState(() => _selectedValue = value);
    }
    widget.onChange?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tab header
        Container(
          padding: EdgeInsets.only(left: widget.leftSpace),
          decoration: BoxDecoration(
            border: widget.hideDivider
                ? null
                : Border(bottom: BorderSide(color: colors.border)),
          ),
          child: Row(
            mainAxisAlignment: widget.align,
            children: widget.tabs.map((tab) {
              final isActive = tab.value == _selectedValue;
              final isHovered = tab.value == _hoveredValue;

              return MouseRegion(
                onEnter: (_) => setState(() => _hoveredValue = tab.value),
                onExit: (_) => setState(() => _hoveredValue = null),
                cursor: tab.disabled
                    ? SystemMouseCursors.forbidden
                    : SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: tab.disabled ? null : () => _handleTabTap(tab.value),
                  child: AnimatedContainer(
                    duration: animation.fast,
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.space3,
                      vertical: spacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: widget.highlight && isHovered && !isActive
                          ? colors.accents1
                          : const Color(0x00000000),
                      borderRadius: radius.smBorder,
                      border: !widget.hideBorder && isActive
                          ? Border(
                              bottom: BorderSide(
                                color: colors.foreground,
                                width: 2,
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (tab.icon != null) ...[
                          DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 14,
                              color: tab.disabled
                                  ? colors.accents4
                                  : isActive
                                      ? colors.foreground
                                      : colors.accents5,
                            ),
                            child: tab.icon!,
                          ),
                          SizedBox(width: spacing.space2),
                        ],
                        Text(
                          tab.label,
                          style: typography.body.copyWith(
                            color: tab.disabled
                                ? colors.accents4
                                : isActive
                                    ? colors.foreground
                                    : colors.accents5,
                            fontWeight: isActive ? typography.weightMedium : typography.weightRegular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Tab content
        Padding(
          padding: EdgeInsets.only(top: spacing.space3),
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    final activeTab = widget.tabs.firstWhere(
      (tab) => tab.value == _selectedValue,
      orElse: () => widget.tabs.first,
    );
    return activeTab.child ?? const SizedBox.shrink();
  }
}

/// Individual tab configuration
class CuTab {
  /// Unique identifier for this tab
  final String value;

  /// Display label
  final String label;

  /// Optional icon widget
  final Widget? icon;

  /// Tab content
  final Widget? child;

  /// Whether tab is disabled
  final bool disabled;

  const CuTab({
    required this.value,
    required this.label,
    this.icon,
    this.child,
    this.disabled = false,
  });
}

/// Tab Item Component (alternative API)
class CuTabItem extends StatelessWidget {
  final String value;
  final String label;
  final Widget? icon;
  final Widget? child;
  final bool disabled;

  const CuTabItem({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.child,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return child ?? const SizedBox.shrink();
  }
}
