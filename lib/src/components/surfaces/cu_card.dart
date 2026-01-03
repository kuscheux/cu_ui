import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Card type variants
enum CuCardType {
  default_,
  secondary,
  success,
  warning,
  error,
  dark,
  lite,
  alert,
  purple,
  violet,
  cyan,
}

/// CU UI Card Component
/// Card container with various types and hover effects
class CuCard extends StatefulWidget {
  final Widget child;
  final CuCardType type;
  final bool hoverable;
  final bool shadow;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Widget? header;
  final Widget? footer;

  const CuCard({
    super.key,
    required this.child,
    this.type = CuCardType.default_,
    this.hoverable = false,
    this.shadow = false,
    this.padding,
    this.onTap,
    this.header,
    this.footer,
  });

  @override
  State<CuCard> createState() => _CuCardState();
}

class _CuCardState extends State<CuCard> with CuComponentMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.hoverable ? (_) => setState(() => _isHovered = true) : null,
      onExit: widget.hoverable ? (_) => setState(() => _isHovered = false) : null,
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: animation.normal,
          curve: animation.ease,
          transform: _isHovered && widget.hoverable
              ? (Matrix4.identity()..translate(0.0, -1.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: _backgroundColor,
            border: Border.all(
              color: _borderColor,
              width: borders.width,
            ),
            borderRadius: radius.mdBorder,
            boxShadow: _boxShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.header != null) ...[
                Padding(
                  padding: widget.padding ?? EdgeInsets.all(spacing.space4),
                  child: widget.header,
                ),
                Container(
                  height: borders.width,
                  color: _borderColor,
                ),
              ],
              Padding(
                padding: widget.padding ?? EdgeInsets.all(spacing.space4),
                child: widget.child,
              ),
              if (widget.footer != null) ...[
                Container(
                  height: borders.width,
                  color: _borderColor,
                ),
                Container(
                  padding: widget.padding ?? EdgeInsets.all(spacing.space4),
                  decoration: BoxDecoration(
                    color: colors.accents1,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(radius.md),
                      bottomRight: Radius.circular(radius.md),
                    ),
                  ),
                  child: widget.footer,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (widget.type) {
      case CuCardType.default_:
        return colors.background;
      case CuCardType.secondary:
        return colors.accents1;
      case CuCardType.success:
        return colors.success.lighter;
      case CuCardType.warning:
        return colors.warning.lighter;
      case CuCardType.error:
        return colors.error.lighter;
      case CuCardType.dark:
        return colors.foreground;
      case CuCardType.lite:
        return colors.background;
      case CuCardType.alert:
        return colors.alert.withOpacity(0.1);
      case CuCardType.purple:
        return colors.purple.withOpacity(0.1);
      case CuCardType.violet:
        return colors.violet.lighter;
      case CuCardType.cyan:
        return colors.cyan.lighter;
    }
  }

  Color get _borderColor {
    switch (widget.type) {
      case CuCardType.default_:
      case CuCardType.lite:
        return colors.border;
      case CuCardType.secondary:
        return colors.accents2;
      case CuCardType.success:
        return colors.success.light;
      case CuCardType.warning:
        return colors.warning.light;
      case CuCardType.error:
        return colors.error.light;
      case CuCardType.dark:
        return colors.foreground;
      case CuCardType.alert:
        return colors.alert;
      case CuCardType.purple:
        return colors.purple;
      case CuCardType.violet:
        return colors.violet.light;
      case CuCardType.cyan:
        return colors.cyan.light;
    }
  }

  List<BoxShadow>? get _boxShadow {
    if (widget.shadow || (_isHovered && widget.hoverable)) {
      return _isHovered ? shadows.mediumList : shadows.smallList;
    }
    return null;
  }
}

/// Card Content wrapper
class CuCardContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const CuCardContent({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(context.cuSpacing.space4),
      child: child,
    );
  }
}

/// Card Footer wrapper
class CuCardFooter extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const CuCardFooter({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(context.cuSpacing.space4),
      decoration: BoxDecoration(
        color: context.cuColors.accents1,
      ),
      child: child,
    );
  }
}
