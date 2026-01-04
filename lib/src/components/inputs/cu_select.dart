import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';
import '../surfaces/cu_bottom_sheet.dart';

/// Select option
class CuSelectOption<T> {
  /// Option value
  final T value;

  /// Display label
  final String label;

  /// Subtitle/description
  final String? subtitle;

  /// Leading icon widget
  final Widget? icon;

  /// Whether option is disabled
  final bool disabled;

  const CuSelectOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
    this.disabled = false,
  });
}

/// CU UI Select Component
/// Uses bottom sheet for selection on mobile
class CuSelect<T> extends StatefulWidget {
  /// Select options
  final List<CuSelectOption<T>> options;

  /// Current value
  final T? value;

  /// On change callback
  final ValueChanged<T>? onChange;

  /// Placeholder text
  final String? placeholder;

  /// Label text
  final String? label;

  /// Bottom sheet title
  final String? sheetTitle;

  /// Size variant
  final CuSize size;

  /// Disabled state
  final bool disabled;

  /// Error state
  final bool error;

  /// Error message
  final String? errorMessage;

  /// Width
  final double? width;

  /// Multiple selection
  final bool multiple;

  const CuSelect({
    super.key,
    required this.options,
    this.value,
    this.onChange,
    this.placeholder,
    this.label,
    this.sheetTitle,
    this.size = CuSize.medium,
    this.disabled = false,
    this.error = false,
    this.errorMessage,
    this.width,
    this.multiple = false,
  });

  @override
  State<CuSelect<T>> createState() => _CuSelectState<T>();
}

class _CuSelectState<T> extends State<CuSelect<T>> with CuComponentMixin {
  bool _isFocused = false;

  CuSelectOption<T>? get _selectedOption {
    if (widget.value == null) return null;
    return widget.options.cast<CuSelectOption<T>?>().firstWhere(
          (option) => option?.value == widget.value,
          orElse: () => null,
        );
  }

  Future<void> _openSelection() async {
    if (widget.disabled) return;

    setState(() => _isFocused = true);

    final result = await CuBottomSheet.showSelection<T>(
      context: context,
      title: widget.sheetTitle ?? widget.label ?? 'Select',
      selectedValue: widget.value,
      options: widget.options.map((opt) => CuBottomSheetOption<T>(
        value: opt.value,
        label: opt.label,
        subtitle: opt.subtitle,
        icon: opt.icon,
      )).toList(),
    );

    setState(() => _isFocused = false);

    if (result != null) {
      widget.onChange?.call(result);
    }
  }

  EdgeInsets get _padding {
    return widget.size.resolve(
      small: EdgeInsets.symmetric(horizontal: spacing.space3, vertical: spacing.space2),
      medium: EdgeInsets.symmetric(horizontal: spacing.space4, vertical: spacing.space3),
      large: EdgeInsets.symmetric(horizontal: spacing.space4, vertical: spacing.space4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: typography.label.copyWith(
              color: colors.accents5,
              fontWeight: typography.weightMedium,
            ),
          ),
          SizedBox(height: spacing.space2),
        ],

        GestureDetector(
          onTap: _openSelection,
          child: Container(
            width: widget.width,
            padding: _padding,
            decoration: BoxDecoration(
              color: widget.disabled ? colors.accents1 : colors.background,
              border: Border.all(
                color: widget.error
                    ? colors.error.base
                    : _isFocused
                        ? colors.foreground
                        : colors.border,
                width: _isFocused ? 2 : 1,
              ),
              borderRadius: radius.mdBorder,
            ),
            child: Row(
              children: [
                // Selected option icon
                if (_selectedOption?.icon != null) ...[
                  _selectedOption!.icon!,
                  SizedBox(width: spacing.space2),
                ],

                // Selected value or placeholder
                Expanded(
                  child: Text(
                    _selectedOption?.label ?? widget.placeholder ?? 'Select...',
                    style: typography.body.copyWith(
                      color: _selectedOption == null
                          ? colors.accents4
                          : widget.disabled
                              ? colors.accents4
                              : colors.foreground,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(width: spacing.space2),

                // Chevron
                Text(
                  '\u{25BC}',
                  style: TextStyle(
                    fontSize: 10,
                    color: colors.accents4,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Error message
        if (widget.error && widget.errorMessage != null) ...[
          SizedBox(height: spacing.space1),
          Text(
            widget.errorMessage!,
            style: typography.caption.copyWith(color: colors.error.base),
          ),
        ],
      ],
    );
  }
}
