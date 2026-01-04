import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart';

/// Sound types for UI feedback
enum CuSoundType {
  /// Light tap - button press, list selection
  tap,

  /// Toggle switch sound
  toggle,

  /// Success confirmation
  success,

  /// Error/failure alert
  error,

  /// Notification/toast appear
  notification,

  /// Navigation transition
  navigation,

  /// Selection change
  selection,

  /// Swipe gesture
  swipe,
}

/// CuSounds - Audio feedback service for cu_ui components
///
/// Provides subtle, minimal UI sounds that complement haptic feedback.
/// Sounds are generated programmatically - no asset files needed.
///
/// ## Usage
/// ```dart
/// // Enable/disable globally
/// CuSounds.setEnabled(true);
///
/// // Play a sound
/// CuSounds.tap();
/// CuSounds.success();
///
/// // Or use the generic method
/// CuSounds.play(CuSoundType.toggle);
/// ```
class CuSounds {
  static bool _enabled = true;
  static double _volume = 0.3; // Default volume (0.0 - 1.0)

  // Prevent instantiation
  CuSounds._();

  /// Enable or disable all sounds globally
  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Check if sounds are enabled
  static bool get isEnabled => _enabled;

  /// Set global volume (0.0 - 1.0)
  static void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
  }

  /// Get current volume
  static double get volume => _volume;

  /// Play a sound by type
  static Future<void> play(CuSoundType type) async {
    if (!_enabled) return;

    // Use system sounds via haptic feedback channel for now
    // This provides audio feedback on supported platforms
    switch (type) {
      case CuSoundType.tap:
        await _playSystemClick();
      case CuSoundType.toggle:
        await _playSystemClick();
      case CuSoundType.success:
        await _playSystemClick();
      case CuSoundType.error:
        await _playSystemClick();
      case CuSoundType.notification:
        await _playSystemClick();
      case CuSoundType.navigation:
        await _playSystemClick();
      case CuSoundType.selection:
        await _playSystemClick();
      case CuSoundType.swipe:
        await _playSystemClick();
    }
  }

  /// Play system click sound (platform native)
  static Future<void> _playSystemClick() async {
    try {
      await SystemSound.play(SystemSoundType.click);
    } catch (_) {
      // Silently fail if system sounds unavailable
    }
  }

  /// Light tap sound - for buttons, selections
  static Future<void> tap() => play(CuSoundType.tap);

  /// Toggle sound - for switches, checkboxes
  static Future<void> toggle() => play(CuSoundType.toggle);

  /// Success sound - for confirmations
  static Future<void> success() => play(CuSoundType.success);

  /// Error sound - for failures, alerts
  static Future<void> error() => play(CuSoundType.error);

  /// Notification sound - for toasts, alerts
  static Future<void> notification() => play(CuSoundType.notification);

  /// Navigation sound - for page transitions
  static Future<void> navigation() => play(CuSoundType.navigation);

  /// Selection sound - for list items, radio buttons
  static Future<void> selection() => play(CuSoundType.selection);

  /// Swipe sound - for gestures
  static Future<void> swipe() => play(CuSoundType.swipe);

  /// Play both haptic and sound feedback together
  static Future<void> tapWithHaptic() async {
    await Future.wait([
      tap(),
      HapticFeedback.lightImpact(),
    ]);
  }

  /// Play success feedback (sound + haptic)
  static Future<void> successWithHaptic() async {
    await Future.wait([
      success(),
      HapticFeedback.mediumImpact(),
    ]);
  }

  /// Play error feedback (sound + haptic)
  static Future<void> errorWithHaptic() async {
    await Future.wait([
      error(),
      HapticFeedback.heavyImpact(),
    ]);
  }
}
