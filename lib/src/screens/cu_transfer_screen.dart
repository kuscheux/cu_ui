import 'package:flutter/widgets.dart';
import '../theme/cu_theme.dart';
import '../components/_base/cu_component.dart';
import '../components/buttons/cu_button.dart';
import '../components/inputs/cu_input.dart';
import '../components/inputs/cu_select.dart';
import '../components/surfaces/cu_card.dart';
import '../components/layout/cu_spacer.dart';

/// CuTransferScreen - Pre-built money transfer screen
///
/// A complete transfer screen with:
/// - From/To account selection
/// - Amount input with currency formatting
/// - Optional memo/note field
/// - Transfer type selection (internal, external, wire)
/// - Confirmation step
///
/// ## Example
/// ```dart
/// CuTransferScreen(
///   accounts: myAccounts,
///   onTransfer: (from, to, amount, memo) async {
///     await transferService.transfer(from, to, amount, memo);
///   },
///   onCancel: () => Navigator.pop(context),
/// )
/// ```
class CuTransferScreen extends StatefulWidget {
  /// Available accounts for transfer
  final List<CuTransferAccount> accounts;

  /// Pre-selected from account
  final String? initialFromAccount;

  /// Pre-selected to account
  final String? initialToAccount;

  /// Pre-filled amount
  final double? initialAmount;

  /// Called when transfer is submitted
  final Future<void> Function(
    CuTransferAccount from,
    CuTransferAccount to,
    double amount,
    String? memo,
  )? onTransfer;

  /// Called when cancel is pressed
  final VoidCallback? onCancel;

  /// Screen title
  final String title;

  /// Currency symbol
  final String currencySymbol;

  /// Maximum transfer amount (optional)
  final double? maxAmount;

  /// Enable external transfers
  final bool allowExternalTransfers;

  /// Custom header widget
  final Widget? header;

  const CuTransferScreen({
    super.key,
    required this.accounts,
    this.initialFromAccount,
    this.initialToAccount,
    this.initialAmount,
    this.onTransfer,
    this.onCancel,
    this.title = 'Transfer Money',
    this.currencySymbol = '\$',
    this.maxAmount,
    this.allowExternalTransfers = false,
    this.header,
  });

  @override
  State<CuTransferScreen> createState() => _CuTransferScreenState();
}

class _CuTransferScreenState extends State<CuTransferScreen> with CuComponentMixin {
  String? _fromAccountId;
  String? _toAccountId;
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _showConfirmation = false;

  @override
  void initState() {
    super.initState();
    _fromAccountId = widget.initialFromAccount ??
        (widget.accounts.isNotEmpty ? widget.accounts.first.id : null);
    _toAccountId = widget.initialToAccount;
    if (widget.initialAmount != null) {
      _amountController.text = widget.initialAmount!.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  CuTransferAccount? get _fromAccount =>
      widget.accounts.where((a) => a.id == _fromAccountId).firstOrNull;

  CuTransferAccount? get _toAccount =>
      widget.accounts.where((a) => a.id == _toAccountId).firstOrNull;

  double? get _amount {
    final text = _amountController.text.replaceAll(',', '');
    return double.tryParse(text);
  }

  bool get _isValid {
    if (_fromAccountId == null || _toAccountId == null) return false;
    if (_fromAccountId == _toAccountId) return false;
    final amount = _amount;
    if (amount == null || amount <= 0) return false;
    if (_fromAccount != null && amount > _fromAccount!.balance) return false;
    if (widget.maxAmount != null && amount > widget.maxAmount!) return false;
    return true;
  }

  String _formatCurrency(double amount) {
    return '${widget.currencySymbol}${amount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  void _handleContinue() {
    setState(() {
      _errorMessage = null;
      if (!_isValid) {
        if (_fromAccountId == _toAccountId) {
          _errorMessage = 'Please select different accounts';
        } else if (_amount == null || _amount! <= 0) {
          _errorMessage = 'Please enter a valid amount';
        } else if (_fromAccount != null && _amount! > _fromAccount!.balance) {
          _errorMessage = 'Insufficient funds';
        } else {
          _errorMessage = 'Please fill in all required fields';
        }
        return;
      }
      _showConfirmation = true;
    });
  }

  Future<void> _handleTransfer() async {
    if (!_isValid || widget.onTransfer == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.onTransfer!(
        _fromAccount!,
        _toAccount!,
        _amount!,
        _memoController.text.isNotEmpty ? _memoController.text : null,
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _showConfirmation = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(spacing.space4),
                child: _showConfirmation
                    ? _buildConfirmation()
                    : _buildForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return widget.header ?? Container(
      padding: EdgeInsets.all(spacing.space4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          if (widget.onCancel != null)
            GestureDetector(
              onTap: _showConfirmation
                  ? () => setState(() => _showConfirmation = false)
                  : widget.onCancel,
              child: Container(
                padding: EdgeInsets.all(spacing.space2),
                child: Text(
                  _showConfirmation ? '\u{2190} Back' : '\u{2715}',
                  style: typography.body.copyWith(color: colors.accents6),
                ),
              ),
            ),
          Expanded(
            child: Text(
              _showConfirmation ? 'Confirm Transfer' : widget.title,
              style: typography.h4.copyWith(color: colors.foreground),
              textAlign: TextAlign.center,
            ),
          ),
          // Spacer for alignment
          if (widget.onCancel != null)
            SizedBox(width: spacing.space8),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Error message
        if (_errorMessage != null) ...[
          Container(
            padding: EdgeInsets.all(spacing.space3),
            decoration: BoxDecoration(
              color: colors.error.lighter,
              borderRadius: radius.mdBorder,
              border: Border.all(color: colors.error.base),
            ),
            child: Text(
              _errorMessage!,
              style: typography.bodySmall.copyWith(color: colors.error.dark),
            ),
          ),
          CuSpacer.vertical(spacing.space4),
        ],

        // From Account
        Text(
          'From',
          style: typography.label.copyWith(color: colors.accents5),
        ),
        CuSpacer.vertical(spacing.space2),
        CuSelect<String>(
          value: _fromAccountId,
          options: widget.accounts.map((a) => CuSelectOption(
            value: a.id,
            label: '${a.name} - ${_formatCurrency(a.balance)}',
          )).toList(),
          onChange: (value) => setState(() => _fromAccountId = value),
          placeholder: 'Select account',
        ),
        CuSpacer.vertical(spacing.space4),

        // To Account
        Text(
          'To',
          style: typography.label.copyWith(color: colors.accents5),
        ),
        CuSpacer.vertical(spacing.space2),
        CuSelect<String>(
          value: _toAccountId,
          options: widget.accounts
              .where((a) => a.id != _fromAccountId)
              .map((a) => CuSelectOption(
                value: a.id,
                label: '${a.name} - ${_formatCurrency(a.balance)}',
              )).toList(),
          onChange: (value) => setState(() => _toAccountId = value),
          placeholder: 'Select account',
        ),
        CuSpacer.vertical(spacing.space4),

        // Amount
        CuInput(
          label: 'Amount',
          placeholder: '0.00',
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefix: Padding(
            padding: EdgeInsets.only(left: spacing.space3),
            child: Text(
              widget.currencySymbol,
              style: typography.body.copyWith(color: colors.accents5),
            ),
          ),
        ),
        if (_fromAccount != null) ...[
          CuSpacer.vertical(spacing.space1),
          Text(
            'Available: ${_formatCurrency(_fromAccount!.balance)}',
            style: typography.caption.copyWith(color: colors.accents5),
          ),
        ],
        CuSpacer.vertical(spacing.space4),

        // Memo
        CuInput(
          label: 'Memo (Optional)',
          placeholder: 'Add a note',
          controller: _memoController,
        ),
        CuSpacer.vertical(spacing.space6),

        // Continue button
        CuButton(
          child: const Text('Continue'),
          onPressed: _handleContinue,
          disabled: !_isValid,
        ),
      ],
    );
  }

  Widget _buildConfirmation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Summary Card
        CuCard(
          child: Column(
            children: [
              // Amount
              Text(
                _formatCurrency(_amount!),
                style: typography.h1.copyWith(
                  color: colors.foreground,
                  fontWeight: typography.weightBold,
                ),
              ),
              CuSpacer.vertical(spacing.space4),

              // From/To
              _buildSummaryRow('From', _fromAccount!.name),
              CuSpacer.vertical(spacing.space2),
              _buildSummaryRow('To', _toAccount!.name),

              if (_memoController.text.isNotEmpty) ...[
                CuSpacer.vertical(spacing.space2),
                _buildSummaryRow('Memo', _memoController.text),
              ],
            ],
          ),
        ),
        CuSpacer.vertical(spacing.space6),

        // Error message
        if (_errorMessage != null) ...[
          Container(
            padding: EdgeInsets.all(spacing.space3),
            decoration: BoxDecoration(
              color: colors.error.lighter,
              borderRadius: radius.mdBorder,
              border: Border.all(color: colors.error.base),
            ),
            child: Text(
              _errorMessage!,
              style: typography.bodySmall.copyWith(color: colors.error.dark),
            ),
          ),
          CuSpacer.vertical(spacing.space4),
        ],

        // Confirm button
        CuButton(
          child: const Text('Confirm Transfer'),
          onPressed: _handleTransfer,
          loading: _isLoading,
          disabled: _isLoading,
        ),
        CuSpacer.vertical(spacing.space3),

        // Cancel button
        CuButton.secondary(
          child: const Text('Cancel'),
          onPressed: () => setState(() => _showConfirmation = false),
          disabled: _isLoading,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: typography.body.copyWith(color: colors.accents5),
        ),
        Text(
          value,
          style: typography.body.copyWith(
            color: colors.foreground,
            fontWeight: typography.weightMedium,
          ),
        ),
      ],
    );
  }
}

/// Transfer account model
class CuTransferAccount {
  final String id;
  final String name;
  final double balance;
  final String? accountNumber;
  final String? routingNumber;
  final bool isExternal;

  const CuTransferAccount({
    required this.id,
    required this.name,
    required this.balance,
    this.accountNumber,
    this.routingNumber,
    this.isExternal = false,
  });
}
