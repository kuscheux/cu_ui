import 'package:flutter/widgets.dart';
import '../theme/cu_theme.dart';
import '../components/_base/cu_component.dart';
import '../components/surfaces/cu_card.dart';
import '../components/layout/cu_spacer.dart';
import '../components/data_display/cu_avatar.dart';

/// CuDashboardScreen - Pre-built dashboard/home screen
///
/// A financial dashboard with:
/// - Header with user greeting and avatar
/// - Total balance display
/// - Account cards
/// - Quick action buttons
/// - Recent transactions preview
///
/// ## Example
/// ```dart
/// CuDashboardScreen(
///   userName: 'John',
///   userAvatar: NetworkImage('https://...'),
///   totalBalance: 12543.67,
///   accounts: [
///     CuAccountInfo(name: 'Checking', balance: 5432.10, type: 'checking'),
///     CuAccountInfo(name: 'Savings', balance: 7111.57, type: 'savings'),
///   ],
///   onAccountTap: (account) => Navigator.push(...),
///   onTransfer: () => Navigator.pushNamed(context, '/transfer'),
/// )
/// ```
class CuDashboardScreen extends StatefulWidget {
  /// User's first name for greeting
  final String? userName;

  /// User's avatar image
  final ImageProvider? userAvatar;

  /// Total balance across all accounts
  final double? totalBalance;

  /// List of accounts to display
  final List<CuAccountInfo> accounts;

  /// Recent transactions to preview
  final List<CuTransactionInfo>? recentTransactions;

  /// Quick actions to display
  final List<CuQuickAction>? quickActions;

  /// Called when user avatar/profile is tapped
  final VoidCallback? onProfileTap;

  /// Called when an account card is tapped
  final void Function(CuAccountInfo account)? onAccountTap;

  /// Called when "View All" transactions is tapped
  final VoidCallback? onViewAllTransactions;

  /// Currency symbol
  final String currencySymbol;

  /// Custom greeting text (overrides default)
  final String? greeting;

  /// Custom header widget (replaces default header)
  final Widget? customHeader;

  const CuDashboardScreen({
    super.key,
    this.userName,
    this.userAvatar,
    this.totalBalance,
    this.accounts = const [],
    this.recentTransactions,
    this.quickActions,
    this.onProfileTap,
    this.onAccountTap,
    this.onViewAllTransactions,
    this.currencySymbol = '\$',
    this.greeting,
    this.customHeader,
  });

  @override
  State<CuDashboardScreen> createState() => _CuDashboardScreenState();
}

class _CuDashboardScreenState extends State<CuDashboardScreen> with CuComponentMixin {
  String get _greeting {
    if (widget.greeting != null) return widget.greeting!;

    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _formatCurrency(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final formatted = absAmount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '${isNegative ? '-' : ''}${widget.currencySymbol}$formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.background,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: widget.customHeader ?? _buildHeader(),
            ),

            // Total Balance Card
            if (widget.totalBalance != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing.space4),
                  child: _buildBalanceCard(),
                ),
              ),

            // Quick Actions
            if (widget.quickActions != null && widget.quickActions!.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(spacing.space4),
                  child: _buildQuickActions(),
                ),
              ),

            // Accounts Section
            if (widget.accounts.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing.space4),
                  child: _buildAccountsSection(),
                ),
              ),

            // Recent Transactions
            if (widget.recentTransactions != null && widget.recentTransactions!.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(spacing.space4),
                  child: _buildTransactionsSection(),
                ),
              ),

            // Bottom padding
            SliverToBoxAdapter(
              child: CuSpacer.vertical(spacing.space8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(spacing.space4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting,
                  style: typography.bodySmall.copyWith(color: colors.accents5),
                ),
                if (widget.userName != null) ...[
                  CuSpacer.vertical(spacing.space1),
                  Text(
                    widget.userName!,
                    style: typography.h3.copyWith(color: colors.foreground),
                  ),
                ],
              ],
            ),
          ),
          if (widget.userAvatar != null || widget.onProfileTap != null)
            GestureDetector(
              onTap: widget.onProfileTap,
              child: CuAvatar(
                image: widget.userAvatar,
                text: widget.userName,
                size: CuAvatarSize.medium,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: EdgeInsets.all(spacing.space5),
      decoration: BoxDecoration(
        color: colors.foreground,
        borderRadius: radius.lgBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: typography.bodySmall.copyWith(color: colors.background.withValues(alpha: 0.7)),
          ),
          CuSpacer.vertical(spacing.space2),
          Text(
            _formatCurrency(widget.totalBalance!),
            style: typography.h1.copyWith(
              color: colors.background,
              fontWeight: typography.weightBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget.quickActions!.map((action) {
        return GestureDetector(
          onTap: action.onTap,
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colors.accents1,
                  borderRadius: radius.fullBorder,
                  border: Border.all(color: colors.border),
                ),
                child: Center(
                  child: action.icon,
                ),
              ),
              CuSpacer.vertical(spacing.space2),
              Text(
                action.label,
                style: typography.caption.copyWith(color: colors.accents6),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAccountsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accounts',
          style: typography.h4.copyWith(color: colors.foreground),
        ),
        CuSpacer.vertical(spacing.space3),
        ...widget.accounts.map((account) => Padding(
          padding: EdgeInsets.only(bottom: spacing.space3),
          child: _buildAccountCard(account),
        )),
      ],
    );
  }

  Widget _buildAccountCard(CuAccountInfo account) {
    return GestureDetector(
      onTap: widget.onAccountTap != null ? () => widget.onAccountTap!(account) : null,
      child: CuCard(
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors.accents1,
                borderRadius: radius.mdBorder,
              ),
              child: Center(
                child: Text(
                  _getAccountIcon(account.type),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            CuSpacer.horizontal(spacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: typography.body.copyWith(
                      color: colors.foreground,
                      fontWeight: typography.weightMedium,
                    ),
                  ),
                  Text(
                    account.accountNumber ?? account.type,
                    style: typography.caption.copyWith(color: colors.accents5),
                  ),
                ],
              ),
            ),
            Text(
              _formatCurrency(account.balance),
              style: typography.body.copyWith(
                color: colors.foreground,
                fontWeight: typography.weightSemibold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAccountIcon(String type) {
    switch (type.toLowerCase()) {
      case 'checking':
        return '\u{25A1}'; // Square - checking
      case 'savings':
        return '\u{25C7}'; // Diamond - savings
      case 'credit':
        return '\u{25CB}'; // Circle - credit
      case 'loan':
        return '\u{25B3}'; // Triangle - loan
      default:
        return '\u{25C6}'; // Filled diamond - default
    }
  }

  Widget _buildTransactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: typography.h4.copyWith(color: colors.foreground),
            ),
            if (widget.onViewAllTransactions != null)
              GestureDetector(
                onTap: widget.onViewAllTransactions,
                child: Text(
                  'View All',
                  style: typography.bodySmall.copyWith(color: colors.accents6),
                ),
              ),
          ],
        ),
        CuSpacer.vertical(spacing.space3),
        CuCard(
          child: Column(
            children: widget.recentTransactions!.asMap().entries.map((entry) {
              final index = entry.key;
              final txn = entry.value;
              final isLast = index == widget.recentTransactions!.length - 1;

              return Column(
                children: [
                  _buildTransactionRow(txn),
                  if (!isLast)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing.space3),
                      child: Container(
                        height: 1,
                        color: colors.border,
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionRow(CuTransactionInfo txn) {
    final isCredit = txn.amount >= 0;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCredit ? colors.success.lighter : colors.accents1,
            borderRadius: radius.mdBorder,
          ),
          child: Center(
            child: Text(
              isCredit ? '\u{2191}' : '\u{2193}', // Up/Down arrows
              style: TextStyle(
                fontSize: 16,
                color: isCredit ? colors.success.base : colors.accents6,
              ),
            ),
          ),
        ),
        CuSpacer.horizontal(spacing.space3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                txn.description,
                style: typography.body.copyWith(color: colors.foreground),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                txn.date,
                style: typography.caption.copyWith(color: colors.accents5),
              ),
            ],
          ),
        ),
        Text(
          '${isCredit ? '+' : ''}${_formatCurrency(txn.amount)}',
          style: typography.body.copyWith(
            color: isCredit ? colors.success.base : colors.foreground,
            fontWeight: typography.weightMedium,
          ),
        ),
      ],
    );
  }
}

/// Account information model
class CuAccountInfo {
  final String name;
  final double balance;
  final String type;
  final String? accountNumber;
  final String? id;

  const CuAccountInfo({
    required this.name,
    required this.balance,
    required this.type,
    this.accountNumber,
    this.id,
  });
}

/// Transaction information model
class CuTransactionInfo {
  final String description;
  final double amount;
  final String date;
  final String? id;
  final String? category;

  const CuTransactionInfo({
    required this.description,
    required this.amount,
    required this.date,
    this.id,
    this.category,
  });
}

/// Quick action model
class CuQuickAction {
  final String label;
  final Widget icon;
  final VoidCallback? onTap;

  const CuQuickAction({
    required this.label,
    required this.icon,
    this.onTap,
  });
}
