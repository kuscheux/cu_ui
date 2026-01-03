import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';
import '../feedback/cu_spinner.dart';
import '../feedback/cu_splash.dart';

/// Button type variants
enum CuButtonType {
  default_,
  secondary,
  success,
  warning,
  error,
  secondaryLight,
  successLight,
  warningLight,
  errorLight,
  abort,
}

/// CU UI Button Component
/// Matches Geist UI Button with all variants and sizes
class CuButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final CuButtonType type;
  final CuSize size;
  final bool loading;
  final bool disabled;
  final bool auto; // Auto-width
  final bool ghost; // Transparent background
  final bool shadow; // Show shadow
  final Widget? icon;
  final Widget? iconRight;

  const CuButton({
    super.key,
    required this.child,
    this.onPressed,
    this.type = CuButtonType.default_,
    this.size = CuSize.medium,
    this.loading = false,
    this.disabled = false,
    this.auto = false,
    this.ghost = false,
    this.shadow = false,
    this.icon,
    this.iconRight,
  });

  /// Primary button factory
  factory CuButton.primary({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    CuSize size = CuSize.medium,
    bool loading = false,
    bool disabled = false,
    Widget? icon,
    Widget? iconRight,
  }) {
    return CuButton(
      key: key,
      onPressed: onPressed,
      type: CuButtonType.default_,
      size: size,
      loading: loading,
      disabled: disabled,
      icon: icon,
      iconRight: iconRight,
      child: child,
    );
  }

  /// Secondary button factory
  factory CuButton.secondary({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    CuSize size = CuSize.medium,
    bool loading = false,
    bool disabled = false,
    Widget? icon,
    Widget? iconRight,
  }) {
    return CuButton(
      key: key,
      onPressed: onPressed,
      type: CuButtonType.secondary,
      size: size,
      loading: loading,
      disabled: disabled,
      icon: icon,
      iconRight: iconRight,
      child: child,
    );
  }

  /// Success button factory
  factory CuButton.success({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    CuSize size = CuSize.medium,
    bool loading = false,
    bool disabled = false,
  }) {
    return CuButton(
      key: key,
      onPressed: onPressed,
      type: CuButtonType.success,
      size: size,
      loading: loading,
      disabled: disabled,
      child: child,
    );
  }

  /// Warning button factory
  factory CuButton.warning({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    CuSize size = CuSize.medium,
    bool loading = false,
    bool disabled = false,
  }) {
    return CuButton(
      key: key,
      onPressed: onPressed,
      type: CuButtonType.warning,
      size: size,
      loading: loading,
      disabled: disabled,
      child: child,
    );
  }

  /// Error button factory
  factory CuButton.error({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    CuSize size = CuSize.medium,
    bool loading = false,
    bool disabled = false,
  }) {
    return CuButton(
      key: key,
      onPressed: onPressed,
      type: CuButtonType.error,
      size: size,
      loading: loading,
      disabled: disabled,
      child: child,
    );
  }

  @override
  State<CuButton> createState() => _CuButtonState();
}

class _CuButtonState extends State<CuButton> with CuComponentMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  bool get _isDisabled => widget.disabled || widget.loading;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor:
          _isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: animation.normal,
        curve: animation.ease,
        constraints: widget.auto
            ? null
            : BoxConstraints(
                minWidth: widget.size.resolve(
                  small: 80.0,
                  medium: 100.0,
                  large: 120.0,
                ),
              ),
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(
            color: _borderColor,
            width: borders.width,
          ),
          borderRadius: radius.mdBorder,
          boxShadow: widget.shadow && !_isDisabled ? shadows.smallList : null,
        ),
        child: CuSplash(
          onTap: _isDisabled ? null : widget.onPressed,
          disabled: _isDisabled,
          borderRadius: radius.mdBorder,
          splashColor: _textColor.withValues(alpha: 0.1),
          hoverColor: const Color(0x00000000),
          showHover: false,
          child: Padding(
            padding: _padding,
            child: Center(
              child: Row(
                mainAxisSize: widget.auto ? MainAxisSize.min : MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.loading)
                    Padding(
                      padding: EdgeInsets.only(right: spacing.space2),
                      child: CuSpinner(size: _iconSize, color: _textColor),
                    )
                  else if (widget.icon != null)
                    Padding(
                      padding: EdgeInsets.only(right: spacing.space2),
                      child: DefaultTextStyle(
                        style: TextStyle(fontSize: _iconSize, color: _textColor),
                        child: widget.icon!,
                      ),
                    ),
                  DefaultTextStyle(
                    style: _textStyle,
                    textAlign: TextAlign.center,
                    child: widget.child,
                  ),
                  if (widget.iconRight != null)
                    Padding(
                      padding: EdgeInsets.only(left: spacing.space2),
                      child: DefaultTextStyle(
                        style: TextStyle(fontSize: _iconSize, color: _textColor),
                        child: widget.iconRight!,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsets get _padding => widget.size.resolve(
        small: EdgeInsets.symmetric(
          horizontal: spacing.space3,
          vertical: spacing.space1,
        ),
        medium: EdgeInsets.symmetric(
          horizontal: spacing.space4,
          vertical: spacing.space2,
        ),
        large: EdgeInsets.symmetric(
          horizontal: spacing.space6,
          vertical: spacing.space3,
        ),
      );

  double get _iconSize => widget.size.resolve(
        small: 14.0,
        medium: 16.0,
        large: 20.0,
      );

  Color get _backgroundColor {
    if (widget.ghost) return const Color(0x00000000);
    if (_isDisabled) return colors.accents2;

    switch (widget.type) {
      case CuButtonType.default_:
        return _isHovered ? colors.background : colors.foreground;
      case CuButtonType.secondary:
        return _isHovered ? colors.accents2 : colors.background;
      case CuButtonType.success:
        return _isHovered ? colors.success.light : colors.success.base;
      case CuButtonType.warning:
        return _isHovered ? colors.warning.light : colors.warning.base;
      case CuButtonType.error:
        return _isHovered ? colors.error.light : colors.error.base;
      case CuButtonType.secondaryLight:
        return _isHovered ? colors.accents2 : colors.accents1;
      case CuButtonType.successLight:
        return _isHovered ? colors.success.lighter : colors.success.lighter;
      case CuButtonType.warningLight:
        return _isHovered ? colors.warning.lighter : colors.warning.lighter;
      case CuButtonType.errorLight:
        return _isHovered ? colors.error.lighter : colors.error.lighter;
      case CuButtonType.abort:
        return const Color(0x00000000);
    }
  }

  Color get _borderColor {
    if (widget.ghost) {
      return _isHovered ? colors.foreground : colors.border;
    }

    switch (widget.type) {
      case CuButtonType.default_:
        return _isHovered ? colors.background : colors.foreground;
      case CuButtonType.secondary:
        return colors.border;
      case CuButtonType.success:
        return _isHovered ? colors.success.light : colors.success.base;
      case CuButtonType.warning:
        return _isHovered ? colors.warning.light : colors.warning.base;
      case CuButtonType.error:
        return _isHovered ? colors.error.light : colors.error.base;
      case CuButtonType.secondaryLight:
        return colors.accents2;
      case CuButtonType.successLight:
        return colors.success.lighter;
      case CuButtonType.warningLight:
        return colors.warning.lighter;
      case CuButtonType.errorLight:
        return colors.error.lighter;
      case CuButtonType.abort:
        return const Color(0x00000000);
    }
  }

  Color get _textColor {
    if (_isDisabled) return colors.accents4;

    switch (widget.type) {
      case CuButtonType.default_:
        return _isHovered ? colors.foreground : colors.background;
      case CuButtonType.secondary:
        return colors.foreground;
      case CuButtonType.success:
      case CuButtonType.warning:
      case CuButtonType.error:
        return const Color(0xFFFFFFFF);
      case CuButtonType.secondaryLight:
        return colors.foreground;
      case CuButtonType.successLight:
        return colors.success.base;
      case CuButtonType.warningLight:
        return colors.warning.base;
      case CuButtonType.errorLight:
        return colors.error.base;
      case CuButtonType.abort:
        return colors.accents5;
    }
  }

  TextStyle get _textStyle => widget.size.resolve(
        small: typography.bodySmall
            .copyWith(color: _textColor, fontWeight: typography.weightMedium),
        medium: typography.body
            .copyWith(color: _textColor, fontWeight: typography.weightMedium),
        large: typography.bodyLarge
            .copyWith(color: _textColor, fontWeight: typography.weightMedium),
      );
}
