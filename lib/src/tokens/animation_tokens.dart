import 'package:flutter/widgets.dart';

/// CU UI Animation Token System
@immutable
class CuAnimationTokens {
  // ============================================
  // DURATIONS
  // ============================================
  final Duration instant; // 0ms
  final Duration fast; // 150ms
  final Duration normal; // 200ms
  final Duration slow; // 350ms
  final Duration slower; // 400ms

  // ============================================
  // CURVES
  // ============================================
  final Curve ease;
  final Curve easeIn;
  final Curve easeOut;
  final Curve easeInOut;

  // ============================================
  // CUSTOM CURVES (from ai_animation_states)
  // ============================================
  final Curve primary; // Main animations
  final Curve textReveal; // Letter reveal
  final Curve tabSwitch; // Tab transitions
  final Curve particleFade; // Particle opacity

  const CuAnimationTokens({
    this.instant = Duration.zero,
    this.fast = const Duration(milliseconds: 150),
    this.normal = const Duration(milliseconds: 200),
    this.slow = const Duration(milliseconds: 350),
    this.slower = const Duration(milliseconds: 400),
    this.ease = Curves.ease,
    this.easeIn = Curves.easeIn,
    this.easeOut = Curves.easeOut,
    this.easeInOut = Curves.easeInOut,
    this.primary = const Cubic(0.21, 0.47, 0.32, 0.98),
    this.textReveal = const Cubic(0.21, 0.47, 0.32, 0.98),
    this.tabSwitch = const Cubic(0.25, 0.1, 0.25, 1.0),
    this.particleFade = const Cubic(0.4, 0.0, 0.2, 1.0),
  });

  CuAnimationTokens copyWith({
    Duration? instant,
    Duration? fast,
    Duration? normal,
    Duration? slow,
    Duration? slower,
    Curve? ease,
    Curve? easeIn,
    Curve? easeOut,
    Curve? easeInOut,
    Curve? primary,
    Curve? textReveal,
    Curve? tabSwitch,
    Curve? particleFade,
  }) {
    return CuAnimationTokens(
      instant: instant ?? this.instant,
      fast: fast ?? this.fast,
      normal: normal ?? this.normal,
      slow: slow ?? this.slow,
      slower: slower ?? this.slower,
      ease: ease ?? this.ease,
      easeIn: easeIn ?? this.easeIn,
      easeOut: easeOut ?? this.easeOut,
      easeInOut: easeInOut ?? this.easeInOut,
      primary: primary ?? this.primary,
      textReveal: textReveal ?? this.textReveal,
      tabSwitch: tabSwitch ?? this.tabSwitch,
      particleFade: particleFade ?? this.particleFade,
    );
  }
}

/// Animation mode constants (from ai_animation_states)
class CuAnimationModeConstants {
  CuAnimationModeConstants._();

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
}

/// Per-mode animation parameters
class CuAnimationModeParams {
  final Duration waveInterval;
  final double waveSpeed;
  final double waveWidth;
  final double baseOpacity;
  final double peakOpacity;
  final double sizeMultiplier;
  final double breathingAmplitude;
  final List<Color> gradientColors;
  final List<double> gradientOpacities;

  const CuAnimationModeParams({
    required this.waveInterval,
    required this.waveSpeed,
    required this.waveWidth,
    required this.baseOpacity,
    required this.peakOpacity,
    required this.sizeMultiplier,
    required this.breathingAmplitude,
    required this.gradientColors,
    required this.gradientOpacities,
  });

  // ============================================
  // MODE PRESETS
  // ============================================

  static const analyze = CuAnimationModeParams(
    waveInterval: Duration(milliseconds: 800),
    waveSpeed: 0, // No wave propagation
    waveWidth: 0,
    baseOpacity: 0.12,
    peakOpacity: 0.50,
    sizeMultiplier: 1.8,
    breathingAmplitude: 0.5,
    gradientColors: [
      Color(0xFFa855f7), // purple500
      Color(0xFFec4899), // pink500
      Color(0xFF312e81), // indigo900
    ],
    gradientOpacities: [0.3, 0.4, 0.5],
  );

  static const think = CuAnimationModeParams(
    waveInterval: Duration(milliseconds: 2000),
    waveSpeed: 100.0,
    waveWidth: 120.0,
    baseOpacity: 0.06,
    peakOpacity: 0.55,
    sizeMultiplier: 1.8,
    breathingAmplitude: 0.3,
    gradientColors: [
      Color(0xFF2dd4bf), // teal400
      Color(0xFF06b6d4), // cyan500
      Color(0xFF1e3a8a), // blue900
    ],
    gradientOpacities: [0.3, 0.4, 0.5],
  );

  static const connect = CuAnimationModeParams(
    waveInterval: Duration(milliseconds: 2500),
    waveSpeed: 130.0,
    waveWidth: 150.0,
    baseOpacity: 0.06,
    peakOpacity: 0.55,
    sizeMultiplier: 1.8,
    breathingAmplitude: 0.3,
    gradientColors: [
      Color(0xFF34d399), // emerald400
      Color(0xFF22c55e), // green500
      Color(0xFF0f172a), // slate900
    ],
    gradientOpacities: [0.3, 0.4, 0.5],
  );

  static const intense = CuAnimationModeParams(
    waveInterval: Duration(milliseconds: 2000),
    waveSpeed: 110.0,
    waveWidth: 130.0,
    baseOpacity: 0.05,
    peakOpacity: 0.65,
    sizeMultiplier: 2.0,
    breathingAmplitude: 0.3,
    gradientColors: [
      Color(0xFFef4444), // red500
      Color(0xFFf97316), // orange500
      Color(0xFF0f172a), // slate900
    ],
    gradientOpacities: [0.3, 0.4, 0.5],
  );

  static const deep = CuAnimationModeParams(
    waveInterval: Duration(milliseconds: 2000),
    waveSpeed: 90.0,
    waveWidth: 100.0,
    baseOpacity: 0.05,
    peakOpacity: 0.45,
    sizeMultiplier: 1.6,
    breathingAmplitude: 0.3,
    gradientColors: [
      Color(0xFF1e1b4b), // indigo950
      Color(0xFF3b0764), // purple950
      Color(0xFF2e1065), // violet950
    ],
    gradientOpacities: [0.4, 0.5, 0.6],
  );

  static const transfer = CuAnimationModeParams(
    waveInterval: Duration(milliseconds: 1000),
    waveSpeed: 25.0,
    waveWidth: 15.0,
    baseOpacity: 0.06,
    peakOpacity: 0.60,
    sizeMultiplier: 1.8,
    breathingAmplitude: 0.3,
    gradientColors: [
      Color(0xFFfbbf24), // amber400
      Color(0xFFf97316), // orange500
      Color(0xFF0f172a), // slate900
    ],
    gradientOpacities: [0.3, 0.4, 0.5],
  );
}
