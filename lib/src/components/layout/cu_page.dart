import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Page Component
/// Matches Geist UI Page - page container with header/content/footer
class CuPage extends StatefulWidget {
  /// Page content
  final Widget child;

  /// Optional header
  final Widget? header;

  /// Optional footer
  final Widget? footer;

  /// Render as full page (takes full viewport)
  final bool render;

  /// Dot style background
  final bool dotBackdrop;

  /// Dot spacing
  final double dotSpace;

  /// Dot size
  final double dotSize;

  const CuPage({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.render = false,
    this.dotBackdrop = false,
    this.dotSpace = 1,
    this.dotSize = 1,
  });

  @override
  State<CuPage> createState() => _CuPageState();
}

class _CuPageState extends State<CuPage> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: spacing.pageWidth,
      constraints: BoxConstraints(maxWidth: spacing.pageWidthWithMargin),
      padding: EdgeInsets.symmetric(horizontal: spacing.pageHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.header != null) widget.header!,
          Expanded(child: widget.child),
          if (widget.footer != null) widget.footer!,
        ],
      ),
    );

    if (widget.dotBackdrop) {
      content = Stack(
        children: [
          _DotBackdrop(
            dotSpace: widget.dotSpace,
            dotSize: widget.dotSize,
            color: colors.accents2,
          ),
          content,
        ],
      );
    }

    if (widget.render) {
      return Container(
        color: colors.background,
        child: Center(child: content),
      );
    }

    return Center(child: content);
  }
}

/// Page Header Component
class CuPageHeader extends StatefulWidget {
  final Widget child;
  final bool center;

  const CuPageHeader({
    super.key,
    required this.child,
    this.center = false,
  });

  @override
  State<CuPageHeader> createState() => _CuPageHeaderState();
}

class _CuPageHeaderState extends State<CuPageHeader> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: spacing.space4),
      alignment: widget.center ? Alignment.center : Alignment.centerLeft,
      child: widget.child,
    );
  }
}

/// Page Content Component
class CuPageContent extends StatelessWidget {
  final Widget child;

  const CuPageContent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Page Footer Component
class CuPageFooter extends StatefulWidget {
  final Widget child;
  final bool center;

  const CuPageFooter({
    super.key,
    required this.child,
    this.center = false,
  });

  @override
  State<CuPageFooter> createState() => _CuPageFooterState();
}

class _CuPageFooterState extends State<CuPageFooter> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: spacing.space4),
      alignment: widget.center ? Alignment.center : Alignment.centerLeft,
      child: widget.child,
    );
  }
}

/// Dot backdrop pattern
class _DotBackdrop extends StatelessWidget {
  final double dotSpace;
  final double dotSize;
  final Color color;

  const _DotBackdrop({
    required this.dotSpace,
    required this.dotSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _DotPainter(
          spacing: dotSpace * 24,
          size: dotSize,
          color: color,
        ),
      ),
    );
  }
}

class _DotPainter extends CustomPainter {
  final double spacing;
  final double size;
  final Color color;

  _DotPainter({
    required this.spacing,
    required this.size,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (double x = 0; x < canvasSize.width; x += spacing) {
      for (double y = 0; y < canvasSize.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), size, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
