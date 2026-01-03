import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Code Component
/// Matches Geist UI Code - inline code display
class CuCode extends StatefulWidget {
  /// Code text
  final String text;

  /// Block display (vs inline)
  final bool block;

  /// Show copy button
  final bool copy;

  const CuCode({
    super.key,
    required this.text,
    this.block = false,
    this.copy = false,
  });

  @override
  State<CuCode> createState() => _CuCodeState();
}

class _CuCodeState extends State<CuCode> with CuComponentMixin {
  bool _copied = false;

  void _copyToClipboard() async {
    // In a real app, use Clipboard.setData
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _copied = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.block) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(spacing.space4),
        decoration: BoxDecoration(
          color: colors.code,
          borderRadius: radius.mdBorder,
          border: Border.all(color: colors.border),
        ),
        child: Stack(
          children: [
            Text(
              widget.text,
              style: typography.code,
            ),
            if (widget.copy)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _copyToClipboard,
                  child: Container(
                    padding: EdgeInsets.all(spacing.space2),
                    child: Text(
                      _copied ? '\u{2713}' : '\u{2398}',
                      style: TextStyle(
                        fontSize: 14,
                        color: _copied ? colors.success.base : colors.accents5,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: colors.code,
        borderRadius: radius.smBorder,
      ),
      child: Text(
        widget.text,
        style: typography.codeSmall,
      ),
    );
  }
}

/// CU UI Snippet Component
/// Matches Geist UI Snippet - code snippet with copy functionality
class CuSnippet extends StatefulWidget {
  /// Snippet text
  final String text;

  /// Symbol prefix
  final String symbol;

  /// Type variant
  final CuSnippetType type;

  /// Width
  final double? width;

  /// Show copy button
  final bool copy;

  const CuSnippet({
    super.key,
    required this.text,
    this.symbol = '\$',
    this.type = CuSnippetType.default_,
    this.width,
    this.copy = true,
  });

  @override
  State<CuSnippet> createState() => _CuSnippetState();
}

enum CuSnippetType {
  default_,
  secondary,
  success,
  warning,
  error,
  dark,
  lite,
}

class _CuSnippetState extends State<CuSnippet> with CuComponentMixin {
  bool _copied = false;

  void _copyToClipboard() async {
    // In a real app, use Clipboard.setData
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _copied = false);
    }
  }

  Color get _borderColor {
    switch (widget.type) {
      case CuSnippetType.default_:
        return colors.border;
      case CuSnippetType.secondary:
        return colors.secondary;
      case CuSnippetType.success:
        return colors.success.base;
      case CuSnippetType.warning:
        return colors.warning.base;
      case CuSnippetType.error:
        return colors.error.base;
      case CuSnippetType.dark:
        return colors.foreground;
      case CuSnippetType.lite:
        return colors.accents2;
    }
  }

  Color get _bgColor {
    switch (widget.type) {
      case CuSnippetType.dark:
        return colors.foreground;
      default:
        return colors.background;
    }
  }

  Color get _textColor {
    switch (widget.type) {
      case CuSnippetType.dark:
        return colors.background;
      default:
        return colors.foreground;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.space4,
        vertical: spacing.space3,
      ),
      decoration: BoxDecoration(
        color: _bgColor,
        border: Border.all(color: _borderColor),
        borderRadius: radius.mdBorder,
      ),
      child: Row(
        mainAxisSize: widget.width == null ? MainAxisSize.min : MainAxisSize.max,
        children: [
          Text(
            widget.symbol,
            style: typography.code.copyWith(color: colors.accents4),
          ),
          SizedBox(width: spacing.space2),
          Expanded(
            child: Text(
              widget.text,
              style: typography.code.copyWith(color: _textColor),
            ),
          ),
          if (widget.copy) ...[
            SizedBox(width: spacing.space2),
            GestureDetector(
              onTap: _copyToClipboard,
              child: Text(
                _copied ? '\u{2713}' : '\u{2398}',
                style: TextStyle(
                  fontSize: 14,
                  color: _copied ? colors.success.base : colors.accents5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// CU UI Keyboard Component
/// Matches Geist UI Keyboard - keyboard shortcut display
class CuKeyboard extends StatefulWidget {
  /// Key text
  final String text;

  /// Command key
  final bool command;

  /// Shift key
  final bool shift;

  /// Option/Alt key
  final bool option;

  /// Control key
  final bool ctrl;

  /// Size variant
  final CuSize size;

  const CuKeyboard({
    super.key,
    required this.text,
    this.command = false,
    this.shift = false,
    this.option = false,
    this.ctrl = false,
    this.size = CuSize.medium,
  });

  @override
  State<CuKeyboard> createState() => _CuKeyboardState();
}

class _CuKeyboardState extends State<CuKeyboard> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    final keys = <String>[];

    if (widget.ctrl) keys.add('⌃');
    if (widget.option) keys.add('⌥');
    if (widget.shift) keys.add('⇧');
    if (widget.command) keys.add('⌘');
    keys.add(widget.text.toUpperCase());

    final padding = widget.size.resolve(
      small: EdgeInsets.symmetric(horizontal: spacing.space2, vertical: 2),
      medium: EdgeInsets.symmetric(horizontal: spacing.space3, vertical: spacing.space1),
      large: EdgeInsets.symmetric(horizontal: spacing.space4, vertical: spacing.space2),
    );

    final textStyle = widget.size.resolve(
      small: typography.caption,
      medium: typography.bodySmall,
      large: typography.body,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: keys.map((key) {
        return Container(
          margin: EdgeInsets.only(right: spacing.space1),
          padding: padding,
          decoration: BoxDecoration(
            color: colors.accents1,
            border: Border.all(color: colors.border),
            borderRadius: radius.smBorder,
          ),
          child: Text(
            key,
            style: textStyle.copyWith(
              color: colors.foreground,
              fontFamily: typography.fontMono,
            ),
          ),
        );
      }).toList(),
    );
  }
}
