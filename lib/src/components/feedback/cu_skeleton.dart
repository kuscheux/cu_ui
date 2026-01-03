import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';
import 'cu_shimmer.dart';

/// CuSkeleton - Skeleton placeholder for loading states
///
/// Provides various skeleton shapes for different content types.
/// Automatically includes shimmer animation.
///
/// ## Example
/// ```dart
/// // Text skeleton
/// CuSkeleton.text(width: 200)
///
/// // Avatar skeleton
/// CuSkeleton.avatar(size: 48)
///
/// // Card skeleton
/// CuSkeleton.card(height: 120)
/// ```
class CuSkeleton extends StatefulWidget {
  /// Width of skeleton (null for full width)
  final double? width;

  /// Height of skeleton
  final double height;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Whether to show shimmer animation
  final bool animated;

  /// Base color
  final Color? baseColor;

  /// Highlight color
  final Color? highlightColor;

  /// Shape of skeleton
  final BoxShape shape;

  const CuSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.animated = true,
    this.baseColor,
    this.highlightColor,
    this.shape = BoxShape.rectangle,
  });

  /// Text line skeleton
  factory CuSkeleton.text({
    Key? key,
    double? width,
    double height = 14,
    bool animated = true,
  }) {
    return CuSkeleton(
      key: key,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4),
      animated: animated,
    );
  }

  /// Heading/title skeleton
  factory CuSkeleton.heading({
    Key? key,
    double? width,
    double height = 24,
    bool animated = true,
  }) {
    return CuSkeleton(
      key: key,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(6),
      animated: animated,
    );
  }

  /// Paragraph skeleton (multiple lines)
  static Widget paragraph({
    Key? key,
    int lines = 3,
    double spacing = 8,
    double? lastLineWidth,
    bool animated = true,
  }) {
    return _SkeletonParagraph(
      key: key,
      lines: lines,
      spacing: spacing,
      lastLineWidth: lastLineWidth,
      animated: animated,
    );
  }

  /// Circle/avatar skeleton
  factory CuSkeleton.avatar({
    Key? key,
    double size = 40,
    bool animated = true,
  }) {
    return CuSkeleton(
      key: key,
      width: size,
      height: size,
      shape: BoxShape.circle,
      animated: animated,
    );
  }

  /// Square thumbnail skeleton
  factory CuSkeleton.thumbnail({
    Key? key,
    double size = 64,
    double radius = 8,
    bool animated = true,
  }) {
    return CuSkeleton(
      key: key,
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(radius),
      animated: animated,
    );
  }

  /// Button skeleton
  factory CuSkeleton.button({
    Key? key,
    double? width = 100,
    double height = 40,
    bool animated = true,
  }) {
    return CuSkeleton(
      key: key,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(6),
      animated: animated,
    );
  }

  /// Card skeleton
  factory CuSkeleton.card({
    Key? key,
    double? width,
    double height = 120,
    double radius = 12,
    bool animated = true,
  }) {
    return CuSkeleton(
      key: key,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(radius),
      animated: animated,
    );
  }

  /// Input field skeleton
  factory CuSkeleton.input({
    Key? key,
    double? width,
    double height = 44,
    bool animated = true,
  }) {
    return CuSkeleton(
      key: key,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(6),
      animated: animated,
    );
  }

  /// Custom rectangle skeleton
  factory CuSkeleton.rect({
    Key? key,
    required double width,
    required double height,
    double radius = 4,
    bool animated = true,
  }) {
    return CuSkeleton(
      key: key,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(radius),
      animated: animated,
    );
  }

  @override
  State<CuSkeleton> createState() => _CuSkeletonState();
}

class _CuSkeletonState extends State<CuSkeleton> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    final isDark = colors.background.computeLuminance() < 0.5;
    final baseColor = widget.baseColor ??
        (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8E8E8));
    final highlightColor = widget.highlightColor ??
        (isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5));

    final skeleton = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: widget.shape == BoxShape.circle
            ? null
            : widget.borderRadius ?? radius.smBorder,
        shape: widget.shape,
      ),
    );

    if (!widget.animated) {
      return skeleton;
    }

    return CuShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: skeleton,
    );
  }
}

/// Paragraph skeleton with multiple lines
class _SkeletonParagraph extends StatefulWidget {
  final int lines;
  final double spacing;
  final double? lastLineWidth;
  final bool animated;

  const _SkeletonParagraph({
    super.key,
    required this.lines,
    required this.spacing,
    this.lastLineWidth,
    required this.animated,
  });

  @override
  State<_SkeletonParagraph> createState() => _SkeletonParagraphState();
}

class _SkeletonParagraphState extends State<_SkeletonParagraph> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    final isDark = colors.background.computeLuminance() < 0.5;
    final baseColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8E8E8);
    final highlightColor = isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.lines, (index) {
        final isLast = index == widget.lines - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : widget.spacing),
          child: Container(
            width: isLast && widget.lastLineWidth != null
                ? widget.lastLineWidth
                : null,
            height: 14,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );

    if (!widget.animated) {
      return content;
    }

    return CuShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: content,
    );
  }
}

/// Pre-built skeleton layouts for common UI patterns
class CuSkeletonLayout extends StatefulWidget {
  /// Type of layout
  final SkeletonLayoutType type;

  /// Whether to show shimmer animation
  final bool animated;

  const CuSkeletonLayout({
    super.key,
    required this.type,
    this.animated = true,
  });

  /// User list item skeleton
  factory CuSkeletonLayout.listItem({Key? key, bool animated = true}) {
    return CuSkeletonLayout(key: key, type: SkeletonLayoutType.listItem, animated: animated);
  }

  /// Card with content skeleton
  factory CuSkeletonLayout.card({Key? key, bool animated = true}) {
    return CuSkeletonLayout(key: key, type: SkeletonLayoutType.card, animated: animated);
  }

  /// Article/post skeleton
  factory CuSkeletonLayout.article({Key? key, bool animated = true}) {
    return CuSkeletonLayout(key: key, type: SkeletonLayoutType.article, animated: animated);
  }

  /// Profile header skeleton
  factory CuSkeletonLayout.profile({Key? key, bool animated = true}) {
    return CuSkeletonLayout(key: key, type: SkeletonLayoutType.profile, animated: animated);
  }

  /// Transaction item skeleton
  factory CuSkeletonLayout.transaction({Key? key, bool animated = true}) {
    return CuSkeletonLayout(key: key, type: SkeletonLayoutType.transaction, animated: animated);
  }

  @override
  State<CuSkeletonLayout> createState() => _CuSkeletonLayoutState();
}

class _CuSkeletonLayoutState extends State<CuSkeletonLayout> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case SkeletonLayoutType.listItem:
        return _buildListItem();
      case SkeletonLayoutType.card:
        return _buildCard();
      case SkeletonLayoutType.article:
        return _buildArticle();
      case SkeletonLayoutType.profile:
        return _buildProfile();
      case SkeletonLayoutType.transaction:
        return _buildTransaction();
    }
  }

  Widget _buildListItem() {
    return Row(
      children: [
        CuSkeleton.avatar(size: 44, animated: widget.animated),
        SizedBox(width: spacing.space3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CuSkeleton.text(width: 120, animated: widget.animated),
              SizedBox(height: spacing.space2),
              CuSkeleton.text(height: 12, animated: widget.animated),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      padding: EdgeInsets.all(spacing.space4),
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: radius.lgBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CuSkeleton.heading(width: 180, animated: widget.animated),
          SizedBox(height: spacing.space3),
          CuSkeleton.paragraph(lines: 3, lastLineWidth: 200, animated: widget.animated),
          SizedBox(height: spacing.space4),
          Row(
            children: [
              CuSkeleton.button(width: 80, height: 32, animated: widget.animated),
              SizedBox(width: spacing.space2),
              CuSkeleton.button(width: 80, height: 32, animated: widget.animated),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CuSkeleton.card(height: 180, animated: widget.animated),
        SizedBox(height: spacing.space4),
        CuSkeleton.heading(animated: widget.animated),
        SizedBox(height: spacing.space3),
        CuSkeleton.paragraph(lines: 4, lastLineWidth: 250, animated: widget.animated),
      ],
    );
  }

  Widget _buildProfile() {
    return Column(
      children: [
        CuSkeleton.avatar(size: 80, animated: widget.animated),
        SizedBox(height: spacing.space3),
        CuSkeleton.heading(width: 150, animated: widget.animated),
        SizedBox(height: spacing.space2),
        CuSkeleton.text(width: 200, height: 12, animated: widget.animated),
      ],
    );
  }

  Widget _buildTransaction() {
    return Row(
      children: [
        CuSkeleton.rect(width: 44, height: 44, radius: 8, animated: widget.animated),
        SizedBox(width: spacing.space3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CuSkeleton.text(width: 140, animated: widget.animated),
              SizedBox(height: spacing.space1),
              CuSkeleton.text(width: 80, height: 12, animated: widget.animated),
            ],
          ),
        ),
        CuSkeleton.text(width: 70, animated: widget.animated),
      ],
    );
  }
}

/// Types of skeleton layouts
enum SkeletonLayoutType {
  listItem,
  card,
  article,
  profile,
  transaction,
}
