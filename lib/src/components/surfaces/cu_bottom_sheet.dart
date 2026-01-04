import 'package:flutter/widgets.dart';
import '../../theme/cu_theme.dart';
import '../../services/cu_haptics.dart';
import '../_base/cu_component.dart';

/// Breakpoint for switching between bottom sheet and dialog
const double _desktopBreakpoint = 768.0;

/// CuBottomSheet - Modal bottom sheet / popup dialog component
///
/// A draggable bottom sheet on mobile that becomes a centered popup dialog on desktop.
/// Used for selections, menus, and contextual content.
///
/// ## Example
/// ```dart
/// CuBottomSheet.show(
///   context: context,
///   builder: (context) => Column(
///     children: [
///       CuBottomSheetOption(label: 'Option 1', onTap: () {}),
///       CuBottomSheetOption(label: 'Option 2', onTap: () {}),
///     ],
///   ),
/// );
/// ```
class CuBottomSheet extends StatefulWidget {
  /// Content of the bottom sheet
  final Widget child;

  /// Title text
  final String? title;

  /// Whether to show drag handle
  final bool showDragHandle;

  /// Whether to show close button
  final bool showCloseButton;

  /// Called when sheet is closed
  final VoidCallback? onClose;

  /// Maximum height as fraction of screen (0.0 - 1.0)
  final double maxHeightFraction;

  /// Minimum height as fraction of screen
  final double minHeightFraction;

  /// Initial height as fraction of screen
  final double initialHeightFraction;

  /// Whether sheet can be dismissed by tapping outside
  final bool isDismissible;

  /// Background color
  final Color? backgroundColor;

  const CuBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.showDragHandle = true,
    this.showCloseButton = false,
    this.onClose,
    this.maxHeightFraction = 0.9,
    this.minHeightFraction = 0.25,
    this.initialHeightFraction = 0.5,
    this.isDismissible = true,
    this.backgroundColor,
  });

  /// Show a bottom sheet (mobile) or popup dialog (desktop)
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    String? title,
    bool showDragHandle = true,
    bool showCloseButton = false,
    double maxHeightFraction = 0.9,
    double minHeightFraction = 0.25,
    double initialHeightFraction = 0.5,
    bool isDismissible = true,
    Color? backgroundColor,
    double? dialogWidth,
    double? dialogMaxHeight,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= _desktopBreakpoint;

    if (isDesktop) {
      // Show as centered popup dialog on desktop
      return Navigator.of(context).push<T>(
        _PopupDialogRoute<T>(
          builder: (context) => _CuPopupDialog(
            title: title,
            showCloseButton: true,
            isDismissible: isDismissible,
            backgroundColor: backgroundColor,
            width: dialogWidth ?? 400,
            maxHeight: dialogMaxHeight ?? 500,
            child: builder(context),
          ),
          isDismissible: isDismissible,
        ),
      );
    } else {
      // Show as bottom sheet on mobile
      return Navigator.of(context).push<T>(
        _BottomSheetRoute<T>(
          builder: (context) => CuBottomSheet(
            title: title,
            showDragHandle: showDragHandle,
            showCloseButton: showCloseButton,
            maxHeightFraction: maxHeightFraction,
            minHeightFraction: minHeightFraction,
            initialHeightFraction: initialHeightFraction,
            isDismissible: isDismissible,
            backgroundColor: backgroundColor,
            child: builder(context),
          ),
          isDismissible: isDismissible,
        ),
      );
    }
  }

  /// Show a selection bottom sheet
  static Future<T?> showSelection<T>({
    required BuildContext context,
    required String title,
    required List<CuBottomSheetOption<T>> options,
    T? selectedValue,
    bool showDragHandle = true,
  }) {
    return show<T>(
      context: context,
      title: title,
      showDragHandle: showDragHandle,
      initialHeightFraction: 0.4,
      builder: (context) => _SelectionContent<T>(
        options: options,
        selectedValue: selectedValue,
      ),
    );
  }

  @override
  State<CuBottomSheet> createState() => _CuBottomSheetState();
}

class _CuBottomSheetState extends State<CuBottomSheet>
    with SingleTickerProviderStateMixin, CuComponentMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  double _currentHeight = 0;
  double _dragStartHeight = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _dragStartHeight = _currentHeight;
  }

  void _handleDragUpdate(DragUpdateDetails details, double maxHeight) {
    setState(() {
      _currentHeight = (_dragStartHeight - details.primaryDelta!).clamp(
        maxHeight * widget.minHeightFraction,
        maxHeight * widget.maxHeightFraction,
      );
    });
  }

  void _handleDragEnd(DragEndDetails details, double maxHeight) {
    final velocity = details.primaryVelocity ?? 0;
    final minHeight = maxHeight * widget.minHeightFraction;

    if (velocity > 500 || _currentHeight < minHeight * 1.5) {
      // Dismiss
      if (widget.isDismissible) {
        Navigator.of(context).pop();
      } else {
        _animateToHeight(minHeight);
      }
    } else if (velocity < -500) {
      // Expand
      _animateToHeight(maxHeight * widget.maxHeightFraction);
    } else {
      // Snap to nearest
      final midPoint = (minHeight + maxHeight * widget.maxHeightFraction) / 2;
      if (_currentHeight < midPoint) {
        _animateToHeight(minHeight);
      } else {
        _animateToHeight(maxHeight * widget.maxHeightFraction);
      }
    }
  }

  void _animateToHeight(double targetHeight) {
    final startHeight = _currentHeight;
    _controller.reset();
    _heightAnimation = Tween<double>(
      begin: startHeight,
      end: targetHeight,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _heightAnimation.addListener(() {
      setState(() {
        _currentHeight = _heightAnimation.value;
      });
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height - mediaQuery.padding.top;

    if (_currentHeight == 0) {
      _currentHeight = maxHeight * widget.initialHeightFraction;
    }

    return GestureDetector(
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: (d) => _handleDragUpdate(d, maxHeight),
      onVerticalDragEnd: (d) => _handleDragEnd(d, maxHeight),
      child: Container(
        height: _currentHeight,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle and header
            _buildHeader(),

            // Content
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: widget.child,
              ),
            ),

            // Bottom safe area padding
            SizedBox(height: mediaQuery.padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.space4,
        vertical: spacing.space2,
      ),
      child: Column(
        children: [
          // Drag handle
          if (widget.showDragHandle)
            Container(
              width: 36,
              height: 4,
              margin: EdgeInsets.only(bottom: spacing.space2),
              decoration: BoxDecoration(
                color: colors.accents3,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

          // Title row
          if (widget.title != null || widget.showCloseButton)
            Padding(
              padding: EdgeInsets.only(bottom: spacing.space2),
              child: Row(
                children: [
                  if (widget.showCloseButton)
                    GestureDetector(
                      onTap: () {
                        widget.onClose?.call();
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(spacing.space2),
                        child: Text(
                          '\u{2715}',
                          style: typography.body.copyWith(color: colors.accents5),
                        ),
                      ),
                    ),
                  if (widget.title != null)
                    Expanded(
                      child: Text(
                        widget.title!,
                        style: typography.h4.copyWith(color: colors.foreground),
                        textAlign: widget.showCloseButton
                            ? TextAlign.center
                            : TextAlign.left,
                      ),
                    ),
                  if (widget.showCloseButton)
                    SizedBox(width: spacing.space8),
                ],
              ),
            ),

          // Divider
          Container(
            height: 1,
            color: colors.border,
          ),
        ],
      ),
    );
  }
}

/// Selection content for bottom sheet
class _SelectionContent<T> extends StatelessWidget {
  final List<CuBottomSheetOption<T>> options;
  final T? selectedValue;

  const _SelectionContent({
    required this.options,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CuTheme.of(context);

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: theme.spacing.space2),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = option.value == selectedValue;

        return GestureDetector(
          onTap: () => Navigator.of(context).pop(option.value),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.space4,
              vertical: theme.spacing.space3,
            ),
            decoration: BoxDecoration(
              color: isSelected ? theme.colors.accents1 : null,
            ),
            child: Row(
              children: [
                if (option.icon != null) ...[
                  option.icon!,
                  SizedBox(width: theme.spacing.space3),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.label,
                        style: theme.typography.body.copyWith(
                          color: theme.colors.foreground,
                          fontWeight: isSelected
                              ? theme.typography.weightSemibold
                              : null,
                        ),
                      ),
                      if (option.subtitle != null)
                        Text(
                          option.subtitle!,
                          style: theme.typography.caption.copyWith(
                            color: theme.colors.accents5,
                          ),
                        ),
                    ],
                  ),
                ),
                if (isSelected)
                  Text(
                    '\u{2713}',
                    style: theme.typography.body.copyWith(
                      color: theme.colors.success.base,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Option for bottom sheet selection
class CuBottomSheetOption<T> {
  final T value;
  final String label;
  final String? subtitle;
  final Widget? icon;

  const CuBottomSheetOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
  });
}

/// Desktop popup dialog widget
class _CuPopupDialog extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showCloseButton;
  final bool isDismissible;
  final Color? backgroundColor;
  final double width;
  final double maxHeight;

  const _CuPopupDialog({
    required this.child,
    this.title,
    this.showCloseButton = true,
    this.isDismissible = true,
    this.backgroundColor,
    this.width = 400,
    this.maxHeight = 500,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CuTheme.of(context);

    return Center(
      child: Container(
        width: width,
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colors.background,
          borderRadius: BorderRadius.circular(theme.radius.lg),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.25),
              blurRadius: 40,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with title and close button
            if (title != null || showCloseButton)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.space4,
                  vertical: theme.spacing.space3,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colors.border,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    if (title != null)
                      Expanded(
                        child: Text(
                          title!,
                          style: theme.typography.h4.copyWith(
                            color: theme.colors.foreground,
                          ),
                        ),
                      ),
                    if (showCloseButton)
                      GestureDetector(
                        onTap: () {
                          if (theme.hapticsEnabled) CuHaptics.light();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.all(theme.spacing.space1),
                          child: Text(
                            '\u{2715}',
                            style: theme.typography.body.copyWith(
                              color: theme.colors.accents5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            // Content
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(theme.radius.lg),
                  top: (title != null || showCloseButton)
                      ? Radius.zero
                      : Radius.circular(theme.radius.lg),
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Route for showing popup dialog on desktop
class _PopupDialogRoute<T> extends PopupRoute<T> {
  final WidgetBuilder builder;
  final bool isDismissible;

  _PopupDialogRoute({
    required this.builder,
    this.isDismissible = true,
  });

  @override
  Color? get barrierColor => const Color(0x80000000);

  @override
  bool get barrierDismissible => isDismissible;

  @override
  String? get barrierLabel => 'Dismiss';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    ));

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ));

    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: child,
      ),
    );
  }
}

/// Route for showing bottom sheet
class _BottomSheetRoute<T> extends PopupRoute<T> {
  final WidgetBuilder builder;
  final bool isDismissible;

  _BottomSheetRoute({
    required this.builder,
    this.isDismissible = true,
  });

  @override
  Color? get barrierColor => const Color(0x80000000);

  @override
  bool get barrierDismissible => isDismissible;

  @override
  String? get barrierLabel => 'Dismiss';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    ));

    return SlideTransition(
      position: slideAnimation,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: child,
      ),
    );
  }
}
