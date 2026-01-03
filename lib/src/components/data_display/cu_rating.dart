import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Rating type variants
enum CuRatingType {
  default_,
  success,
  warning,
  error,
}

/// CU UI Rating Component
/// Matches Geist UI Rating - star rating display
class CuRating extends StatefulWidget {
  /// Current value
  final double value;

  /// Maximum value
  final int count;

  /// On value change callback
  final ValueChanged<double>? onValueChange;

  /// Rating type
  final CuRatingType type;

  /// Locked (read-only)
  final bool locked;

  /// Size variant
  final CuSize size;

  /// Custom symbol (unicode character)
  final String? symbol;

  /// Custom filled symbol (unicode character)
  final String? filledSymbol;

  const CuRating({
    super.key,
    this.value = 0,
    this.count = 5,
    this.onValueChange,
    this.type = CuRatingType.default_,
    this.locked = false,
    this.size = CuSize.medium,
    this.symbol,
    this.filledSymbol,
  });

  @override
  State<CuRating> createState() => _CuRatingState();
}

class _CuRatingState extends State<CuRating> with CuComponentMixin {
  late double _value;
  double? _hoverValue;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(CuRating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _value = widget.value;
    }
  }

  Color get _color {
    switch (widget.type) {
      case CuRatingType.default_:
        return colors.foreground;
      case CuRatingType.success:
        return colors.success.base;
      case CuRatingType.warning:
        return colors.warning.base;
      case CuRatingType.error:
        return colors.error.base;
    }
  }

  double get _iconSize {
    return widget.size.resolve(
      small: 16.0,
      medium: 20.0,
      large: 28.0,
    );
  }

  void _handleTap(int index) {
    if (widget.locked) return;
    final newValue = index + 1.0;
    setState(() => _value = newValue);
    widget.onValueChange?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final displayValue = _hoverValue ?? _value;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.count, (index) {
        final isFilled = index < displayValue.floor();
        final isPartial = index == displayValue.floor() && displayValue % 1 > 0;
        final partialValue = isPartial ? displayValue % 1 : 0.0;

        return MouseRegion(
          onEnter: widget.locked ? null : (_) => setState(() => _hoverValue = index + 1.0),
          onExit: widget.locked ? null : (_) => setState(() => _hoverValue = null),
          cursor: widget.locked ? SystemMouseCursors.basic : SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _handleTap(index),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.space1 / 2),
              child: Stack(
                children: [
                  Text(
                    widget.symbol ?? '\u{2606}',
                    style: TextStyle(
                      fontSize: _iconSize,
                      color: colors.accents4,
                      height: 1.0,
                    ),
                  ),
                  if (isFilled || isPartial)
                    ClipRect(
                      clipper: _PartialClipper(isPartial ? partialValue : 1.0),
                      child: Text(
                        widget.filledSymbol ?? '\u{2605}',
                        style: TextStyle(
                          fontSize: _iconSize,
                          color: _color,
                          height: 1.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _PartialClipper extends CustomClipper<Rect> {
  final double percentage;

  _PartialClipper(this.percentage);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * percentage, size.height);
  }

  @override
  bool shouldReclip(_PartialClipper oldClipper) {
    return oldClipper.percentage != percentage;
  }
}
