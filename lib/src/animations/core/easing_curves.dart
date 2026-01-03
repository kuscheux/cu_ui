import 'package:flutter/animation.dart';

/// Custom easing curves for CU UI animations
class CuEasingCurves {
  CuEasingCurves._();

  /// Primary animation curve: [0.21, 0.47, 0.32, 0.98]
  /// Smooth ease-out with slight overshoot feel
  static const Curve primary = Cubic(0.21, 0.47, 0.32, 0.98);

  /// Text reveal curve - same as primary
  static const Curve textReveal = Cubic(0.21, 0.47, 0.32, 0.98);

  /// Tab switch curve
  static const Curve tabSwitch = Cubic(0.25, 0.1, 0.25, 1.0);

  /// Particle fade curve
  static const Curve particleFade = Cubic(0.4, 0.0, 0.2, 1.0);

  /// Wave intensity curve - smooth bell curve effect
  static double waveIntensity(double normalizedPosition, double waveWidth) {
    // Rise phase: 0-30% of wave width
    // Hold phase: 30-70% of wave width
    // Fall phase: 70-100% of wave width
    const riseEnd = 0.3;
    const holdEnd = 0.7;

    if (normalizedPosition < 0 || normalizedPosition > 1) {
      return 0.0;
    }

    if (normalizedPosition < riseEnd) {
      // Rise: 0 -> 1
      return normalizedPosition / riseEnd;
    } else if (normalizedPosition < holdEnd) {
      // Hold: stay at 1
      return 1.0;
    } else {
      // Fall: 1 -> 0
      return 1.0 - ((normalizedPosition - holdEnd) / (1.0 - holdEnd));
    }
  }

  /// Smooth step function for wave effects
  static double smoothStep(double edge0, double edge1, double x) {
    final t = ((x - edge0) / (edge1 - edge0)).clamp(0.0, 1.0);
    return t * t * (3 - 2 * t);
  }
}
