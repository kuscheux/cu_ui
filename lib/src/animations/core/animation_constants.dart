import 'package:flutter/widgets.dart';

/// Animation constants for CU UI animation system
class CuAnimationConstants {
  CuAnimationConstants._();

  // ============================================
  // FRAME RATE
  // ============================================
  static const int targetFps = 60;
  static const double frameDuration = 1000 / 60; // ~16.67ms

  // ============================================
  // PARTICLE SYSTEM
  // ============================================
  static const double lerpSpeed = 0.15;
  static const double defaultSpacing = 8.0;
  static const double particleSizeMin = 1.5;
  static const double particleSizeMax = 4.0;
  static const int particleStride = 12;

  // ============================================
  // BREATHING EFFECT
  // ============================================
  static const double breathingSpeedMin = 0.3;
  static const double breathingSpeedMax = 1.2;
  static const double breathingAmplitudeMin = 0.1;
  static const double breathingAmplitudeMax = 0.4;

  // ============================================
  // TEXT ANIMATION
  // ============================================
  static const Duration textLetterDuration = Duration(milliseconds: 500);
  static const Duration textLetterStagger = Duration(milliseconds: 30);
  static const double textInitialOffsetY = 20.0;

  // ============================================
  // WAVE PHASE RATIOS
  // ============================================
  static const double risePhaseRatio = 0.3;
  static const double holdPhaseRatio = 0.4;
  static const double fallPhaseRatio = 0.3;

  // ============================================
  // RIPPLE EFFECT
  // ============================================
  static const double rippleSpeed = 150.0;
  static const double rippleWidth = 60.0;
  static const Duration rippleDuration = Duration(milliseconds: 2000);

  // ============================================
  // TITLE MASK
  // ============================================
  static const double titleMaskWidth = 280.0;
  static const double titleMaskHeight = 80.0;

  // ============================================
  // MODE-SPECIFIC PARAMETERS
  // ============================================

  // ANALYZE
  static const Duration analyzeWaveInterval = Duration(milliseconds: 800);
  static const int analyzeConnectionCount = 8;
  static const Duration analyzeConnectionDuration = Duration(milliseconds: 2000);
  static const double analyzeBaseOpacity = 0.12;
  static const double analyzeBreathingAmplitude = 0.5;

  // THINK
  static const Duration thinkWaveInterval = Duration(milliseconds: 2000);
  static const double thinkWaveSpeed = 100.0;
  static const double thinkWaveWidth = 120.0;
  static const double thinkBaseOpacity = 0.06;
  static const double thinkPeakOpacity = 0.55;
  static const double thinkSizeMultiplier = 1.8;

  // CONNECT
  static const Duration connectWaveInterval = Duration(milliseconds: 2500);
  static const double connectWaveSpeed = 130.0;
  static const double connectWaveWidth = 150.0;
  static const double connectBaseOpacity = 0.06;
  static const double connectPeakOpacity = 0.55;
  static const double connectSizeMultiplier = 1.8;

  // INTENSE
  static const Duration intenseWaveInterval = Duration(milliseconds: 2000);
  static const double intenseWaveSpeed = 110.0;
  static const double intenseWaveWidth = 130.0;
  static const Duration intensePowerPulseInterval = Duration(milliseconds: 1200);
  static const double intenseBaseOpacity = 0.05;
  static const double intensePeakOpacity = 0.65;
  static const double intenseSizeMultiplier = 2.0;

  // DEEP
  static const Duration deepWaveInterval = Duration(milliseconds: 2000);
  static const double deepWaveSpeed = 90.0;
  static const double deepWaveWidth = 100.0;
  static const int deepSpiralRotations = 4;
  static const double deepRotationSpeed = 0.3;
  static const double deepBaseOpacity = 0.05;
  static const double deepPeakOpacity = 0.45;
  static const double deepSizeMultiplier = 1.6;

  // TRANSFER
  static const Duration transferWaveInterval = Duration(milliseconds: 1000);
  static const double transferWaveSpeed = 25.0;
  static const double transferWaveWidth = 15.0;
  static const double transferBaseOpacity = 0.06;
  static const double transferPeakOpacity = 0.60;
  static const double transferSizeMultiplier = 1.8;
}

/// Animation mode enum
enum CuAnimationMode {
  analyze,
  think,
  connect,
  intense,
  deep,
  transfer,
}

/// Get gradient colors for animation mode
List<Color> getGradientColorsForMode(CuAnimationMode mode) {
  switch (mode) {
    case CuAnimationMode.analyze:
      return const [
        Color(0xFFa855f7), // purple500
        Color(0xFFec4899), // pink500
        Color(0xFF312e81), // indigo900
      ];
    case CuAnimationMode.think:
      return const [
        Color(0xFF2dd4bf), // teal400
        Color(0xFF06b6d4), // cyan500
        Color(0xFF1e3a8a), // blue900
      ];
    case CuAnimationMode.connect:
      return const [
        Color(0xFF34d399), // emerald400
        Color(0xFF22c55e), // green500
        Color(0xFF0f172a), // slate900
      ];
    case CuAnimationMode.intense:
      return const [
        Color(0xFFef4444), // red500
        Color(0xFFf97316), // orange500
        Color(0xFF0f172a), // slate900
      ];
    case CuAnimationMode.deep:
      return const [
        Color(0xFF1e1b4b), // indigo950
        Color(0xFF3b0764), // purple950
        Color(0xFF2e1065), // violet950
      ];
    case CuAnimationMode.transfer:
      return const [
        Color(0xFFfbbf24), // amber400
        Color(0xFFf97316), // orange500
        Color(0xFF0f172a), // slate900
      ];
  }
}

/// Get gradient opacities for animation mode
List<double> getGradientOpacitiesForMode(CuAnimationMode mode) {
  switch (mode) {
    case CuAnimationMode.analyze:
    case CuAnimationMode.think:
    case CuAnimationMode.connect:
    case CuAnimationMode.intense:
    case CuAnimationMode.transfer:
      return const [0.3, 0.4, 0.5];
    case CuAnimationMode.deep:
      return const [0.4, 0.5, 0.6];
  }
}
