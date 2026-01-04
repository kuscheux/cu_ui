import 'package:flutter/widgets.dart';

/// CuPreviewFrame - Reusable wrapper that provides Navigator and Overlay
///
/// Use this to wrap content that needs bottom sheets, overlays, or
/// other widgets that require a Navigator ancestor.
///
/// ## Example
/// ```dart
/// CuPreviewFrame(
///   child: MyContent(),
/// )
/// ```
class CuPreviewFrame extends StatefulWidget {
  /// Content to wrap
  final Widget child;

  /// Optional MediaQuery data override
  final MediaQueryData? mediaQueryData;

  const CuPreviewFrame({
    super.key,
    required this.child,
    this.mediaQueryData,
  });

  @override
  State<CuPreviewFrame> createState() => _CuPreviewFrameState();
}

class _CuPreviewFrameState extends State<CuPreviewFrame> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final effectiveMediaQuery = widget.mediaQueryData ??
        MediaQuery.maybeOf(context) ??
        const MediaQueryData();

    return MediaQuery(
      data: effectiveMediaQuery,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => _PreviewNavigator(
                navigatorKey: _navigatorKey,
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal navigator that rebuilds when child changes
class _PreviewNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  const _PreviewNavigator({
    required this.navigatorKey,
    required this.child,
  });

  @override
  State<_PreviewNavigator> createState() => _PreviewNavigatorState();
}

class _PreviewNavigatorState extends State<_PreviewNavigator> {
  @override
  Widget build(BuildContext context) {
    // Use child's hashCode as key to force rebuild when content changes
    return Navigator(
      key: ValueKey(widget.child.hashCode),
      onGenerateRoute: (settings) => PageRouteBuilder(
        pageBuilder: (context, _, __) => widget.child,
        transitionDuration: Duration.zero,
      ),
    );
  }
}
