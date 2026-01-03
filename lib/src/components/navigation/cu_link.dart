import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Link Component
/// Matches Geist UI Link - styled hyperlink
class CuLink extends StatefulWidget {
  /// Link text or child widget
  final Widget child;

  /// Tap callback
  final VoidCallback? onTap;

  /// URL href (for external links)
  final String? href;

  /// Show underline
  final bool underline;

  /// Color variant
  final Color? color;

  /// Show icon for external links
  final bool icon;

  /// Block display (full width)
  final bool block;

  const CuLink({
    super.key,
    required this.child,
    this.onTap,
    this.href,
    this.underline = true,
    this.color,
    this.icon = false,
    this.block = false,
  });

  /// Create a link with text
  factory CuLink.text(
    String text, {
    Key? key,
    VoidCallback? onTap,
    String? href,
    bool underline = true,
    Color? color,
    bool icon = false,
    bool block = false,
  }) {
    return CuLink(
      key: key,
      onTap: onTap,
      href: href,
      underline: underline,
      color: color,
      icon: icon,
      block: block,
      child: Text(text),
    );
  }

  @override
  State<CuLink> createState() => _CuLinkState();
}

class _CuLinkState extends State<CuLink> with CuComponentMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final linkColor = widget.color ?? colors.link;

    Widget content = DefaultTextStyle.merge(
      style: TextStyle(
        color: linkColor,
        decoration: widget.underline
            ? _isHovered
                ? TextDecoration.none
                : TextDecoration.underline
            : _isHovered
                ? TextDecoration.underline
                : TextDecoration.none,
        decorationColor: linkColor,
      ),
      child: widget.child,
    );

    if (widget.icon) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          SizedBox(width: spacing.space1),
          Icon(
            Icons.open_in_new,
            size: 14,
            color: linkColor,
          ),
        ],
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: widget.block
            ? SizedBox(
                width: double.infinity,
                child: content,
              )
            : content,
      ),
    );
  }
}
