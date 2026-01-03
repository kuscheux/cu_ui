import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Input Component
/// Text input with label, icon, clearable support
/// Uses EditableText instead of Material TextField
class CuInput extends StatefulWidget {
  final String? label;
  final String? labelRight;
  final String? placeholder;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool disabled;
  final bool readOnly;
  final bool clearable;
  final bool password;
  final CuSize size;
  final CuVariant type;
  final Widget? icon;
  final Widget? iconRight;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLength;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSubmitted;
  final String? errorText;
  final String? helperText;

  const CuInput({
    super.key,
    this.label,
    this.labelRight,
    this.placeholder,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.disabled = false,
    this.readOnly = false,
    this.clearable = false,
    this.password = false,
    this.size = CuSize.medium,
    this.type = CuVariant.default_,
    this.icon,
    this.iconRight,
    this.prefix,
    this.suffix,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onClear,
    this.onSubmitted,
    this.errorText,
    this.helperText,
  });

  @override
  State<CuInput> createState() => _CuInputState();
}

class _CuInputState extends State<CuInput> with CuComponentMixin, SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;
  bool _isFocused = false;
  bool _isHovered = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);

    // Animation controller for focus state
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _focusAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
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
    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onTextChange() {
    setState(() {});
  }

  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  String _obscurePassword(String text) {
    return '\u2022' * text.length;
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final showPlaceholder = _controller.text.isEmpty && widget.placeholder != null;
    final effectiveMaxLines = widget.password ? 1 : widget.maxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Labels
        if (widget.label != null || widget.labelRight != null)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.space1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: typography.label.copyWith(
                      color: hasError ? colors.error.base : colors.accents5,
                    ),
                  ),
                if (widget.labelRight != null)
                  Text(
                    widget.labelRight!,
                    style: typography.label.copyWith(color: colors.accents4),
                  ),
              ],
            ),
          ),

        // Input field
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.disabled ? null : () => _focusNode.requestFocus(),
            child: AnimatedBuilder(
              animation: _focusAnimation,
              builder: (context, child) {
                final borderWidth = Tween<double>(
                  begin: borders.width,
                  end: borders.width * 1.5,
                ).evaluate(_focusAnimation);

                return Container(
                  decoration: BoxDecoration(
                    color: widget.disabled ? colors.accents1 : colors.background,
                    border: Border.all(
                      color: _borderColor(hasError),
                      width: borderWidth,
                    ),
                    borderRadius: radius.mdBorder,
                    boxShadow: _isFocused && !hasError
                        ? [
                            BoxShadow(
                              color: colors.foreground.withValues(alpha: 0.1 * _focusAnimation.value),
                              blurRadius: 4 * _focusAnimation.value,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                  child: child,
                );
              },
              child: Row(
                children: [
                  // Prefix / Icon
                  if (widget.prefix != null)
                    Padding(
                      padding: EdgeInsets.only(left: spacing.space3),
                      child: widget.prefix,
                    )
                  else if (widget.icon != null)
                    Padding(
                      padding: EdgeInsets.only(left: spacing.space3),
                      child: DefaultTextStyle(
                        style: TextStyle(fontSize: _iconSize, color: colors.accents4),
                        child: widget.icon!,
                      ),
                    ),

                  // Text field with placeholder
                  Expanded(
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
                                maxLines: effectiveMaxLines,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          // Editable text (password display)
                          if (widget.password && _obscureText)
                            _buildPasswordField()
                          else
                            _buildEditableText(effectiveMaxLines),
                        ],
                      ),
                    ),
                  ),

                  // Clear button
                  if (widget.clearable && _controller.text.isNotEmpty && !widget.disabled)
                    GestureDetector(
                      onTap: _onClear,
                      child: Padding(
                        padding: EdgeInsets.only(right: spacing.space2),
                        child: Text(
                          '\u{2715}',
                          style: TextStyle(fontSize: _iconSize, color: colors.accents4),
                        ),
                      ),
                    ),

                  // Password toggle
                  if (widget.password)
                    GestureDetector(
                      onTap: () => setState(() => _obscureText = !_obscureText),
                      child: Padding(
                        padding: EdgeInsets.only(right: spacing.space3),
                        child: Text(
                          _obscureText ? '\u{25CF}' : '\u{25CB}',
                          style: TextStyle(fontSize: _iconSize, color: colors.accents4),
                        ),
                      ),
                    ),

                  // Suffix / Icon Right
                  if (widget.suffix != null)
                    Padding(
                      padding: EdgeInsets.only(right: spacing.space3),
                      child: widget.suffix,
                    )
                  else if (widget.iconRight != null && !widget.password && !widget.clearable)
                    Padding(
                      padding: EdgeInsets.only(right: spacing.space3),
                      child: DefaultTextStyle(
                        style: TextStyle(fontSize: _iconSize, color: colors.accents4),
                        child: widget.iconRight!,
                      ),
                    ),
                ],
              ),
            ),
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

  Widget _buildEditableText(int maxLines) {
    return EditableText(
      controller: _controller,
      focusNode: _focusNode,
      style: _textStyle,
      cursorColor: colors.foreground,
      backgroundCursorColor: colors.accents2,
      maxLines: maxLines,
      keyboardType: widget.keyboardType,
      inputFormatters: _buildInputFormatters(),
      readOnly: widget.disabled || widget.readOnly,
      onChanged: widget.onChanged,
      onSubmitted: (_) => widget.onSubmitted?.call(),
    );
  }

  Widget _buildPasswordField() {
    // For obscured password, we show bullets but use an invisible EditableText for input
    return Stack(
      children: [
        // Visible obscured text
        if (_controller.text.isNotEmpty)
          IgnorePointer(
            child: Text(
              _obscurePassword(_controller.text),
              style: _textStyle,
            ),
          ),
        // Invisible editable text for actual input
        Opacity(
          opacity: 0.0,
          child: EditableText(
            controller: _controller,
            focusNode: _focusNode,
            style: _textStyle,
            cursorColor: colors.foreground,
            backgroundCursorColor: colors.accents2,
            maxLines: 1,
            keyboardType: widget.keyboardType,
            inputFormatters: _buildInputFormatters(),
            readOnly: widget.disabled || widget.readOnly,
            onChanged: widget.onChanged,
            onSubmitted: (_) => widget.onSubmitted?.call(),
          ),
        ),
      ],
    );
  }

  List<TextInputFormatter>? _buildInputFormatters() {
    if (widget.maxLength == null && widget.inputFormatters == null) {
      return null;
    }

    final formatters = <TextInputFormatter>[];

    if (widget.maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(widget.maxLength));
    }

    if (widget.inputFormatters != null) {
      formatters.addAll(widget.inputFormatters!);
    }

    return formatters.isEmpty ? null : formatters;
  }

  Color _borderColor(bool hasError) {
    if (hasError) return colors.error.base;
    if (_isFocused) return colors.foreground;
    if (_isHovered) return colors.accents5;
    return colors.border;
  }

  double get _iconSize => widget.size.resolve(
        small: 14.0,
        medium: 16.0,
        large: 18.0,
      );

  EdgeInsets get _contentPadding => widget.size.resolve(
        small: EdgeInsets.symmetric(
          horizontal: spacing.space2,
          vertical: spacing.space1,
        ),
        medium: EdgeInsets.symmetric(
          horizontal: spacing.space3,
          vertical: spacing.space2,
        ),
        large: EdgeInsets.symmetric(
          horizontal: spacing.space3,
          vertical: spacing.space3,
        ),
      );

  TextStyle get _textStyle => widget.size.resolve(
        small: typography.bodySmall.copyWith(color: colors.foreground),
        medium: typography.body.copyWith(color: colors.foreground),
        large: typography.bodyLarge.copyWith(color: colors.foreground),
      );
}

