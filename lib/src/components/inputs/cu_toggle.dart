import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Toggle Component
/// Toggle switch with optional label
class CuToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final bool disabled;
  final CuSize size;
  final CuVariant type;

  const CuToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.disabled = false,
    this.size = CuSize.medium,
    this.type = CuVariant.default_,
  });

  @override
  State<CuToggle> createState() => _CuToggleState();
}

class _CuToggleState extends State<CuToggle> with CuComponentMixin, SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: animation.fast,
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: animation.ease,
    );
  }

  @override
  void didUpdateWidget(CuToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: _trackWidth,
                    height: _trackHeight,
                    decoration: BoxDecoration(
                      color: ColorTween(
                        begin: colors.accents2,
                        end: _activeColor,
                      ).evaluate(_animation),
                      borderRadius: BorderRadius.circular(_trackHeight / 2),
                      border: Border.all(
                        color: _isHovered && !widget.value
                            ? colors.accents4
                            : const Color(0x00000000),
                        width: borders.width,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: Tween<double>(
                            begin: 2.0,
                            end: _trackWidth - _thumbSize - 2,
                          ).evaluate(_animation),
                          top: (_trackHeight - _thumbSize) / 2,
                          child: Container(
                            width: _thumbSize,
                            height: _thumbSize,
                            decoration: BoxDecoration(
                              color: colors.background,
                              shape: BoxShape.circle,
                              boxShadow: [shadows.small],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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

  double get _trackWidth => widget.size.resolve(
        small: 28.0,
        medium: 36.0,
        large: 44.0,
      );

  double get _trackHeight => widget.size.resolve(
        small: 16.0,
        medium: 20.0,
        large: 24.0,
      );

  double get _thumbSize => widget.size.resolve(
        small: 12.0,
        medium: 16.0,
        large: 20.0,
      );

  Color get _activeColor {
    switch (widget.type) {
      case CuVariant.default_:
        return colors.foreground;
      case CuVariant.success:
        return colors.success.base;
      case CuVariant.warning:
        return colors.warning.base;
      case CuVariant.error:
        return colors.error.base;
      case CuVariant.secondary:
        return colors.accents6;
    }
  }

  TextStyle get _labelStyle => widget.size.resolve(
        small: typography.bodySmall.copyWith(color: colors.foreground),
        medium: typography.body.copyWith(color: colors.foreground),
        large: typography.bodyLarge.copyWith(color: colors.foreground),
      );
}
