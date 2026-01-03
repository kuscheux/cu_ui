import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Toast type variants
enum CuToastType {
  default_,
  secondary,
  success,
  warning,
  error,
}

/// Toast action
class CuToastAction {
  final String label;
  final VoidCallback onTap;
  final bool passive;

  const CuToastAction({
    required this.label,
    required this.onTap,
    this.passive = false,
  });
}

/// CU UI Toast Component
/// Matches Geist UI Toast - notification message
class CuToast extends StatefulWidget {
  /// Toast message
  final String text;

  /// Toast type
  final CuToastType type;

  /// Optional actions
  final List<CuToastAction>? actions;

  /// On close callback
  final VoidCallback? onClose;

  const CuToast({
    super.key,
    required this.text,
    this.type = CuToastType.default_,
    this.actions,
    this.onClose,
  });

  /// Show a toast message
  static void show(
    BuildContext context, {
    required String text,
    CuToastType type = CuToastType.default_,
    List<CuToastAction>? actions,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _ToastOverlay(
        text: text,
        type: type,
        actions: actions,
        duration: duration,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }

  @override
  State<CuToast> createState() => _CuToastState();
}

class _CuToastState extends State<CuToast> with CuComponentMixin {
  Color get _borderColor {
    switch (widget.type) {
      case CuToastType.default_:
        return colors.border;
      case CuToastType.secondary:
        return colors.secondary;
      case CuToastType.success:
        return colors.success.base;
      case CuToastType.warning:
        return colors.warning.base;
      case CuToastType.error:
        return colors.error.base;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(spacing.space4),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border.all(color: _borderColor),
        borderRadius: radius.mdBorder,
        boxShadow: shadows.mediumList,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(widget.text, style: typography.body),
          ),
          if (widget.actions != null && widget.actions!.isNotEmpty) ...[
            SizedBox(width: spacing.space4),
            ...widget.actions!.map((action) => _buildAction(action)),
          ],
        ],
      ),
    );
  }

  Widget _buildAction(CuToastAction action) {
    return Padding(
      padding: EdgeInsets.only(left: spacing.space2),
      child: GestureDetector(
        onTap: action.onTap,
        child: Text(
          action.label,
          style: typography.body.copyWith(
            color: action.passive ? colors.accents5 : colors.foreground,
            fontWeight: typography.weightMedium,
          ),
        ),
      ),
    );
  }
}

class _ToastOverlay extends StatefulWidget {
  final String text;
  final CuToastType type;
  final List<CuToastAction>? actions;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastOverlay({
    required this.text,
    required this.type,
    required this.duration,
    required this.onDismiss,
    this.actions,
  });

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin, CuComponentMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();

    Future.delayed(widget.duration, _dismiss);
  }

  void _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _borderColor {
    switch (widget.type) {
      case CuToastType.default_:
        return colors.border;
      case CuToastType.secondary:
        return colors.secondary;
      case CuToastType.success:
        return colors.success.base;
      case CuToastType.warning:
        return colors.warning.base;
      case CuToastType.error:
        return colors.error.base;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
      child: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
                padding: EdgeInsets.all(spacing.space4),
                decoration: BoxDecoration(
                  color: colors.background,
                  border: Border.all(color: _borderColor),
                  borderRadius: radius.mdBorder,
                  boxShadow: shadows.mediumList,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(widget.text, style: typography.body),
                    ),
                    if (widget.actions != null && widget.actions!.isNotEmpty) ...[
                      SizedBox(width: spacing.space4),
                      ...widget.actions!.map((action) => Padding(
                            padding: EdgeInsets.only(left: spacing.space2),
                            child: GestureDetector(
                              onTap: () {
                                action.onTap();
                                _dismiss();
                              },
                              child: Text(
                                action.label,
                                style: typography.body.copyWith(
                                  color: action.passive
                                      ? colors.accents5
                                      : colors.foreground,
                                  fontWeight: typography.weightMedium,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Toast provider hook
class CuToasts {
  final BuildContext context;

  CuToasts.of(this.context);

  void show({
    required String text,
    CuToastType type = CuToastType.default_,
    List<CuToastAction>? actions,
    Duration duration = const Duration(seconds: 3),
  }) {
    CuToast.show(
      context,
      text: text,
      type: type,
      actions: actions,
      duration: duration,
    );
  }

  void success(String text, {Duration duration = const Duration(seconds: 3)}) {
    show(text: text, type: CuToastType.success, duration: duration);
  }

  void warning(String text, {Duration duration = const Duration(seconds: 3)}) {
    show(text: text, type: CuToastType.warning, duration: duration);
  }

  void error(String text, {Duration duration = const Duration(seconds: 3)}) {
    show(text: text, type: CuToastType.error, duration: duration);
  }
}
