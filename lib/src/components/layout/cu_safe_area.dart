import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CuSafeArea - Custom safe area component
///
/// Wraps content with safe area insets while allowing
/// customization of which edges to apply padding to.
///
/// ## Example
/// ```dart
/// CuSafeArea(
///   child: MyContent(),
/// )
///
/// // Only apply to top
/// CuSafeArea.top(
///   child: MyContent(),
/// )
/// ```
class CuSafeArea extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// Whether to apply padding to top
  final bool top;

  /// Whether to apply padding to bottom
  final bool bottom;

  /// Whether to apply padding to left
  final bool left;

  /// Whether to apply padding to right
  final bool right;

  /// Minimum padding values (added to safe area insets)
  final EdgeInsets? minimum;

  /// Background color behind safe area
  final Color? backgroundColor;

  /// Whether to maintain bottom view padding (keyboard)
  final bool maintainBottomViewPadding;

  const CuSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.minimum,
    this.backgroundColor,
    this.maintainBottomViewPadding = false,
  });

  /// Create safe area that only applies to top
  factory CuSafeArea.top({
    Key? key,
    required Widget child,
    EdgeInsets? minimum,
    Color? backgroundColor,
  }) {
    return CuSafeArea(
      key: key,
      top: true,
      bottom: false,
      left: false,
      right: false,
      minimum: minimum,
      backgroundColor: backgroundColor,
      child: child,
    );
  }

  /// Create safe area that only applies to bottom
  factory CuSafeArea.bottom({
    Key? key,
    required Widget child,
    EdgeInsets? minimum,
    Color? backgroundColor,
    bool maintainBottomViewPadding = false,
  }) {
    return CuSafeArea(
      key: key,
      top: false,
      bottom: true,
      left: false,
      right: false,
      minimum: minimum,
      backgroundColor: backgroundColor,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: child,
    );
  }

  /// Create safe area that only applies horizontally
  factory CuSafeArea.horizontal({
    Key? key,
    required Widget child,
    EdgeInsets? minimum,
    Color? backgroundColor,
  }) {
    return CuSafeArea(
      key: key,
      top: false,
      bottom: false,
      left: true,
      right: true,
      minimum: minimum,
      backgroundColor: backgroundColor,
      child: child,
    );
  }

  /// Create safe area that only applies vertically
  factory CuSafeArea.vertical({
    Key? key,
    required Widget child,
    EdgeInsets? minimum,
    Color? backgroundColor,
  }) {
    return CuSafeArea(
      key: key,
      top: true,
      bottom: true,
      left: false,
      right: false,
      minimum: minimum,
      backgroundColor: backgroundColor,
      child: child,
    );
  }

  /// Create safe area without any insets (just optional minimum padding)
  factory CuSafeArea.none({
    Key? key,
    required Widget child,
    EdgeInsets? minimum,
    Color? backgroundColor,
  }) {
    return CuSafeArea(
      key: key,
      top: false,
      bottom: false,
      left: false,
      right: false,
      minimum: minimum,
      backgroundColor: backgroundColor,
      child: child,
    );
  }

  @override
  State<CuSafeArea> createState() => _CuSafeAreaState();
}

class _CuSafeAreaState extends State<CuSafeArea> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var padding = mediaQuery.padding;

    // Handle bottom view padding (keyboard)
    if (widget.maintainBottomViewPadding) {
      padding = padding.copyWith(
        bottom: padding.bottom + mediaQuery.viewInsets.bottom,
      );
    }

    // Calculate final padding
    final effectivePadding = EdgeInsets.only(
      top: widget.top ? padding.top : 0,
      bottom: widget.bottom ? padding.bottom : 0,
      left: widget.left ? padding.left : 0,
      right: widget.right ? padding.right : 0,
    );

    // Add minimum padding if specified
    final finalPadding = widget.minimum != null
        ? EdgeInsets.only(
            top: effectivePadding.top > 0
                ? effectivePadding.top
                : widget.minimum!.top,
            bottom: effectivePadding.bottom > 0
                ? effectivePadding.bottom
                : widget.minimum!.bottom,
            left: effectivePadding.left > 0
                ? effectivePadding.left
                : widget.minimum!.left,
            right: effectivePadding.right > 0
                ? effectivePadding.right
                : widget.minimum!.right,
          )
        : effectivePadding;

    Widget child = Padding(
      padding: finalPadding,
      child: widget.child,
    );

    if (widget.backgroundColor != null) {
      child = Container(
        color: widget.backgroundColor,
        child: child,
      );
    }

    return child;
  }
}

/// Extension for getting safe area values
extension CuSafeAreaExtension on BuildContext {
  /// Get the current safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  /// Get safe area top padding
  double get safeAreaTop => MediaQuery.of(this).padding.top;

  /// Get safe area bottom padding
  double get safeAreaBottom => MediaQuery.of(this).padding.bottom;

  /// Get safe area left padding
  double get safeAreaLeft => MediaQuery.of(this).padding.left;

  /// Get safe area right padding
  double get safeAreaRight => MediaQuery.of(this).padding.right;
}
