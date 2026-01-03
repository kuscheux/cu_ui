import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';
import '../feedback/cu_spinner.dart';

/// CU UI Image Component
/// Matches Geist UI Image - enhanced image display
class CuImage extends StatefulWidget {
  /// Image source URL
  final String src;

  /// Alt text
  final String? alt;

  /// Image width
  final double? width;

  /// Image height
  final double? height;

  /// Show skeleton while loading
  final bool skeleton;

  /// Caption text
  final String? caption;

  /// Show browser frame
  final bool browser;

  /// Browser URL for frame
  final String? url;

  const CuImage({
    super.key,
    required this.src,
    this.alt,
    this.width,
    this.height,
    this.skeleton = true,
    this.caption,
    this.browser = false,
    this.url,
  });

  /// Create an image with browser frame
  factory CuImage.browser({
    Key? key,
    required String src,
    String? url,
    String? alt,
    double? width,
    double? height,
  }) {
    return CuImage(
      key: key,
      src: src,
      url: url ?? src,
      alt: alt,
      width: width,
      height: height,
      browser: true,
    );
  }

  @override
  State<CuImage> createState() => _CuImageState();
}

class _CuImageState extends State<CuImage> with CuComponentMixin {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    Widget image = Image.network(
      widget.src,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          if (_isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _isLoading = false);
            });
          }
          return child;
        }
        return _buildSkeleton();
      },
      errorBuilder: (context, error, stackTrace) {
        if (!_hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _hasError = true);
          });
        }
        return _buildError();
      },
    );

    if (widget.browser) {
      image = _buildBrowserFrame(image);
    }

    if (widget.caption != null) {
      image = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          image,
          SizedBox(height: spacing.space2),
          Text(
            widget.caption!,
            style: typography.bodySmall.copyWith(color: colors.accents5),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return image;
  }

  Widget _buildSkeleton() {
    if (!widget.skeleton) return const SizedBox.shrink();

    return Container(
      width: widget.width ?? 200,
      height: widget.height ?? 150,
      decoration: BoxDecoration(
        color: colors.accents2,
        borderRadius: radius.mdBorder,
      ),
      child: Center(
        child: CuSpinner(size: 24, color: colors.accents4),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      width: widget.width ?? 200,
      height: widget.height ?? 150,
      decoration: BoxDecoration(
        color: colors.accents1,
        borderRadius: radius.mdBorder,
        border: Border.all(color: colors.border),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('✕', style: TextStyle(fontSize: 24, color: colors.accents4)),
            SizedBox(height: spacing.space2),
            Text(
              'Failed to load',
              style: typography.bodySmall.copyWith(color: colors.accents5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowserFrame(Widget image) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: radius.mdBorder,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Browser header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.space3,
              vertical: spacing.space2,
            ),
            decoration: BoxDecoration(
              color: colors.accents1,
              border: Border(bottom: BorderSide(color: colors.border)),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius.md),
                topRight: Radius.circular(radius.md),
              ),
            ),
            child: Row(
              children: [
                // Traffic lights
                Row(
                  children: [
                    _buildDot(colors.error.base),
                    SizedBox(width: spacing.space1),
                    _buildDot(colors.warning.base),
                    SizedBox(width: spacing.space1),
                    _buildDot(colors.success.base),
                  ],
                ),
                SizedBox(width: spacing.space3),
                // URL bar
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.space3,
                      vertical: spacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: radius.smBorder,
                      border: Border.all(color: colors.border),
                    ),
                    child: Text(
                      widget.url ?? widget.src,
                      style: typography.bodySmall.copyWith(
                        color: colors.accents5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Image content
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(radius.md),
              bottomRight: Radius.circular(radius.md),
            ),
            child: image,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
