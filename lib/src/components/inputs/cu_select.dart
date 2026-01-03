import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Select option
class CuSelectOption<T> {
  /// Option value
  final T value;

  /// Display label
  final String label;

  /// Whether option is disabled
  final bool disabled;

  const CuSelectOption({
    required this.value,
    required this.label,
    this.disabled = false,
  });
}

/// CU UI Select Component
/// Matches Geist UI Select - dropdown selection
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

  /// Size variant
  final CuSize size;

  /// Disabled state
  final bool disabled;

  /// Error state
  final bool error;

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
    this.size = CuSize.medium,
    this.disabled = false,
    this.error = false,
    this.width,
    this.multiple = false,
  });

  @override
  State<CuSelect<T>> createState() => _CuSelectState<T>();
}

class _CuSelectState<T> extends State<CuSelect<T>> with CuComponentMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  CuSelectOption<T>? get _selectedOption {
    if (widget.value == null) return null;
    return widget.options.cast<CuSelectOption<T>?>().firstWhere(
          (option) => option?.value == widget.value,
          orElse: () => null,
        );
  }

  void _toggleDropdown() {
    if (widget.disabled) return;
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
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
                child: _SelectDropdown<T>(
                  options: widget.options,
                  value: widget.value,
                  onSelect: (value) {
                    widget.onChange?.call(value);
                    _closeDropdown();
                  },
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

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
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
          child: MouseRegion(
            cursor: widget.disabled
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _toggleDropdown,
              child: Container(
                width: widget.width,
                padding: _padding,
                decoration: BoxDecoration(
                  color: widget.disabled ? colors.accents1 : colors.background,
                  border: Border.all(
                    color: widget.error
                        ? colors.error.base
                        : _isOpen
                            ? colors.foreground
                            : colors.border,
                  ),
                  borderRadius: radius.mdBorder,
                ),
                child: Row(
                  mainAxisSize: widget.width == null ? MainAxisSize.min : MainAxisSize.max,
                  children: [
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
                    AnimatedRotation(
                      duration: animation.fast,
                      turns: _isOpen ? 0.5 : 0,
                      child: Text(
                        '\u{25BC}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.accents5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectDropdown<T> extends StatefulWidget {
  final List<CuSelectOption<T>> options;
  final T? value;
  final ValueChanged<T> onSelect;
  final double? width;

  const _SelectDropdown({
    required this.options,
    required this.value,
    required this.onSelect,
    this.width,
  });

  @override
  State<_SelectDropdown<T>> createState() => _SelectDropdownState<T>();
}

class _SelectDropdownState<T> extends State<_SelectDropdown<T>> with CuComponentMixin {
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: widget.options.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final isSelected = option.value == widget.value;
                final isHovered = _hoveredIndex == index;

                return MouseRegion(
                  onEnter: (_) => setState(() => _hoveredIndex = index),
                  onExit: (_) => setState(() => _hoveredIndex = null),
                  cursor: option.disabled
                      ? SystemMouseCursors.forbidden
                      : SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: option.disabled ? null : () => widget.onSelect(option.value),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.space4,
                        vertical: spacing.space3,
                      ),
                      color: isSelected
                          ? colors.accents2
                          : isHovered
                              ? colors.accents1
                              : colors.background,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option.label,
                              style: typography.body.copyWith(
                                color: option.disabled
                                    ? colors.accents4
                                    : colors.foreground,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Text(
                              '\u{2713}',
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.foreground,
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
        ),
    );
  }
}
