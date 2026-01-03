import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CuTextarea - Multi-line text input component
///
/// A text area for longer content input. Features:
/// - Multi-line support with configurable min/max lines
/// - Label and helper/error text
/// - Placeholder text
/// - Focus and hover states
/// - Disabled and read-only modes
/// - Size variants (small, medium, large)
///
/// Uses EditableText instead of Material TextField for zero Material dependency.
///
/// ## Example
/// ```dart
/// CuTextarea(
///   label: 'Description',
///   placeholder: 'Enter your description...',
///   minLines: 3,
///   maxLines: 10,
///   onChanged: (value) => print(value),
/// )
/// ```
class CuTextarea extends StatefulWidget {
  /// Label text above the textarea
  final String? label;

  /// Placeholder text when empty
  final String? placeholder;

  /// Initial text value
  final String? initialValue;

  /// External text controller
  final TextEditingController? controller;

  /// External focus node
  final FocusNode? focusNode;

  /// Disabled state - prevents input
  final bool disabled;

  /// Read-only state - allows selection but no editing
  final bool readOnly;

  /// Size variant affects padding and font size
  final CuSize size;

  /// Variant type (default, success, warning, error)
  final CuVariant type;

  /// Maximum character length
  final int? maxLength;

  /// Minimum visible lines
  final int minLines;

  /// Maximum visible lines before scrolling
  final int maxLines;

  /// Called when text changes
  final ValueChanged<String>? onChanged;

  /// Called when editing is complete
  final VoidCallback? onSubmitted;

  /// Error text (shows error state)
  final String? errorText;

  /// Helper text below textarea
  final String? helperText;

  /// Fixed width
  final double? width;

  /// Fixed height (overrides minLines/maxLines)
  final double? height;

  const CuTextarea({
    super.key,
    this.label,
    this.placeholder,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.disabled = false,
    this.readOnly = false,
    this.size = CuSize.medium,
    this.type = CuVariant.default_,
    this.maxLength,
    this.minLines = 3,
    this.maxLines = 6,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.helperText,
    this.width,
    this.height,
  });

  @override
  State<CuTextarea> createState() => _CuTextareaState();
}

class _CuTextareaState extends State<CuTextarea> with CuComponentMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChange);
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _onTextChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final showPlaceholder = _controller.text.isEmpty && widget.placeholder != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.space1),
            child: Text(
              widget.label!,
              style: typography.label.copyWith(
                color: hasError ? colors.error.base : colors.accents5,
              ),
            ),
          ),

        // Textarea field
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.disabled ? null : () => _focusNode.requestFocus(),
            child: AnimatedContainer(
              duration: animation.normal,
              width: widget.width,
              height: widget.height,
              constraints: widget.height == null
                  ? BoxConstraints(
                      minHeight: _lineHeight * widget.minLines + _contentPadding.vertical,
                    )
                  : null,
              decoration: BoxDecoration(
                color: widget.disabled ? colors.accents1 : colors.background,
                border: Border.all(
                  color: _borderColor(hasError),
                  width: borders.width,
                ),
                borderRadius: radius.mdBorder,
              ),
              child: Padding(
                padding: _contentPadding,
                child: Stack(
                  children: [
                    // Placeholder
                    if (showPlaceholder)
                      IgnorePointer(
                        child: Text(
                          widget.placeholder!,
                          style: _textStyle.copyWith(color: colors.accents4),
                        ),
                      ),
                    // Editable text
                    EditableText(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: _textStyle,
                      cursorColor: colors.foreground,
                      backgroundCursorColor: colors.accents2,
                      maxLines: widget.maxLines,
                      minLines: widget.minLines,
                      keyboardType: TextInputType.multiline,
                      inputFormatters: _buildInputFormatters(),
                      readOnly: widget.disabled || widget.readOnly,
                      onChanged: widget.onChanged,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Character count (if maxLength set)
        if (widget.maxLength != null)
          Padding(
            padding: EdgeInsets.only(top: spacing.space1),
            child: Text(
              '${_controller.text.length}/${widget.maxLength}',
              style: typography.caption.copyWith(color: colors.accents4),
              textAlign: TextAlign.right,
            ),
          ),

        // Helper / Error text
        if (widget.helperText != null || widget.errorText != null)
          Padding(
            padding: EdgeInsets.only(top: spacing.space1),
            child: Text(
              widget.errorText ?? widget.helperText!,
              style: typography.caption.copyWith(
                color: hasError ? colors.error.base : colors.accents4,
              ),
            ),
          ),
      ],
    );
  }

  List<TextInputFormatter>? _buildInputFormatters() {
    if (widget.maxLength == null) return null;
    return [LengthLimitingTextInputFormatter(widget.maxLength)];
  }

  Color _borderColor(bool hasError) {
    if (hasError) return colors.error.base;
    if (_isFocused) return colors.foreground;
    if (_isHovered) return colors.accents5;
    return colors.border;
  }

  double get _lineHeight => _textStyle.fontSize! * (_textStyle.height ?? 1.5);

  EdgeInsets get _contentPadding => widget.size.resolve(
        small: EdgeInsets.all(spacing.space2),
        medium: EdgeInsets.all(spacing.space3),
        large: EdgeInsets.all(spacing.space4),
      );

  TextStyle get _textStyle => widget.size.resolve(
        small: typography.bodySmall.copyWith(color: colors.foreground),
        medium: typography.body.copyWith(color: colors.foreground),
        large: typography.bodyLarge.copyWith(color: colors.foreground),
      );
}
