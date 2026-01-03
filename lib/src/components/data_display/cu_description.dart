import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Description Component
/// Matches Geist UI Description - label + content pair
class CuDescription extends StatefulWidget {
  /// Label/title text
  final String title;

  /// Content/value widget
  final Widget? content;

  /// Content/value as string
  final String? text;

  const CuDescription({
    super.key,
    required this.title,
    this.content,
    this.text,
  });

  /// Create a description with text content
  factory CuDescription.text({
    Key? key,
    required String title,
    required String content,
  }) {
    return CuDescription(
      key: key,
      title: title,
      text: content,
    );
  }

  @override
  State<CuDescription> createState() => _CuDescriptionState();
}

class _CuDescriptionState extends State<CuDescription> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.title,
          style: typography.bodySmall.copyWith(
            color: colors.accents5,
            fontWeight: typography.weightMedium,
          ),
        ),
        SizedBox(height: spacing.space1),
        widget.content ??
            Text(
              widget.text ?? '',
              style: typography.body,
            ),
      ],
    );
  }
}
