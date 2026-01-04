import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../../services/cu_haptics.dart';
import '../../services/cu_sounds.dart';
import '../_base/cu_component.dart';

/// CuListTile - List item component
///
/// A versatile list item with:
/// - Leading widget (icon, avatar, etc.)
/// - Title and subtitle
/// - Trailing widget
/// - Tap/long press handlers
///
/// ## Example
/// ```dart
/// CuListTile(
///   leading: CuAvatar(text: 'JD'),
///   title: 'John Doe',
///   subtitle: 'john@example.com',
///   trailing: Text('\u{203A}'),
///   onTap: () => print('Tapped'),
/// )
/// ```
class CuListTile extends StatefulWidget {
  /// Leading widget
  final Widget? leading;

  /// Title text
  final String? title;

  /// Custom title widget
  final Widget? titleWidget;

  /// Subtitle text
  final String? subtitle;

  /// Custom subtitle widget
  final Widget? subtitleWidget;

  /// Trailing widget
  final Widget? trailing;

  /// Called when tile is tapped
  final VoidCallback? onTap;

  /// Called when tile is long pressed
  final VoidCallback? onLongPress;

  /// Whether tile is enabled
  final bool enabled;

  /// Whether tile is selected
  final bool selected;

  /// Content padding
  final EdgeInsets? contentPadding;

  /// Minimum height
  final double? minHeight;

  /// Whether to show divider at bottom
  final bool showDivider;

  /// Whether tile is dense (reduced padding)
  final bool dense;

  /// Background color
  final Color? backgroundColor;

  /// Background color when selected
  final Color? selectedBackgroundColor;

  /// Title text style
  final TextStyle? titleStyle;

  /// Subtitle text style
  final TextStyle? subtitleStyle;

  const CuListTile({
    super.key,
    this.leading,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.subtitleWidget,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.selected = false,
    this.contentPadding,
    this.minHeight,
    this.showDivider = false,
    this.dense = false,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.titleStyle,
    this.subtitleStyle,
  });

  /// Create a settings-style list tile
  factory CuListTile.settings({
    Key? key,
    Widget? leading,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool enabled = true,
    bool showDivider = true,
  }) {
    return CuListTile(
      key: key,
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing ?? const _ChevronRight(),
      onTap: onTap,
      enabled: enabled,
      showDivider: showDivider,
    );
  }

  /// Create a navigation list tile with chevron
  factory CuListTile.navigation({
    Key? key,
    Widget? leading,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    return CuListTile(
      key: key,
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: const _ChevronRight(),
      onTap: onTap,
      enabled: enabled,
    );
  }

  /// Create a switch/toggle list tile
  factory CuListTile.switchTile({
    Key? key,
    Widget? leading,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    bool enabled = true,
  }) {
    return CuListTile(
      key: key,
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: _SwitchTrailing(value: value, onChanged: onChanged),
      onTap: onChanged != null ? () => onChanged(!value) : null,
      enabled: enabled,
    );
  }

  /// Create an account balance tile for credit unions
  /// Shows account name with balance and available balance
  factory CuListTile.account({
    Key? key,
    required String accountName,
    required double balance,
    double? availableBalance,
    String? accountNumber,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return CuListTile(
      key: key,
      titleWidget: _AccountTitle(name: accountName, accountNumber: accountNumber),
      subtitleWidget: _AccountBalances(
        balance: balance,
        availableBalance: availableBalance,
      ),
      trailing: const _ChevronRight(),
      onTap: onTap,
      showDivider: showDivider,
    );
  }

  /// Create an account tile with leading icon
  factory CuListTile.accountWithIcon({
    Key? key,
    required String accountName,
    required double balance,
    double? availableBalance,
    String? accountNumber,
    required String icon,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return CuListTile(
      key: key,
      leading: _AccountIcon(icon: icon),
      titleWidget: _AccountTitle(name: accountName, accountNumber: accountNumber),
      subtitleWidget: _AccountBalances(
        balance: balance,
        availableBalance: availableBalance,
      ),
      trailing: const _ChevronRight(),
      onTap: onTap,
      showDivider: showDivider,
    );
  }

  /// Create a compact account tile (single line balance)
  factory CuListTile.accountCompact({
    Key? key,
    required String accountName,
    required double balance,
    String? accountNumber,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return CuListTile(
      key: key,
      title: accountName,
      subtitle: accountNumber,
      trailing: _BalanceTrailing(balance: balance),
      onTap: onTap,
      showDivider: showDivider,
      dense: true,
    );
  }

  /// Create a transaction tile
  factory CuListTile.transaction({
    Key? key,
    required String description,
    required double amount,
    required String date,
    String? category,
    bool isPending = false,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return CuListTile(
      key: key,
      titleWidget: _TransactionTitle(description: description, isPending: isPending),
      subtitle: category ?? date,
      trailing: _TransactionAmount(amount: amount, isPending: isPending),
      onTap: onTap,
      showDivider: showDivider,
    );
  }

  /// Create a payee/contact tile
  factory CuListTile.payee({
    Key? key,
    required String name,
    String? accountInfo,
    String? initial,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return CuListTile(
      key: key,
      leading: _PayeeAvatar(initial: initial ?? name[0].toUpperCase()),
      title: name,
      subtitle: accountInfo,
      trailing: const _ChevronRight(),
      onTap: onTap,
      showDivider: showDivider,
    );
  }

  @override
  State<CuListTile> createState() => _CuListTileState();
}

class _CuListTileState extends State<CuListTile> with CuComponentMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = widget.contentPadding ??
        EdgeInsets.symmetric(
          horizontal: spacing.space4,
          vertical: widget.dense ? spacing.space2 : spacing.space3,
        );

    final bgColor = widget.selected
        ? (widget.selectedBackgroundColor ?? colors.accents1)
        : (widget.backgroundColor ?? Colors.transparent);

    final pressedColor = colors.accents1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: widget.enabled && widget.onTap != null
              ? (_) => setState(() => _isPressed = true)
              : null,
          onTapUp: widget.enabled && widget.onTap != null
              ? (_) => setState(() => _isPressed = false)
              : null,
          onTapCancel: widget.enabled && widget.onTap != null
              ? () => setState(() => _isPressed = false)
              : null,
          onTap: widget.enabled && widget.onTap != null
              ? () {
                  if (theme.hapticsEnabled) CuHaptics.light();
                  if (theme.soundsEnabled) CuSounds.tap();
                  widget.onTap!();
                }
              : null,
          onLongPress: widget.enabled ? widget.onLongPress : null,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            constraints: BoxConstraints(
              minHeight: widget.minHeight ?? (widget.dense ? 48 : 56),
            ),
            padding: effectivePadding,
            decoration: BoxDecoration(
              color: _isPressed ? pressedColor : bgColor,
            ),
            child: Row(
              children: [
                // Leading
                if (widget.leading != null) ...[
                  Opacity(
                    opacity: widget.enabled ? 1.0 : 0.5,
                    child: widget.leading,
                  ),
                  SizedBox(width: spacing.space3),
                ],

                // Content
                Expanded(
                  child: Opacity(
                    opacity: widget.enabled ? 1.0 : 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        if (widget.titleWidget != null)
                          widget.titleWidget!
                        else if (widget.title != null)
                          Text(
                            widget.title!,
                            style: widget.titleStyle ??
                                typography.body.copyWith(
                                  color: colors.foreground,
                                  fontWeight: typography.weightMedium,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                        // Subtitle
                        if (widget.subtitleWidget != null) ...[
                          SizedBox(height: spacing.space1),
                          widget.subtitleWidget!,
                        ] else if (widget.subtitle != null) ...[
                          SizedBox(height: spacing.space1),
                          Text(
                            widget.subtitle!,
                            style: widget.subtitleStyle ??
                                typography.caption.copyWith(
                                  color: colors.accents5,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Trailing
                if (widget.trailing != null) ...[
                  SizedBox(width: spacing.space3),
                  Opacity(
                    opacity: widget.enabled ? 1.0 : 0.5,
                    child: widget.trailing,
                  ),
                ],
              ],
            ),
          ),
        ),

        // Divider
        if (widget.showDivider)
          Container(
            height: 1,
            margin: EdgeInsets.only(
              left: widget.leading != null
                  ? effectivePadding.left + 40 + spacing.space3
                  : effectivePadding.left,
            ),
            color: colors.border,
          ),
      ],
    );
  }
}

/// Transparent color
class Colors {
  static const Color transparent = Color(0x00000000);
}

/// Chevron right icon
class _ChevronRight extends StatelessWidget {
  const _ChevronRight();

  @override
  Widget build(BuildContext context) {
    final theme = CuTheme.of(context);
    return Text(
      '\u{203A}', // ›
      style: TextStyle(
        fontSize: 20,
        color: theme.colors.accents4,
      ),
    );
  }
}

/// Switch trailing widget
class _SwitchTrailing extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _SwitchTrailing({
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CuTheme.of(context);

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: Container(
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          color: value ? theme.colors.success.base : theme.colors.accents3,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

/// Account title with name and optional account number
class _AccountTitle extends StatelessWidget {
  final String name;
  final String? accountNumber;

  const _AccountTitle({required this.name, this.accountNumber});

  @override
  Widget build(BuildContext context) {
    final theme = CuTheme.of(context);
    return Row(
      children: [
        Text(
          name,
          style: theme.typography.body.copyWith(
            color: theme.colors.foreground,
            fontWeight: theme.typography.weightMedium,
          ),
        ),
        if (accountNumber != null) ...[
          const SizedBox(width: 8),
          Text(
            accountNumber!,
            style: theme.typography.caption.copyWith(
              color: theme.colors.accents4,
            ),
          ),
        ],
      ],
    );
  }
}

/// Account balances display
class _AccountBalances extends StatelessWidget {
  final double balance;
  final double? availableBalance;

  const _AccountBalances({required this.balance, this.availableBalance});

  String _formatCurrency(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final formatted = absAmount.toStringAsFixed(2);
    final parts = formatted.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '${isNegative ? '-' : ''}\$$intPart.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = CuTheme.of(context);
    return Row(
      children: [
        Text(
          _formatCurrency(balance),
          style: theme.typography.body.copyWith(
            color: theme.colors.foreground,
            fontWeight: theme.typography.weightSemibold,
          ),
        ),
        if (availableBalance != null) ...[
          Text(
            '  \u{2022}  ',
            style: theme.typography.caption.copyWith(
              color: theme.colors.accents3,
            ),
          ),
          Text(
            '${_formatCurrency(availableBalance!)} available',
            style: theme.typography.caption.copyWith(
              color: theme.colors.accents5,
            ),
          ),
        ],
      ],
    );
  }
}

/// Account icon
class _AccountIcon extends StatelessWidget {
  final String icon;

  const _AccountIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = CuTheme.of(context);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: theme.colors.accents1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          icon,
          style: TextStyle(
            fontSize: 18,
            color: theme.colors.foreground,
          ),
        ),
      ),
    );
  }
}

/// Balance trailing widget
class _BalanceTrailing extends StatelessWidget {
  final double balance;

  const _BalanceTrailing({required this.balance});

  String _formatCurrency(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final formatted = absAmount.toStringAsFixed(2);
    final parts = formatted.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '${isNegative ? '-' : ''}\$$intPart.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = CuTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatCurrency(balance),
          style: theme.typography.body.copyWith(
            color: theme.colors.foreground,
            fontWeight: theme.typography.weightMedium,
          ),
        ),
        const SizedBox(width: 8),
        const _ChevronRight(),
      ],
    );
  }
}

/// Transaction title with pending indicator
class _TransactionTitle extends StatelessWidget {
  final String description;
  final bool isPending;

  const _TransactionTitle({required this.description, this.isPending = false});

  @override
  Widget build(BuildContext context) {
    final theme = CuTheme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            description,
            style: theme.typography.body.copyWith(
              color: isPending ? theme.colors.accents5 : theme.colors.foreground,
              fontWeight: theme.typography.weightMedium,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isPending) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colors.warning.lighter,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Pending',
              style: theme.typography.caption.copyWith(
                color: theme.colors.warning.base,
                fontSize: 10,
                fontWeight: theme.typography.weightMedium,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Transaction amount
class _TransactionAmount extends StatelessWidget {
  final double amount;
  final bool isPending;

  const _TransactionAmount({required this.amount, this.isPending = false});

  String _formatCurrency(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final formatted = absAmount.toStringAsFixed(2);
    final parts = formatted.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '${isNegative ? '-' : '+'}\$$intPart.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = CuTheme.of(context);
    final isPositive = amount >= 0;
    return Text(
      _formatCurrency(amount),
      style: theme.typography.body.copyWith(
        color: isPending
            ? theme.colors.accents4
            : isPositive
                ? theme.colors.success.base
                : theme.colors.foreground,
        fontWeight: theme.typography.weightMedium,
      ),
    );
  }
}

/// Payee avatar
class _PayeeAvatar extends StatelessWidget {
  final String initial;

  const _PayeeAvatar({required this.initial});

  @override
  Widget build(BuildContext context) {
    final theme = CuTheme.of(context);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: theme.colors.accents2,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: theme.typography.body.copyWith(
            color: theme.colors.foreground,
            fontWeight: theme.typography.weightMedium,
          ),
        ),
      ),
    );
  }
}
