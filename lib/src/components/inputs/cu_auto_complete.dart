import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';
import '../feedback/cu_spinner.dart';

/// AutoComplete option
class CuAutoCompleteOption {
  /// Display label
  final String label;

  /// Option value
  final String value;

  const CuAutoCompleteOption({
    required this.label,
    required this.value,
  });
}

/// CU UI AutoComplete Component
/// Matches Geist UI AutoComplete - input with suggestions
class CuAutoComplete extends StatefulWidget {
  /// Static options
  final List<CuAutoCompleteOption>? options;

  /// Dynamic options search
  final Future<List<CuAutoCompleteOption>> Function(String)? onSearch;

  /// Current value
  final String? value;

  /// On change callback
  final ValueChanged<String>? onChange;

  /// On select callback
  final ValueChanged<CuAutoCompleteOption>? onSelect;

  /// Placeholder text
  final String? placeholder;

  /// Label text
  final String? label;

  /// Size variant
  final CuSize size;

  /// Disabled state
  final bool disabled;

  /// Clear button
  final bool clearable;

  /// Minimum chars before showing suggestions
  final int minChars;

  /// Width
  final double? width;

  const CuAutoComplete({
    super.key,
    this.options,
    this.onSearch,
    this.value,
    this.onChange,
    this.onSelect,
    this.placeholder,
    this.label,
    this.size = CuSize.medium,
    this.disabled = false,
    this.clearable = false,
    this.minChars = 1,
    this.width,
  });

  @override
  State<CuAutoComplete> createState() => _CuAutoCompleteState();
}

class _CuAutoCompleteState extends State<CuAutoComplete> with CuComponentMixin {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _isLoading = false;
  List<CuAutoCompleteOption> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value ?? '';
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(CuAutoComplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _closeDropdown();
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_focusNode.hasFocus) {
          _closeDropdown();
        }
      });
    }
  }

  void _onTextChanged(String text) {
    widget.onChange?.call(text);

    if (text.length >= widget.minChars) {
      _updateOptions(text);
      _openDropdown();
    } else {
      _closeDropdown();
    }
  }

  Future<void> _updateOptions(String query) async {
    if (widget.onSearch != null) {
      setState(() => _isLoading = true);
      try {
        final results = await widget.onSearch!(query);
        if (mounted) {
          setState(() {
            _filteredOptions = results;
            _isLoading = false;
          });
          _updateOverlay();
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else if (widget.options != null) {
      final lowerQuery = query.toLowerCase();
      setState(() {
        _filteredOptions = widget.options!
            .where((option) =>
                option.label.toLowerCase().contains(lowerQuery) ||
                option.value.toLowerCase().contains(lowerQuery))
            .toList();
      });
      _updateOverlay();
    }
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _openDropdown() {
    if (_overlayEntry != null || _filteredOptions.isEmpty) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closeDropdown,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              offset: const Offset(0, 4),
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {},
                child: _AutoCompleteDropdown(
                  options: _filteredOptions,
                  isLoading: _isLoading,
                  onSelect: _onSelect,
                  width: widget.width,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => _isOpen = false);
    }
  }

  void _onSelect(CuAutoCompleteOption option) {
    _controller.text = option.label;
    widget.onChange?.call(option.value);
    widget.onSelect?.call(option);
    _closeDropdown();
  }

  void _clear() {
    _controller.clear();
    widget.onChange?.call('');
    _closeDropdown();
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
            style: typography.bodySmall.copyWith(fontWeight: typography.weightMedium),
          ),
          SizedBox(height: spacing.space2),
        ],
        CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            width: widget.width,
            decoration: BoxDecoration(
              color: widget.disabled ? colors.accents1 : colors.background,
              border: Border.all(
                color: _isOpen || _focusNode.hasFocus
                    ? colors.foreground
                    : colors.border,
              ),
              borderRadius: radius.mdBorder,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: _padding,
                    child: Stack(
                      children: [
                        if (_controller.text.isEmpty && widget.placeholder != null)
                          IgnorePointer(
                            child: Text(
                              widget.placeholder!,
                              style: typography.body.copyWith(color: colors.accents4),
                            ),
                          ),
                        EditableText(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: typography.body.copyWith(color: colors.foreground),
                          cursorColor: colors.foreground,
                          backgroundCursorColor: colors.accents2,
                          readOnly: widget.disabled,
                          onChanged: _onTextChanged,
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.clearable && _controller.text.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(right: spacing.space3),
                    child: GestureDetector(
                      onTap: _clear,
                      child: Text(
                        '\u{2715}',
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.accents5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AutoCompleteDropdown extends StatefulWidget {
  final List<CuAutoCompleteOption> options;
  final bool isLoading;
  final ValueChanged<CuAutoCompleteOption> onSelect;
  final double? width;

  const _AutoCompleteDropdown({
    required this.options,
    required this.isLoading,
    required this.onSelect,
    this.width,
  });

  @override
  State<_AutoCompleteDropdown> createState() => _AutoCompleteDropdownState();
}

class _AutoCompleteDropdownState extends State<_AutoCompleteDropdown> with CuComponentMixin {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width ?? 200,
        constraints: const BoxConstraints(maxHeight: 300),
        decoration: BoxDecoration(
          color: colors.background,
          border: Border.all(color: colors.border),
          borderRadius: radius.mdBorder,
          boxShadow: shadows.dropdownList,
        ),
        child: ClipRRect(
          borderRadius: radius.mdBorder,
          child: widget.isLoading
              ? Padding(
                  padding: EdgeInsets.all(spacing.space4),
                  child: Center(
                    child: CuSpinner(size: 20, color: colors.foreground),
                  ),
                )
              : widget.options.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(spacing.space4),
                      child: Text(
                        'No results',
                        style: typography.body.copyWith(color: colors.accents5),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: widget.options.asMap().entries.map((entry) {
                          final index = entry.key;
                          final option = entry.value;
                          final isHovered = _hoveredIndex == index;

                          return MouseRegion(
                            onEnter: (_) => setState(() => _hoveredIndex = index),
                            onExit: (_) => setState(() => _hoveredIndex = null),
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => widget.onSelect(option),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: spacing.space4,
                                  vertical: spacing.space3,
                                ),
                                color: isHovered ? colors.accents1 : colors.background,
                                child: Text(
                                  option.label,
                                  style: typography.body,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
        ),
    );
  }
}
