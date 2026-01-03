import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Checkbox Component
/// Checkbox with label and group support
class CuCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final bool disabled;
  final CuSize size;
  final CuVariant type;
  final bool indeterminate;

  const CuCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.disabled = false,
    this.size = CuSize.medium,
    this.type = CuVariant.default_,
    this.indeterminate = false,
  });

  @override
  State<CuCheckbox> createState() => _CuCheckboxState();
}

class _CuCheckboxState extends State<CuCheckbox> with CuComponentMixin {
  bool _isHovered = false;

  void _handleTap() {
    if (!widget.disabled && widget.onChanged != null) {
      widget.onChanged!(!widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _handleTap,
        child: Opacity(
          opacity: widget.disabled ? 0.5 : 1.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: animation.fast,
                width: _checkboxSize,
                height: _checkboxSize,
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  border: Border.all(
                    color: _borderColor,
                    width: borders.width,
                  ),
                  borderRadius: radius.smBorder,
                ),
                child: _buildCheckmark(),
              ),
              if (widget.label != null) ...[
                SizedBox(width: spacing.space2),
                Text(
                  widget.label!,
                  style: _labelStyle,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildCheckmark() {
    if (widget.indeterminate) {
      return Center(
        child: Container(
          width: _checkboxSize * 0.6,
          height: 2,
          color: colors.background,
        ),
      );
    }

    if (widget.value) {
      return Center(
        child: Icon(
          Icons.check,
          size: _checkboxSize * 0.75,
          color: colors.background,
        ),
      );
    }

    return null;
  }

  double get _checkboxSize => widget.size.resolve(
        small: 14.0,
        medium: 16.0,
        large: 20.0,
      );

  Color get _backgroundColor {
    if (widget.value || widget.indeterminate) {
      return widget.type.resolveColor(colors);
    }
    return colors.background;
  }

  Color get _borderColor {
    if (widget.value || widget.indeterminate) {
      return widget.type.resolveColor(colors);
    }
    if (_isHovered) return colors.foreground;
    return colors.border;
  }

  TextStyle get _labelStyle => widget.size.resolve(
        small: typography.bodySmall.copyWith(color: colors.foreground),
        medium: typography.body.copyWith(color: colors.foreground),
        large: typography.bodyLarge.copyWith(color: colors.foreground),
      );
}

/// Checkbox Group for managing multiple checkboxes
class CuCheckboxGroup extends StatelessWidget {
  final List<String> options;
  final List<String> values;
  final ValueChanged<List<String>>? onChanged;
  final bool disabled;
  final CuSize size;
  final Axis direction;
  final double spacing;

  const CuCheckboxGroup({
    super.key,
    required this.options,
    required this.values,
    this.onChanged,
    this.disabled = false,
    this.size = CuSize.medium,
    this.direction = Axis.vertical,
    this.spacing = 8.0,
  });

  void _handleChange(String option, bool isChecked) {
    if (onChanged == null) return;

    final newValues = List<String>.from(values);
    if (isChecked) {
      newValues.add(option);
    } else {
      newValues.remove(option);
    }
    onChanged!(newValues);
  }

  @override
  Widget build(BuildContext context) {
    final children = options.map((option) {
      return CuCheckbox(
        value: values.contains(option),
        onChanged: disabled ? null : (checked) => _handleChange(option, checked),
        label: option,
        disabled: disabled,
        size: size,
      );
    }).toList();

    if (direction == Axis.horizontal) {
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: children,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children.map((child) {
        final index = children.indexOf(child);
        return Padding(
          padding: EdgeInsets.only(bottom: index < children.length - 1 ? spacing : 0),
          child: child,
        );
      }).toList(),
    );
  }
}
