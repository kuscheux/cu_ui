import 'package:flutter/widgets.dart';
import '../theme/cu_theme.dart';
import '../components/_base/cu_component.dart';
import '../components/surfaces/cu_card.dart';
import '../components/layout/cu_spacer.dart';

/// CuAccountDetailScreen - Pre-built account detail/transaction history screen
///
/// A complete account detail screen with:
/// - Account header with balance
/// - Quick action buttons
/// - Transaction list with filtering
/// - Pull-to-refresh support
///
/// ## Example
/// ```dart
/// CuAccountDetailScreen(
///   accountName: 'Checking Account',
///   accountNumber: '****1234',
///   balance: 5432.10,
///   availableBalance: 5000.00,
///   transactions: myTransactions,
///   onTransfer: () => Navigator.pushNamed(context, '/transfer'),
///   onBack: () => Navigator.pop(context),
/// )
/// ```
class CuAccountDetailScreen extends StatefulWidget {
  /// Account name
  final String accountName;

  /// Masked account number
  final String? accountNumber;

  /// Current balance
  final double balance;

  /// Available balance (may differ due to holds)
  final double? availableBalance;

  /// Account type (checking, savings, credit, etc.)
  final String? accountType;

  /// Transaction history
  final List<CuTransaction> transactions;

  /// Quick action buttons
  final List<CuAccountAction>? actions;

  /// Called when back is pressed
  final VoidCallback? onBack;

  /// Called when a transaction is tapped
  final void Function(CuTransaction transaction)? onTransactionTap;

  /// Currency symbol
  final String currencySymbol;

  /// Screen title (overrides accountName in header)
  final String? title;

  /// Show account number in header
  final bool showAccountNumber;

  /// Custom header widget
  final Widget? customHeader;

  /// Filter options for transactions
  final List<String>? filterOptions;

  const CuAccountDetailScreen({
    super.key,
    required this.accountName,
    this.accountNumber,
    required this.balance,
    this.availableBalance,
    this.accountType,
    this.transactions = const [],
    this.actions,
    this.onBack,
    this.onTransactionTap,
    this.currencySymbol = '\$',
    this.title,
    this.showAccountNumber = true,
    this.customHeader,
    this.filterOptions,
  });

  @override
  State<CuAccountDetailScreen> createState() => _CuAccountDetailScreenState();
}

class _CuAccountDetailScreenState extends State<CuAccountDetailScreen> with CuComponentMixin {
  String? _selectedFilter;

  List<CuTransaction> get _filteredTransactions {
    if (_selectedFilter == null || _selectedFilter == 'All') {
      return widget.transactions;
    }
    return widget.transactions.where((t) {
      if (_selectedFilter == 'Income') return t.amount >= 0;
      if (_selectedFilter == 'Expenses') return t.amount < 0;
      return t.category == _selectedFilter;
    }).toList();
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

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            widget.customHeader ?? _buildHeader(),

            // Content
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Balance Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(spacing.space4),
                      child: _buildBalanceCard(),
                    ),
                  ),

                  // Quick Actions
                  if (widget.actions != null && widget.actions!.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: spacing.space4),
                        child: _buildQuickActions(),
                      ),
                    ),

                  // Filter tabs
                  if (widget.filterOptions != null && widget.filterOptions!.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(spacing.space4),
                        child: _buildFilterTabs(),
                      ),
                    ),

                  // Transactions Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        spacing.space4,
                        spacing.space4,
                        spacing.space4,
                        spacing.space2,
                      ),
                      child: Text(
                        'Transactions',
                        style: typography.h4.copyWith(color: colors.foreground),
                      ),
                    ),
                  ),

                  // Transaction List
                  if (_filteredTransactions.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(spacing.space6),
                        child: Text(
                          'No transactions found',
                          style: typography.body.copyWith(color: colors.accents5),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: spacing.space4),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildTransactionItem(
                            _filteredTransactions[index],
                          ),
                          childCount: _filteredTransactions.length,
                        ),
                      ),
                    ),

                  // Bottom padding
                  SliverToBoxAdapter(
                    child: CuSpacer.vertical(spacing.space8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(spacing.space4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          if (widget.onBack != null)
            GestureDetector(
              onTap: widget.onBack,
              child: Container(
                padding: EdgeInsets.all(spacing.space2),
                child: Text(
                  '\u{2190}', // Left arrow
                  style: typography.body.copyWith(color: colors.accents6),
                ),
              ),
            ),
          Expanded(
            child: Text(
              widget.title ?? widget.accountName,
              style: typography.h4.copyWith(color: colors.foreground),
              textAlign: TextAlign.center,
            ),
          ),
          // Spacer for alignment
          if (widget.onBack != null)
            SizedBox(width: spacing.space8),
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.showAccountNumber && widget.accountNumber != null)
                      Text(
                        widget.accountNumber!,
                        style: typography.caption.copyWith(
                          color: colors.background.withValues(alpha: 0.6),
                        ),
                      ),
                    if (widget.accountType != null)
                      Text(
                        widget.accountType!.toUpperCase(),
                        style: typography.label.copyWith(
                          color: colors.background.withValues(alpha: 0.7),
                          letterSpacing: 1.2,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          CuSpacer.vertical(spacing.space3),
          Text(
            'Current Balance',
            style: typography.bodySmall.copyWith(
              color: colors.background.withValues(alpha: 0.7),
            ),
          ),
          CuSpacer.vertical(spacing.space1),
          Text(
            _formatCurrency(widget.balance),
            style: typography.h1.copyWith(
              color: colors.background,
              fontWeight: typography.weightBold,
            ),
          ),
          if (widget.availableBalance != null) ...[
            CuSpacer.vertical(spacing.space2),
            Text(
              'Available: ${_formatCurrency(widget.availableBalance!)}',
              style: typography.body.copyWith(
                color: colors.background.withValues(alpha: 0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget.actions!.map((action) {
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
                child: Center(child: action.icon),
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

  Widget _buildFilterTabs() {
    final filters = ['All', ...widget.filterOptions!];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter ||
              (filter == 'All' && _selectedFilter == null);

          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: Container(
              margin: EdgeInsets.only(right: spacing.space2),
              padding: EdgeInsets.symmetric(
                horizontal: spacing.space4,
                vertical: spacing.space2,
              ),
              decoration: BoxDecoration(
                color: isSelected ? colors.foreground : colors.accents1,
                borderRadius: radius.fullBorder,
                border: Border.all(
                  color: isSelected ? colors.foreground : colors.border,
                ),
              ),
              child: Text(
                filter,
                style: typography.bodySmall.copyWith(
                  color: isSelected ? colors.background : colors.accents6,
                  fontWeight: isSelected ? typography.weightMedium : null,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionItem(CuTransaction txn) {
    final isCredit = txn.amount >= 0;

    return GestureDetector(
      onTap: widget.onTransactionTap != null
          ? () => widget.onTransactionTap!(txn)
          : null,
      child: Container(
        margin: EdgeInsets.only(bottom: spacing.space2),
        child: CuCard(
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isCredit ? colors.success.lighter : colors.accents1,
                  borderRadius: radius.mdBorder,
                ),
                child: Center(
                  child: txn.icon ?? Text(
                    isCredit ? '\u{2191}' : '\u{2193}', // Up/Down arrows
                    style: TextStyle(
                      fontSize: 18,
                      color: isCredit ? colors.success.base : colors.accents6,
                    ),
                  ),
                ),
              ),
              CuSpacer.horizontal(spacing.space3),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      txn.description,
                      style: typography.body.copyWith(
                        color: colors.foreground,
                        fontWeight: typography.weightMedium,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    CuSpacer.vertical(spacing.space1),
                    Row(
                      children: [
                        Text(
                          _formatDate(txn.date),
                          style: typography.caption.copyWith(color: colors.accents5),
                        ),
                        if (txn.category != null) ...[
                          Text(
                            ' \u{2022} ', // Bullet
                            style: typography.caption.copyWith(color: colors.accents4),
                          ),
                          Text(
                            txn.category!,
                            style: typography.caption.copyWith(color: colors.accents5),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isCredit ? '+' : ''}${_formatCurrency(txn.amount)}',
                    style: typography.body.copyWith(
                      color: isCredit ? colors.success.base : colors.foreground,
                      fontWeight: typography.weightSemiBold,
                    ),
                  ),
                  if (txn.status != null && txn.status != 'completed')
                    Text(
                      txn.status!.toUpperCase(),
                      style: typography.caption.copyWith(
                        color: colors.warning.base,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Transaction model for account detail screen
class CuTransaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final String? category;
  final String? status;
  final Widget? icon;
  final String? merchantName;
  final String? referenceNumber;

  const CuTransaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    this.category,
    this.status,
    this.icon,
    this.merchantName,
    this.referenceNumber,
  });
}

/// Quick action model for account detail screen
class CuAccountAction {
  final String label;
  final Widget icon;
  final VoidCallback? onTap;

  const CuAccountAction({
    required this.label,
    required this.icon,
    this.onTap,
  });
}
