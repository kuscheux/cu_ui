import 'package:flutter/services.dart';

/// Haptic feedback types
enum CuHapticType {
  /// Light tap feedback
  light,
  /// Medium impact feedback
  medium,
  /// Heavy impact feedback
  heavy,
  /// Selection change feedback
  selection,
  /// Success feedback
  success,
  /// Warning feedback
  warning,
  /// Error feedback
  error,
}

/// CU UI Haptics Service
/// Provides haptic feedback for components
class CuHaptics {
  static bool _enabled = true;

  /// Enable or disable haptics globally
  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Check if haptics are enabled
  static bool get isEnabled => _enabled;

  /// Trigger haptic feedback
  static Future<void> feedback(CuHapticType type) async {
    if (!_enabled) return;

    switch (type) {
      case CuHapticType.light:
        await HapticFeedback.lightImpact();
        break;
      case CuHapticType.medium:
        await HapticFeedback.mediumImpact();
        break;
      case CuHapticType.heavy:
        await HapticFeedback.heavyImpact();
        break;
      case CuHapticType.selection:
        await HapticFeedback.selectionClick();
        break;
      case CuHapticType.success:
        await HapticFeedback.mediumImpact();
        break;
      case CuHapticType.warning:
        await HapticFeedback.mediumImpact();
        break;
      case CuHapticType.error:
        await HapticFeedback.heavyImpact();
        break;
    }
  }

  /// Light tap feedback
  static Future<void> light() => feedback(CuHapticType.light);

  /// Medium impact feedback
  static Future<void> medium() => feedback(CuHapticType.medium);

  /// Heavy impact feedback
  static Future<void> heavy() => feedback(CuHapticType.heavy);

  /// Selection feedback
  static Future<void> selection() => feedback(CuHapticType.selection);

  /// Success feedback
  static Future<void> success() => feedback(CuHapticType.success);

  /// Warning feedback
  static Future<void> warning() => feedback(CuHapticType.warning);

  /// Error feedback
  static Future<void> error() => feedback(CuHapticType.error);
}
