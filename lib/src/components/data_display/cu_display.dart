import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Display Component
/// Matches Geist UI Display - hero section with caption
class CuDisplay extends StatefulWidget {
  /// Main content
  final Widget child;

  /// Caption text
  final String? caption;

  /// Shadow effect
  final bool shadow;

  /// Width constraint
  final double? width;

  const CuDisplay({
    super.key,
    required this.child,
    this.caption,
    this.shadow = false,
    this.width,
  });

  @override
  State<CuDisplay> createState() => _CuDisplayState();
}

class _CuDisplayState extends State<CuDisplay> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      margin: EdgeInsets.symmetric(vertical: spacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: radius.mdBorder,
              boxShadow: widget.shadow ? shadows.largeList : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: widget.child,
          ),
          if (widget.caption != null) ...[
            SizedBox(height: spacing.space3),
            Text(
              widget.caption!,
              style: typography.bodySmall.copyWith(color: colors.accents5),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
