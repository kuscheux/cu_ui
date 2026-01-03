import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Fieldset type variants
enum CuFieldsetType {
  default_,
  secondary,
  success,
  warning,
  error,
}

/// CU UI Fieldset Component
/// Matches Geist UI Fieldset - grouped form fields with title and actions
class CuFieldset extends StatefulWidget {
  /// Fieldset content
  final Widget child;

  /// Title displayed at top
  final String? title;

  /// Subtitle displayed below title
  final String? subtitle;

  /// Footer content (typically buttons)
  final Widget? footer;

  /// Type variant
  final CuFieldsetType type;

  const CuFieldset({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.footer,
    this.type = CuFieldsetType.default_,
  });

  @override
  State<CuFieldset> createState() => _CuFieldsetState();
}

class _CuFieldsetState extends State<CuFieldset> with CuComponentMixin {
  Color get _borderColor {
    switch (widget.type) {
      case CuFieldsetType.default_:
        return colors.border;
      case CuFieldsetType.secondary:
        return colors.secondary;
      case CuFieldsetType.success:
        return colors.success.base;
      case CuFieldsetType.warning:
        return colors.warning.base;
      case CuFieldsetType.error:
        return colors.error.base;
    }
  }

  Color get _footerBgColor {
    switch (widget.type) {
      case CuFieldsetType.default_:
        return colors.accents1;
      case CuFieldsetType.secondary:
        return colors.secondary.withValues(alpha: 0.1);
      case CuFieldsetType.success:
        return colors.success.lighter;
      case CuFieldsetType.warning:
        return colors.warning.lighter;
      case CuFieldsetType.error:
        return colors.error.lighter;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _borderColor),
        borderRadius: radius.mdBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title section
          if (widget.title != null || widget.subtitle != null)
            Padding(
              padding: EdgeInsets.all(spacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title != null)
                    Text(
                      widget.title!,
                      style: typography.h4,
                    ),
                  if (widget.subtitle != null) ...[
                    SizedBox(height: spacing.space1),
                    Text(
                      widget.subtitle!,
                      style: typography.body.copyWith(color: colors.accents5),
                    ),
                  ],
                ],
              ),
            ),

          // Content
          Padding(
            padding: EdgeInsets.all(spacing.space4),
            child: widget.child,
          ),

          // Footer
          if (widget.footer != null)
            Container(
              padding: EdgeInsets.all(spacing.space4),
              decoration: BoxDecoration(
                color: _footerBgColor,
                border: Border(top: BorderSide(color: _borderColor)),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(radius.md),
                  bottomRight: Radius.circular(radius.md),
                ),
              ),
              child: widget.footer,
            ),
        ],
      ),
    );
  }
}

/// Fieldset Title Component
class CuFieldsetTitle extends StatefulWidget {
  final String text;

  const CuFieldsetTitle(this.text, {super.key});

  @override
  State<CuFieldsetTitle> createState() => _CuFieldsetTitleState();
}

class _CuFieldsetTitleState extends State<CuFieldsetTitle> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return Text(widget.text, style: typography.h4);
  }
}

/// Fieldset Subtitle Component
class CuFieldsetSubtitle extends StatefulWidget {
  final String text;

  const CuFieldsetSubtitle(this.text, {super.key});

  @override
  State<CuFieldsetSubtitle> createState() => _CuFieldsetSubtitleState();
}

class _CuFieldsetSubtitleState extends State<CuFieldsetSubtitle> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: typography.body.copyWith(color: colors.accents5),
    );
  }
}

/// Fieldset Footer Component
class CuFieldsetFooter extends StatefulWidget {
  final Widget child;
  final CuFieldsetType type;

  const CuFieldsetFooter({
    super.key,
    required this.child,
    this.type = CuFieldsetType.default_,
  });

  @override
  State<CuFieldsetFooter> createState() => _CuFieldsetFooterState();
}

class _CuFieldsetFooterState extends State<CuFieldsetFooter> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Fieldset Group - groups multiple fieldsets together
class CuFieldsetGroup extends StatefulWidget {
  final List<Widget> children;
  final double gap;

  const CuFieldsetGroup({
    super.key,
    required this.children,
    this.gap = 0,
  });

  @override
  State<CuFieldsetGroup> createState() => _CuFieldsetGroupState();
}

class _CuFieldsetGroupState extends State<CuFieldsetGroup> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    if (widget.gap == 0) {
      // Stacked style - no gap, shared borders
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: widget.children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          final isFirst = index == 0;
          final isLast = index == widget.children.length - 1;

          return Container(
            margin: EdgeInsets.only(top: isFirst ? 0 : -1),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: isFirst ? Radius.circular(radius.md) : Radius.zero,
                topRight: isFirst ? Radius.circular(radius.md) : Radius.zero,
                bottomLeft: isLast ? Radius.circular(radius.md) : Radius.zero,
                bottomRight: isLast ? Radius.circular(radius.md) : Radius.zero,
              ),
              child: child,
            ),
          );
        }).toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: widget.children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        final isLast = index == widget.children.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : widget.gap * spacing.unit),
          child: child,
        );
      }).toList(),
    );
  }
}
