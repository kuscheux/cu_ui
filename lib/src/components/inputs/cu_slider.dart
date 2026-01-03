import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Slider Component
/// Range slider with customizable appearance
class CuSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final String? label;
  final bool disabled;
  final CuSize size;
  final CuVariant type;
  final bool showValue;
  final String Function(double)? valueFormatter;
  final double? step;

  const CuSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.label,
    this.disabled = false,
    this.size = CuSize.medium,
    this.type = CuVariant.default_,
    this.showValue = false,
    this.valueFormatter,
    this.step,
  });

  @override
  State<CuSlider> createState() => _CuSliderState();
}

class _CuSliderState extends State<CuSlider> with CuComponentMixin {
  bool _isDragging = false;
  bool _isHovered = false;

  double get _progress => (widget.value - widget.min) / (widget.max - widget.min);

  String get _formattedValue {
    if (widget.valueFormatter != null) {
      return widget.valueFormatter!(widget.value);
    }
    if (widget.step != null && widget.step! >= 1) {
      return widget.value.toInt().toString();
    }
    return widget.value.toStringAsFixed(1);
  }

  void _handleDragStart(DragStartDetails details) {
    if (widget.disabled) return;
    setState(() => _isDragging = true);
    widget.onChangeStart?.call(widget.value);
  }

  void _handleDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (widget.disabled || widget.onChanged == null) return;

    final trackWidth = constraints.maxWidth - _thumbSize;
    final newProgress = (details.localPosition.dx - _thumbSize / 2) / trackWidth;
    final clampedProgress = newProgress.clamp(0.0, 1.0);

    var newValue = widget.min + clampedProgress * (widget.max - widget.min);

    if (widget.step != null) {
      newValue = (newValue / widget.step!).round() * widget.step!;
    }

    widget.onChanged!(newValue.clamp(widget.min, widget.max));
  }

  void _handleDragEnd(DragEndDetails details) {
    if (widget.disabled) return;
    setState(() => _isDragging = false);
    widget.onChangeEnd?.call(widget.value);
  }

  void _handleTap(TapUpDetails details, BoxConstraints constraints) {
    if (widget.disabled || widget.onChanged == null) return;

    final trackWidth = constraints.maxWidth - _thumbSize;
    final newProgress = (details.localPosition.dx - _thumbSize / 2) / trackWidth;
    final clampedProgress = newProgress.clamp(0.0, 1.0);

    var newValue = widget.min + clampedProgress * (widget.max - widget.min);

    if (widget.step != null) {
      newValue = (newValue / widget.step!).round() * widget.step!;
    }

    widget.onChanged!(newValue.clamp(widget.min, widget.max));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label and value row
        if (widget.label != null || widget.showValue)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.space1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: typography.label.copyWith(color: colors.accents5),
                  ),
                if (widget.showValue)
                  Text(
                    _formattedValue,
                    style: typography.label.copyWith(color: colors.foreground),
                  ),
              ],
            ),
          ),

        // Slider track
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
          child: Opacity(
            opacity: widget.disabled ? 0.5 : 1.0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onHorizontalDragStart: _handleDragStart,
                  onHorizontalDragUpdate: (details) => _handleDragUpdate(details, constraints),
                  onHorizontalDragEnd: _handleDragEnd,
                  onTapUp: (details) => _handleTap(details, constraints),
                  child: SizedBox(
                    height: _thumbSize + spacing.space2,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        // Track background
                        Container(
                          height: _trackHeight,
                          decoration: BoxDecoration(
                            color: colors.accents2,
                            borderRadius: BorderRadius.circular(_trackHeight / 2),
                          ),
                        ),

                        // Track fill
                        FractionallySizedBox(
                          widthFactor: _progress,
                          child: Container(
                            height: _trackHeight,
                            decoration: BoxDecoration(
                              color: _activeColor,
                              borderRadius: BorderRadius.circular(_trackHeight / 2),
                            ),
                          ),
                        ),

                        // Thumb
                        Positioned(
                          left: _progress * (constraints.maxWidth - _thumbSize),
                          child: AnimatedContainer(
                            duration: animation.fast,
                            width: _thumbSize,
                            height: _thumbSize,
                            decoration: BoxDecoration(
                              color: colors.background,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _activeColor,
                                width: 2,
                              ),
                              boxShadow: _isDragging || _isHovered
                                  ? [shadows.medium]
                                  : [shadows.small],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  double get _trackHeight => widget.size.resolve(
        small: 4.0,
        medium: 6.0,
        large: 8.0,
      );

  double get _thumbSize => widget.size.resolve(
        small: 14.0,
        medium: 18.0,
        large: 22.0,
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
}

/// Range Slider for selecting a range of values
class CuRangeSlider extends StatefulWidget {
  final double startValue;
  final double endValue;
  final double min;
  final double max;
  final ValueChanged<(double, double)>? onChanged;
  final String? label;
  final bool disabled;
  final CuSize size;
  final CuVariant type;
  final bool showValues;
  final String Function(double)? valueFormatter;
  final double? step;

  const CuRangeSlider({
    super.key,
    required this.startValue,
    required this.endValue,
    this.min = 0.0,
    this.max = 100.0,
    this.onChanged,
    this.label,
    this.disabled = false,
    this.size = CuSize.medium,
    this.type = CuVariant.default_,
    this.showValues = false,
    this.valueFormatter,
    this.step,
  });

  @override
  State<CuRangeSlider> createState() => _CuRangeSliderState();
}

class _CuRangeSliderState extends State<CuRangeSlider> with CuComponentMixin {
  int? _activeThumb;
  bool _isHovered = false;

  double get _startProgress => (widget.startValue - widget.min) / (widget.max - widget.min);
  double get _endProgress => (widget.endValue - widget.min) / (widget.max - widget.min);

  String _formatValue(double value) {
    if (widget.valueFormatter != null) {
      return widget.valueFormatter!(value);
    }
    if (widget.step != null && widget.step! >= 1) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  void _handleDragStart(DragStartDetails details, BoxConstraints constraints) {
    if (widget.disabled) return;

    final trackWidth = constraints.maxWidth - _thumbSize;
    final tapPosition = (details.localPosition.dx - _thumbSize / 2) / trackWidth;

    final startDist = (tapPosition - _startProgress).abs();
    final endDist = (tapPosition - _endProgress).abs();

    setState(() => _activeThumb = startDist < endDist ? 0 : 1);
  }

  void _handleDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (widget.disabled || widget.onChanged == null || _activeThumb == null) return;

    final trackWidth = constraints.maxWidth - _thumbSize;
    final newProgress = (details.localPosition.dx - _thumbSize / 2) / trackWidth;
    final clampedProgress = newProgress.clamp(0.0, 1.0);

    var newValue = widget.min + clampedProgress * (widget.max - widget.min);

    if (widget.step != null) {
      newValue = (newValue / widget.step!).round() * widget.step!;
    }
    newValue = newValue.clamp(widget.min, widget.max);

    if (_activeThumb == 0) {
      if (newValue < widget.endValue) {
        widget.onChanged!((newValue, widget.endValue));
      }
    } else {
      if (newValue > widget.startValue) {
        widget.onChanged!((widget.startValue, newValue));
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (widget.disabled) return;
    setState(() => _activeThumb = null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label and values row
        if (widget.label != null || widget.showValues)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.space1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: typography.label.copyWith(color: colors.accents5),
                  ),
                if (widget.showValues)
                  Text(
                    '${_formatValue(widget.startValue)} - ${_formatValue(widget.endValue)}',
                    style: typography.label.copyWith(color: colors.foreground),
                  ),
              ],
            ),
          ),

        // Range slider track
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
          child: Opacity(
            opacity: widget.disabled ? 0.5 : 1.0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onHorizontalDragStart: (details) => _handleDragStart(details, constraints),
                  onHorizontalDragUpdate: (details) => _handleDragUpdate(details, constraints),
                  onHorizontalDragEnd: _handleDragEnd,
                  child: SizedBox(
                    height: _thumbSize + spacing.space2,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        // Track background
                        Container(
                          height: _trackHeight,
                          decoration: BoxDecoration(
                            color: colors.accents2,
                            borderRadius: BorderRadius.circular(_trackHeight / 2),
                          ),
                        ),

                        // Track fill between thumbs
                        Positioned(
                          left: _startProgress * (constraints.maxWidth - _thumbSize) + _thumbSize / 2,
                          width: (_endProgress - _startProgress) * (constraints.maxWidth - _thumbSize),
                          child: Container(
                            height: _trackHeight,
                            color: _activeColor,
                          ),
                        ),

                        // Start thumb
                        Positioned(
                          left: _startProgress * (constraints.maxWidth - _thumbSize),
                          child: AnimatedContainer(
                            duration: animation.fast,
                            width: _thumbSize,
                            height: _thumbSize,
                            decoration: BoxDecoration(
                              color: colors.background,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _activeColor,
                                width: 2,
                              ),
                              boxShadow: _activeThumb == 0 || _isHovered
                                  ? [shadows.medium]
                                  : [shadows.small],
                            ),
                          ),
                        ),

                        // End thumb
                        Positioned(
                          left: _endProgress * (constraints.maxWidth - _thumbSize),
                          child: AnimatedContainer(
                            duration: animation.fast,
                            width: _thumbSize,
                            height: _thumbSize,
                            decoration: BoxDecoration(
                              color: colors.background,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _activeColor,
                                width: 2,
                              ),
                              boxShadow: _activeThumb == 1 || _isHovered
                                  ? [shadows.medium]
                                  : [shadows.small],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  double get _trackHeight => widget.size.resolve(
        small: 4.0,
        medium: 6.0,
        large: 8.0,
      );

  double get _thumbSize => widget.size.resolve(
        small: 14.0,
        medium: 18.0,
        large: 22.0,
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
}
