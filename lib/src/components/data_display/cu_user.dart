import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';
import 'cu_avatar.dart';

/// CU UI User Component
/// Matches Geist UI User - user profile display
class CuUser extends StatefulWidget {
  /// User name
  final String name;

  /// User description/email
  final String? description;

  /// Avatar source URL
  final String? src;

  /// Fallback avatar text
  final String? text;

  /// Alt text for image
  final String? altText;

  const CuUser({
    super.key,
    required this.name,
    this.description,
    this.src,
    this.text,
    this.altText,
  });

  @override
  State<CuUser> createState() => _CuUserState();
}

class _CuUserState extends State<CuUser> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CuAvatar(
          src: widget.src,
          text: widget.text ?? widget.name,
          customSize: 32,
        ),
        SizedBox(width: spacing.space3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.name,
              style: typography.body.copyWith(fontWeight: typography.weightMedium),
            ),
            if (widget.description != null)
              Text(
                widget.description!,
                style: typography.bodySmall.copyWith(color: colors.accents5),
              ),
          ],
        ),
      ],
    );
  }
}
