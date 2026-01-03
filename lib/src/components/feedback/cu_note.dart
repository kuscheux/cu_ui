import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Note type variants
enum CuNoteType {
  default_,
  secondary,
  success,
  warning,
  error,
}

/// CU UI Note Component
/// Matches Geist UI Note - highlighted message box
class CuNote extends StatefulWidget {
  /// Note content
  final Widget? child;

  /// Simple text content
  final String? text;

  /// Note type
  final CuNoteType type;

  /// Custom label (replaces type label)
  final String? label;

  /// Small variant
  final bool small;

  /// Filled background
  final bool filled;

  const CuNote({
    super.key,
    this.child,
    this.text,
    this.type = CuNoteType.default_,
    this.label,
    this.small = false,
    this.filled = false,
  });

  /// Create a success note
  factory CuNote.success(String text, {String? label, bool filled = false}) {
    return CuNote(text: text, type: CuNoteType.success, label: label, filled: filled);
  }

  /// Create a warning note
  factory CuNote.warning(String text, {String? label, bool filled = false}) {
    return CuNote(text: text, type: CuNoteType.warning, label: label, filled: filled);
  }

  /// Create an error note
  factory CuNote.error(String text, {String? label, bool filled = false}) {
    return CuNote(text: text, type: CuNoteType.error, label: label, filled: filled);
  }

  @override
  State<CuNote> createState() => _CuNoteState();
}

class _CuNoteState extends State<CuNote> with CuComponentMixin {
  Color get _color {
    switch (widget.type) {
      case CuNoteType.default_:
        return colors.foreground;
      case CuNoteType.secondary:
        return colors.secondary;
      case CuNoteType.success:
        return colors.success.base;
      case CuNoteType.warning:
        return colors.warning.base;
      case CuNoteType.error:
        return colors.error.base;
    }
  }

  Color get _bgColor {
    if (!widget.filled) return colors.background;

    switch (widget.type) {
      case CuNoteType.default_:
        return colors.accents1;
      case CuNoteType.secondary:
        return colors.secondary.withValues(alpha: 0.1);
      case CuNoteType.success:
        return colors.success.lighter;
      case CuNoteType.warning:
        return colors.warning.lighter;
      case CuNoteType.error:
        return colors.error.lighter;
    }
  }

  String get _defaultLabel {
    switch (widget.type) {
      case CuNoteType.default_:
        return 'Note';
      case CuNoteType.secondary:
        return 'Note';
      case CuNoteType.success:
        return 'Success';
      case CuNoteType.warning:
        return 'Warning';
      case CuNoteType.error:
        return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label ?? _defaultLabel;

    return Container(
      padding: EdgeInsets.all(widget.small ? spacing.space3 : spacing.space4),
      decoration: BoxDecoration(
        color: _bgColor,
        border: Border.all(color: _color),
        borderRadius: radius.mdBorder,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: (widget.small ? typography.bodySmall : typography.body).copyWith(
              color: _color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: DefaultTextStyle(
              style: (widget.small ? typography.bodySmall : typography.body).copyWith(
                color: colors.foreground,
              ),
              child: widget.child ?? Text(widget.text ?? ''),
            ),
          ),
        ],
      ),
    );
  }
}
