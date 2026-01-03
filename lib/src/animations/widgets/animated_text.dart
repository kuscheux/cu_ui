import 'package:flutter/widgets.dart';
import '../core/easing_curves.dart';
import '../../tokens/animation_tokens.dart';

/// Letter-by-letter animated text reveal
class CuAnimatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration letterDuration;
  final Duration letterStagger;
  final double initialOffsetY;

  const CuAnimatedText({
    super.key,
    required this.text,
    this.style,
    this.letterDuration = CuAnimationModeConstants.textLetterDuration,
    this.letterStagger = CuAnimationModeConstants.textLetterStagger,
    this.initialOffsetY = CuAnimationModeConstants.textInitialOffsetY,
  });

  @override
  State<CuAnimatedText> createState() => _CuAnimatedTextState();
}

class _CuAnimatedTextState extends State<CuAnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _opacityAnimations;
  late List<Animation<Offset>> _offsetAnimations;
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    _currentText = widget.text;
    _setupAnimations();
  }

  @override
  void didUpdateWidget(CuAnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _currentText = widget.text;
      _controller.dispose();
      _setupAnimations();
    }
  }

  void _setupAnimations() {
    if (_currentText.isEmpty) {
      _controller = AnimationController(
        duration: Duration.zero,
        vsync: this,
      );
      _opacityAnimations = [];
      _offsetAnimations = [];
      return;
    }

    final totalDuration = widget.letterDuration +
        (widget.letterStagger * (_currentText.length - 1));

    _controller = AnimationController(
      duration: totalDuration,
      vsync: this,
    );

    _opacityAnimations = [];
    _offsetAnimations = [];

    for (int i = 0; i < _currentText.length; i++) {
      final startDelay = widget.letterStagger.inMilliseconds * i;
      final startPercent = startDelay / totalDuration.inMilliseconds;
      final endPercent = (startDelay + widget.letterDuration.inMilliseconds) /
          totalDuration.inMilliseconds;

      final curvedAnimation = CurvedAnimation(
        parent: _controller,
        curve: Interval(
          startPercent.clamp(0.0, 1.0),
          endPercent.clamp(0.0, 1.0),
          curve: CuEasingCurves.textReveal,
        ),
      );

      _opacityAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
      );

      _offsetAnimations.add(
        Tween<Offset>(
          begin: Offset(0, widget.initialOffsetY),
          end: Offset.zero,
        ).animate(curvedAnimation),
      );
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentText.isEmpty) {
      return const SizedBox.shrink();
    }

    final TextStyle style = widget.style ??
        const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.64,
          color: Color(0xFFFFFFFF),
        );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_currentText.length, (index) {
            final char = _currentText[index];
            final opacity = _opacityAnimations[index].value;
            final offset = _offsetAnimations[index].value;

            return Transform.translate(
              offset: offset,
              child: Opacity(
                opacity: opacity,
                child: RichText(
                  text: TextSpan(
                    text: char,
                    style: style,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Animated text that can change and re-animate
class CuAnimatedModeLabel extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const CuAnimatedModeLabel({
    super.key,
    required this.text,
    this.style,
  });

  @override
  State<CuAnimatedModeLabel> createState() => _CuAnimatedModeLabelState();
}

class _CuAnimatedModeLabelState extends State<CuAnimatedModeLabel> {
  Key _key = UniqueKey();

  @override
  void didUpdateWidget(CuAnimatedModeLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      // Force rebuild with new key to restart animation
      _key = UniqueKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CuAnimatedText(
      key: _key,
      text: widget.text,
      style: widget.style,
    );
  }
}
