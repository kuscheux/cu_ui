import 'package:flutter/widgets.dart';
import '../theme/cu_theme.dart';
import '../components/_base/cu_component.dart';
import '../components/typography/cu_shimmer_text.dart';
import '../components/feedback/cu_skeleton.dart';

/// CuLoadingScreen - Pre-built loading/splash screen
///
/// A complete loading screen with:
/// - Logo/branding area with optional animation
/// - Loading message with shimmer effect
/// - Optional skeleton preview of content
/// - Customizable background and colors
///
/// ## Example
/// ```dart
/// CuLoadingScreen(
///   logo: Image.asset('assets/logo.png'),
///   message: 'Loading your account...',
///   showSkeleton: true,
/// )
/// ```
class CuLoadingScreen extends StatefulWidget {
  /// Logo widget to display
  final Widget? logo;

  /// Loading message text
  final String? message;

  /// Secondary message/subtitle
  final String? subtitle;

  /// Whether to show shimmer on message text
  final bool shimmerMessage;

  /// Whether to show skeleton content preview
  final bool showSkeleton;

  /// Type of skeleton preview
  final LoadingSkeletonType skeletonType;

  /// Background color (defaults to theme background)
  final Color? backgroundColor;

  /// Custom loading indicator (replaces default)
  final Widget? loadingIndicator;

  /// Custom content to show below message
  final Widget? customContent;

  /// Padding around content
  final EdgeInsets? padding;

  const CuLoadingScreen({
    super.key,
    this.logo,
    this.message,
    this.subtitle,
    this.shimmerMessage = true,
    this.showSkeleton = false,
    this.skeletonType = LoadingSkeletonType.dashboard,
    this.backgroundColor,
    this.loadingIndicator,
    this.customContent,
    this.padding,
  });

  /// Create a minimal loading screen with just a logo
  factory CuLoadingScreen.minimal({
    Key? key,
    required Widget logo,
    Color? backgroundColor,
  }) {
    return CuLoadingScreen(
      key: key,
      logo: logo,
      backgroundColor: backgroundColor,
    );
  }

  /// Create a loading screen with skeleton preview
  factory CuLoadingScreen.withSkeleton({
    Key? key,
    Widget? logo,
    String? message,
    LoadingSkeletonType type = LoadingSkeletonType.dashboard,
    Color? backgroundColor,
  }) {
    return CuLoadingScreen(
      key: key,
      logo: logo,
      message: message,
      showSkeleton: true,
      skeletonType: type,
      backgroundColor: backgroundColor,
    );
  }

  @override
  State<CuLoadingScreen> createState() => _CuLoadingScreenState();
}

class _CuLoadingScreenState extends State<CuLoadingScreen>
    with CuComponentMixin, SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor ?? colors.background,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Padding(
            padding: widget.padding ?? EdgeInsets.all(spacing.space6),
            child: Column(
              children: [
                // Top section with logo and message
                Expanded(
                  flex: widget.showSkeleton ? 1 : 2,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        if (widget.logo != null) ...[
                          widget.logo!,
                          SizedBox(height: spacing.space6),
                        ],

                        // Loading indicator
                        if (widget.loadingIndicator != null)
                          widget.loadingIndicator!
                        else if (!widget.showSkeleton)
                          _buildDefaultIndicator(),

                        // Message
                        if (widget.message != null) ...[
                          SizedBox(height: spacing.space4),
                          if (widget.shimmerMessage)
                            CuShimmerText(
                              widget.message!,
                              style: typography.body.copyWith(
                                color: colors.accents5,
                              ),
                              shimmerColor: colors.accents5,
                              highlightColor: colors.foreground,
                            )
                          else
                            Text(
                              widget.message!,
                              style: typography.body.copyWith(
                                color: colors.accents5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],

                        // Subtitle
                        if (widget.subtitle != null) ...[
                          SizedBox(height: spacing.space2),
                          Text(
                            widget.subtitle!,
                            style: typography.caption.copyWith(
                              color: colors.accents4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],

                        // Custom content
                        if (widget.customContent != null) ...[
                          SizedBox(height: spacing.space4),
                          widget.customContent!,
                        ],
                      ],
                    ),
                  ),
                ),

                // Skeleton preview
                if (widget.showSkeleton) ...[
                  SizedBox(height: spacing.space6),
                  Expanded(
                    flex: 2,
                    child: _buildSkeletonPreview(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultIndicator() {
    return _PulsingDots(color: colors.accents5);
  }

  Widget _buildSkeletonPreview() {
    switch (widget.skeletonType) {
      case LoadingSkeletonType.dashboard:
        return _buildDashboardSkeleton();
      case LoadingSkeletonType.list:
        return _buildListSkeleton();
      case LoadingSkeletonType.profile:
        return _buildProfileSkeleton();
      case LoadingSkeletonType.article:
        return _buildArticleSkeleton();
      case LoadingSkeletonType.form:
        return _buildFormSkeleton();
    }
  }

  Widget _buildDashboardSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Balance card
        CuSkeleton.card(height: 100),
        SizedBox(height: spacing.space4),

        // Quick actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) => Column(
            children: [
              CuSkeleton.avatar(size: 48),
              SizedBox(height: spacing.space2),
              CuSkeleton.text(width: 50, height: 10),
            ],
          )),
        ),
        SizedBox(height: spacing.space4),

        // Accounts section
        CuSkeleton.heading(width: 100),
        SizedBox(height: spacing.space3),
        ...List.generate(2, (index) => Padding(
          padding: EdgeInsets.only(bottom: spacing.space2),
          child: CuSkeletonLayout.listItem(),
        )),
      ],
    );
  }

  Widget _buildListSkeleton() {
    return Column(
      children: List.generate(5, (index) => Padding(
        padding: EdgeInsets.only(bottom: spacing.space3),
        child: CuSkeletonLayout.listItem(),
      )),
    );
  }

  Widget _buildProfileSkeleton() {
    return Column(
      children: [
        CuSkeletonLayout.profile(),
        SizedBox(height: spacing.space6),
        ...List.generate(3, (index) => Padding(
          padding: EdgeInsets.only(bottom: spacing.space3),
          child: CuSkeleton.input(),
        )),
        SizedBox(height: spacing.space4),
        CuSkeleton.button(width: double.infinity, height: 48),
      ],
    );
  }

  Widget _buildArticleSkeleton() {
    return SingleChildScrollView(
      child: CuSkeletonLayout.article(),
    );
  }

  Widget _buildFormSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CuSkeleton.text(width: 80, height: 12),
        SizedBox(height: spacing.space1),
        CuSkeleton.input(),
        SizedBox(height: spacing.space4),
        CuSkeleton.text(width: 80, height: 12),
        SizedBox(height: spacing.space1),
        CuSkeleton.input(),
        SizedBox(height: spacing.space4),
        CuSkeleton.text(width: 80, height: 12),
        SizedBox(height: spacing.space1),
        CuSkeleton.card(height: 100),
        SizedBox(height: spacing.space6),
        CuSkeleton.button(width: double.infinity, height: 48),
      ],
    );
  }
}

/// Types of skeleton previews
enum LoadingSkeletonType {
  dashboard,
  list,
  profile,
  article,
  form,
}

/// Pulsing dots loading indicator
class _PulsingDots extends StatefulWidget {
  final Color color;
  final double size;
  final int count;

  const _PulsingDots({
    required this.color,
    this.size = 8,
    this.count = 3,
  });

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.count, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final value = (_controller.value + delay) % 1.0;
            final opacity = (value < 0.5)
                ? (value * 2)
                : (1 - (value - 0.5) * 2);

            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.5),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.3 + opacity * 0.7),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
