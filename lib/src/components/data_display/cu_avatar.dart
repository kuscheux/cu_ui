import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Avatar size variants
enum CuAvatarSize {
  small,
  medium,
  large,
}

/// CU UI Avatar Component
/// Matches Geist UI Avatar - user profile image/initials
class CuAvatar extends StatefulWidget {
  /// Image source URL
  final String? src;

  /// Image provider (alternative to src)
  final ImageProvider? image;

  /// Fallback text (typically initials)
  final String? text;

  /// Size in pixels (used when size enum not specified)
  final double? customSize;

  /// Size variant
  final CuAvatarSize size;

  /// Square avatar (no border radius)
  final bool isSquare;

  /// Stacked (negative margin for grouping)
  final bool stacked;

  const CuAvatar({
    super.key,
    this.src,
    this.image,
    this.text,
    this.customSize,
    this.size = CuAvatarSize.medium,
    this.isSquare = false,
    this.stacked = false,
  });

  /// Create a small avatar
  factory CuAvatar.small({
    Key? key,
    String? src,
    ImageProvider? image,
    String? text,
    bool isSquare = false,
  }) {
    return CuAvatar(
      key: key,
      src: src,
      image: image,
      text: text,
      size: CuAvatarSize.small,
      isSquare: isSquare,
    );
  }

  /// Create a large avatar
  factory CuAvatar.large({
    Key? key,
    String? src,
    ImageProvider? image,
    String? text,
    bool isSquare = false,
  }) {
    return CuAvatar(
      key: key,
      src: src,
      image: image,
      text: text,
      size: CuAvatarSize.large,
      isSquare: isSquare,
    );
  }

  @override
  State<CuAvatar> createState() => _CuAvatarState();
}

class _CuAvatarState extends State<CuAvatar> with CuComponentMixin {
  String _safeText(String? text) {
    if (text == null || text.isEmpty) return '?';
    if (text.length <= 3) return text.toUpperCase();
    return text.substring(0, 2).toUpperCase();
  }

  double get _sizePixels {
    if (widget.customSize != null) return widget.customSize!;
    switch (widget.size) {
      case CuAvatarSize.small:
        return 28;
      case CuAvatarSize.medium:
        return 40;
      case CuAvatarSize.large:
        return 56;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = _sizePixels;
    final borderRadiusValue = widget.isSquare ? Radius.circular(radius.md) : Radius.circular(size / 2);
    final showText = widget.src == null && widget.image == null;

    Widget? imageWidget;
    if (widget.image != null) {
      imageWidget = Image(
        image: widget.image!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text(
              _safeText(widget.text),
              style: typography.body.copyWith(
                fontSize: size * 0.4,
                fontWeight: typography.weightMedium,
                color: colors.foreground,
              ),
            ),
          );
        },
      );
    } else if (widget.src != null) {
      imageWidget = Image.network(
        widget.src!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text(
              _safeText(widget.text),
              style: typography.body.copyWith(
                fontSize: size * 0.4,
                fontWeight: typography.weightMedium,
                color: colors.foreground,
              ),
            ),
          );
        },
      );
    }

    return Container(
      width: size,
      height: size,
      margin: widget.stacked ? EdgeInsets.only(left: -size * 0.25) : null,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.all(borderRadiusValue),
        border: Border.all(color: colors.accents2),
      ),
      clipBehavior: Clip.antiAlias,
      child: showText
          ? Center(
              child: Text(
                _safeText(widget.text),
                style: typography.body.copyWith(
                  fontSize: size * 0.4,
                  fontWeight: typography.weightMedium,
                  color: colors.foreground,
                ),
              ),
            )
          : imageWidget,
    );
  }
}

/// Avatar Group Component
class CuAvatarGroup extends StatefulWidget {
  /// List of avatars
  final List<CuAvatar> avatars;

  /// Maximum avatars to show
  final int? count;

  const CuAvatarGroup({
    super.key,
    required this.avatars,
    this.count,
  });

  @override
  State<CuAvatarGroup> createState() => _CuAvatarGroupState();
}

class _CuAvatarGroupState extends State<CuAvatarGroup> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    final count = widget.count ?? widget.avatars.length;
    final displayAvatars = widget.avatars.take(count).toList();
    final remaining = widget.avatars.length - count;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...displayAvatars.asMap().entries.map((entry) {
          final index = entry.key;
          final avatar = entry.value;

          return Container(
            margin: EdgeInsets.only(left: index == 0 ? 0 : -10),
            child: CuAvatar(
              src: avatar.src,
              text: avatar.text,
              size: avatar.size,
              isSquare: avatar.isSquare,
            ),
          );
        }),
        if (remaining > 0)
          Container(
            margin: const EdgeInsets.only(left: -10),
            child: CuAvatar(
              text: '+$remaining',
              size: displayAvatars.first.size,
            ),
          ),
      ],
    );
  }
}
