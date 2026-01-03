import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// CU UI Modal Component
/// Matches Geist UI Modal - dialog overlay
class CuModal extends StatefulWidget {
  /// Modal content
  final Widget child;

  /// Whether modal is visible
  final bool visible;

  /// Close callback
  final VoidCallback? onClose;

  /// Disable backdrop click to close
  final bool disableBackdropClick;

  /// Enable keyboard (Escape to close)
  final bool keyboard;

  /// Modal width
  final double? width;

  const CuModal({
    super.key,
    required this.child,
    this.visible = false,
    this.onClose,
    this.disableBackdropClick = false,
    this.keyboard = true,
    this.width,
  });

  /// Show a modal dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool disableBackdropClick = false,
    bool keyboard = true,
    double? width,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: !disableBackdropClick,
      barrierLabel: 'Modal',
      barrierColor: const Color(0x8A000000),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _ModalContent(
          width: width,
          onClose: () => Navigator.of(context).pop(),
          child: child,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<CuModal> createState() => _CuModalState();
}

class _CuModalState extends State<CuModal> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return const SizedBox.shrink();

    return Stack(
      children: [
        // Backdrop
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.disableBackdropClick ? null : widget.onClose,
            child: Container(color: const Color(0x8A000000)),
          ),
        ),

        // Modal
        Center(
          child: _ModalContent(
            width: widget.width,
            onClose: widget.onClose,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

class _ModalContent extends StatefulWidget {
  final Widget child;
  final double? width;
  final VoidCallback? onClose;

  const _ModalContent({
    required this.child,
    this.width,
    this.onClose,
  });

  @override
  State<_ModalContent> createState() => _ModalContentState();
}

class _ModalContentState extends State<_ModalContent> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 420,
      constraints: const BoxConstraints(maxHeight: 600),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: radius.lgBorder,
        boxShadow: shadows.largeList,
      ),
      child: widget.child,
    );
  }
}

/// Modal Title Component
class CuModalTitle extends StatefulWidget {
  final String text;

  const CuModalTitle(this.text, {super.key});

  @override
  State<CuModalTitle> createState() => _CuModalTitleState();
}

class _CuModalTitleState extends State<CuModalTitle> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.space4,
        spacing.space4,
        spacing.space4,
        spacing.space2,
      ),
      child: Text(
        widget.text,
        style: typography.h4,
      ),
    );
  }
}

/// Modal Subtitle Component
class CuModalSubtitle extends StatefulWidget {
  final String text;

  const CuModalSubtitle(this.text, {super.key});

  @override
  State<CuModalSubtitle> createState() => _CuModalSubtitleState();
}

class _CuModalSubtitleState extends State<CuModalSubtitle> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.space4),
      child: Text(
        widget.text,
        style: typography.body.copyWith(color: colors.accents5),
      ),
    );
  }
}

/// Modal Content Component
class CuModalContent extends StatefulWidget {
  final Widget child;

  const CuModalContent({super.key, required this.child});

  @override
  State<CuModalContent> createState() => _CuModalContentState();
}

class _CuModalContentState extends State<CuModalContent> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(spacing.space4),
      child: widget.child,
    );
  }
}

/// Modal Action Component
class CuModalAction extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool passive;

  const CuModalAction({
    super.key,
    required this.child,
    this.onTap,
    this.passive = false,
  });

  @override
  State<CuModalAction> createState() => _CuModalActionState();
}

class _CuModalActionState extends State<CuModalAction> with CuComponentMixin {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: EdgeInsets.all(spacing.space3),
            decoration: BoxDecoration(
              color: _isHovered ? colors.accents1 : const Color(0x00000000),
            ),
            child: Center(
              child: DefaultTextStyle(
                style: typography.body.copyWith(
                  color: widget.passive ? colors.accents5 : colors.foreground,
                  fontWeight: typography.weightMedium,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Modal Actions Container
class CuModalActions extends StatefulWidget {
  final List<Widget> children;

  const CuModalActions({super.key, required this.children});

  @override
  State<CuModalActions> createState() => _CuModalActionsState();
}

class _CuModalActionsState extends State<CuModalActions> with CuComponentMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: widget.children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          final isLast = index == widget.children.length - 1;

          if (isLast) return child;

          return Row(
            children: [
              Expanded(child: child),
              Container(width: 1, height: 50, color: colors.border),
            ],
          );
        }).toList(),
      ),
    );
  }
}
