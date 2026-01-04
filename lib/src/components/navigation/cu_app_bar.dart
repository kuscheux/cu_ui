import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CuAppBar - Custom app bar component
///
/// A flexible app bar with:
/// - Leading widget (back button, menu, etc.)
/// - Title (text or widget)
/// - Actions
/// - Customizable appearance
///
/// ## Example
/// ```dart
/// CuAppBar(
///   title: 'Settings',
///   leading: CuAppBar.backButton(onTap: () => Navigator.pop(context)),
///   actions: [
///     CuAppBar.action(icon: '\u{2699}', onTap: () {}),
///   ],
/// )
/// ```
class CuAppBar extends StatefulWidget {
  /// Title text
  final String? title;

  /// Custom title widget (overrides title text)
  final Widget? titleWidget;

  /// Leading widget
  final Widget? leading;

  /// Action widgets
  final List<Widget>? actions;

  /// Background color
  final Color? backgroundColor;

  /// Title color
  final Color? titleColor;

  /// Whether to center the title
  final bool centerTitle;

  /// Height of the app bar
  final double height;

  /// Whether to show bottom border
  final bool showBorder;

  /// Border color
  final Color? borderColor;

  /// Elevation/shadow
  final double elevation;

  /// Whether to include safe area top padding
  final bool useSafeArea;

  /// Custom bottom widget (like tabs)
  final Widget? bottom;

  /// Text style for title
  final TextStyle? titleStyle;

  const CuAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.centerTitle = true,
    this.height = 56,
    this.showBorder = true,
    this.borderColor,
    this.elevation = 0,
    this.useSafeArea = true,
    this.bottom,
    this.titleStyle,
  });

  /// Create a back button
  static Widget backButton({
    VoidCallback? onTap,
    Color? color,
  }) {
    return _CuAppBarBackButton(onTap: onTap, color: color);
  }

  /// Create a close button
  static Widget closeButton({
    VoidCallback? onTap,
    Color? color,
  }) {
    return _CuAppBarCloseButton(onTap: onTap, color: color);
  }

  /// Create an action button
  static Widget action({
    String? icon,
    Widget? iconWidget,
    VoidCallback? onTap,
    String? badge,
  }) {
    return _CuAppBarAction(
      icon: icon,
      iconWidget: iconWidget,
      onTap: onTap,
      badge: badge,
    );
  }

  @override
  State<CuAppBar> createState() => _CuAppBarState();
}

class _CuAppBarState extends State<CuAppBar> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? colors.background;
    final titleColor = widget.titleColor ?? colors.foreground;
    final borderColor = widget.borderColor ?? colors.border;

    final topPadding = widget.useSafeArea
        ? MediaQuery.of(context).padding.top
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: widget.showBorder
            ? Border(bottom: BorderSide(color: borderColor))
            : null,
        boxShadow: widget.elevation > 0
            ? [
                BoxShadow(
                  color: const Color(0xFF000000).withValues(alpha: 0.1),
                  blurRadius: widget.elevation * 2,
                  offset: Offset(0, widget.elevation),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Safe area padding
          SizedBox(height: topPadding),

          // Main app bar content
          SizedBox(
            height: widget.height,
            child: Row(
              children: [
                // Leading
                if (widget.leading != null)
                  widget.leading!
                else
                  SizedBox(width: spacing.space4),

                // Title
                Expanded(
                  child: widget.centerTitle
                      ? Center(child: _buildTitle(titleColor))
                      : Padding(
                          padding: EdgeInsets.only(left: spacing.space2),
                          child: _buildTitle(titleColor),
                        ),
                ),

                // Actions
                if (widget.actions != null && widget.actions!.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.actions!,
                  )
                else
                  SizedBox(width: spacing.space4),
              ],
            ),
          ),

          // Bottom widget
          if (widget.bottom != null) widget.bottom!,
        ],
      ),
    );
  }

  Widget _buildTitle(Color titleColor) {
    if (widget.titleWidget != null) {
      return widget.titleWidget!;
    }

    if (widget.title != null) {
      return Text(
        widget.title!,
        style: widget.titleStyle ?? typography.h4.copyWith(color: titleColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return const SizedBox.shrink();
  }
}

/// Back button for app bar
class _CuAppBarBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;

  const _CuAppBarBackButton({this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = CuTheme.of(context);
    final iconColor = color ?? theme.colors.foreground;

    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        child: Text(
          '\u{2190}', // Left arrow
          style: TextStyle(
            fontSize: 20,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

/// Close button for app bar
class _CuAppBarCloseButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;

  const _CuAppBarCloseButton({this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = CuTheme.of(context);
    final iconColor = color ?? theme.colors.foreground;

    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        child: Text(
          '\u{2715}', // X
          style: TextStyle(
            fontSize: 18,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

/// Action button for app bar
class _CuAppBarAction extends StatelessWidget {
  final String? icon;
  final Widget? iconWidget;
  final VoidCallback? onTap;
  final String? badge;

  const _CuAppBarAction({
    this.icon,
    this.iconWidget,
    this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CuTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 48,
        height: 56,
        alignment: Alignment.center,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (iconWidget != null)
              iconWidget!
            else
              Text(
                icon ?? '',
                style: TextStyle(
                  fontSize: 20,
                  color: theme.colors.foreground,
                ),
              ),
            if (badge != null)
              Positioned(
                right: -8,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colors.error.base,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: const BoxConstraints(minWidth: 14),
                  child: Text(
                    badge!,
                    style: theme.typography.caption.copyWith(
                      color: const Color(0xFFFFFFFF),
                      fontSize: 10,
                      fontWeight: theme.typography.weightBold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
