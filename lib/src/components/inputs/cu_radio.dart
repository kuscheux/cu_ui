import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../../services/cu_haptics.dart';
import '../../services/cu_sounds.dart';
import '../_base/cu_component.dart';

/// CU UI Radio Component
/// Radio button with label
class CuRadio<T> extends StatefulWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final bool disabled;
  final CuSize size;

  const CuRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
    this.disabled = false,
    this.size = CuSize.medium,
  });

  @override
  State<CuRadio<T>> createState() => _CuRadioState<T>();
}

class _CuRadioState<T> extends State<CuRadio<T>> with CuComponentMixin {
  bool _isHovered = false;

  bool get _isSelected => widget.value == widget.groupValue;

  void _handleTap() {
    if (!widget.disabled && widget.onChanged != null) {
      if (theme.hapticsEnabled) CuHaptics.selection();
      if (theme.soundsEnabled) CuSounds.selection();
      widget.onChanged!(widget.value);
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
                width: _radioSize,
                height: _radioSize,
                decoration: BoxDecoration(
                  color: colors.background,
                  border: Border.all(
                    color: _borderColor,
                    width: borders.width,
                  ),
                  shape: BoxShape.circle,
                ),
                child: _isSelected
                    ? Center(
                        child: AnimatedContainer(
                          duration: animation.fast,
                          width: _radioSize * 0.5,
                          height: _radioSize * 0.5,
                          decoration: BoxDecoration(
                            color: colors.foreground,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
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

  double get _radioSize => widget.size.resolve(
        small: 14.0,
        medium: 16.0,
        large: 20.0,
      );

  Color get _borderColor {
    if (_isSelected) return colors.foreground;
    if (_isHovered) return colors.foreground;
    return colors.border;
  }

  TextStyle get _labelStyle => widget.size.resolve(
        small: typography.bodySmall.copyWith(color: colors.foreground),
        medium: typography.body.copyWith(color: colors.foreground),
        large: typography.bodyLarge.copyWith(color: colors.foreground),
      );
}

/// Radio Group for managing multiple radio buttons
class CuRadioGroup<T> extends StatelessWidget {
  final List<CuRadioOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool disabled;
  final CuSize size;
  final Axis direction;
  final double spacing;

  const CuRadioGroup({
    super.key,
    required this.options,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.size = CuSize.medium,
    this.direction = Axis.vertical,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final children = options.map((option) {
      return CuRadio<T>(
        value: option.value,
        groupValue: value,
        onChanged: disabled ? null : onChanged,
        label: option.label,
        disabled: disabled || option.disabled,
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

/// Radio option configuration
class CuRadioOption<T> {
  final T value;
  final String label;
  final bool disabled;

  const CuRadioOption({
    required this.value,
    required this.label,
    this.disabled = false,
  });
}
