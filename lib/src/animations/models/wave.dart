import 'dart:math' as math;

/// Wave types for different animation modes
enum WaveType {
  circular, // Think mode - expands from center
  horizontal, // Connect mode - sweeps left to right
  spiral, // Deep mode - rotating spiral pattern
  row, // Transfer mode - row by row
  multiSource, // Intense mode - from multiple corners
}

/// A wave that affects particle visibility
class Wave {
  final WaveType type;
  final double startTime; // When the wave was created
  final double speed; // Units per second
  final double width; // Width of the active zone
  final double originX; // Origin point X (for circular/spiral)
  final double originY; // Origin point Y (for circular/spiral)
  final int sourceIndex; // For multi-source waves
  final double rotation; // For spiral waves

  const Wave({
    required this.type,
    required this.startTime,
    required this.speed,
    required this.width,
    this.originX = 0,
    this.originY = 0,
    this.sourceIndex = 0,
    this.rotation = 0,
  });

  /// Calculate the current radius/position of the wave front
  double getPosition(double currentTime) {
    return (currentTime - startTime) * speed;
  }

  /// Get wave intensity at a given distance from origin
  /// Returns 0-1 based on whether point is in wave zone
  double getIntensityAtDistance(double distance, double currentTime) {
    final wavePosition = getPosition(currentTime);
    final relativePosition = distance - wavePosition;

    // Check if point is within wave width
    if (relativePosition < -width || relativePosition > 0) {
      return 0.0;
    }

    // Normalize position within wave (0 = leading edge, 1 = trailing edge)
    final normalized = 1.0 + (relativePosition / width);

    // Apply wave phase (rise, hold, fall)
    return _calculatePhaseIntensity(normalized);
  }

  /// Get wave intensity for a horizontal sweep
  double getIntensityAtX(double x, double currentTime, double maxX) {
    final wavePosition = getPosition(currentTime);
    final relativePosition = x - wavePosition;

    if (relativePosition < -width || relativePosition > 0) {
      return 0.0;
    }

    final normalized = 1.0 + (relativePosition / width);
    return _calculatePhaseIntensity(normalized);
  }

  /// Get wave intensity for row-by-row transfer
  double getIntensityAtRow(int row, int totalRows, double currentTime) {
    final wavePosition = getPosition(currentTime);
    final rowPosition = row.toDouble();
    final relativePosition = rowPosition - wavePosition;

    if (relativePosition < -width || relativePosition > 0) {
      return 0.0;
    }

    final normalized = 1.0 + (relativePosition / width);
    return _calculatePhaseIntensity(normalized);
  }

  /// Calculate spiral distance (angle-adjusted radius)
  double getSpiralDistance(
      double x, double y, double originX, double originY, int rotations) {
    final dx = x - originX;
    final dy = y - originY;
    final radius = math.sqrt(dx * dx + dy * dy);
    final angle = math.atan2(dy, dx);

    // Adjust radius based on angle to create spiral effect
    final normalizedAngle = (angle + math.pi) / (2 * math.pi); // 0-1
    final spiralOffset = normalizedAngle * (radius / rotations);

    return radius + spiralOffset;
  }

  /// Phase intensity calculation using ultra-smooth gaussian-like curve
  /// Creates buttery smooth fade on both inner and outer edges
  double _calculatePhaseIntensity(double normalized) {
    if (normalized < 0 || normalized > 1) {
      return 0.0;
    }

    // Gaussian-like bell curve for ultra-smooth falloff
    // Center at 0.5, with smooth tails on both ends
    final centered = normalized - 0.5; // -0.5 to 0.5
    final gaussian = math.exp(-8.0 * centered * centered); // Smooth bell curve

    // Additional smoothstep for extra buttery edges
    final t = normalized;
    final smoothEdge =
        t * t * t * (t * (t * 6.0 - 15.0) + 10.0); // Perlin smootherstep

    // Blend gaussian with smoothstep for best of both
    final blended = gaussian * 0.7 + math.sin(normalized * math.pi) * 0.3;

    return blended.clamp(0.0, 1.0);
  }

  /// Check if wave has passed beyond max distance and can be removed
  bool isExpired(double currentTime, double maxDistance) {
    return getPosition(currentTime) > maxDistance + width;
  }
}

/// Manager for multiple active waves
class WaveManager {
  final List<Wave> _waves = [];
  final double maxDistance;

  WaveManager({required this.maxDistance});

  List<Wave> get waves => List.unmodifiable(_waves);

  void addWave(Wave wave) {
    _waves.add(wave);
  }

  void update(double currentTime) {
    _waves.removeWhere((wave) => wave.isExpired(currentTime, maxDistance));
  }

  void clear() {
    _waves.clear();
  }

  /// Get combined intensity at a point (max of all waves)
  double getIntensityAtDistance(double distance, double currentTime) {
    double maxIntensity = 0.0;
    for (final wave in _waves) {
      final intensity = wave.getIntensityAtDistance(distance, currentTime);
      if (intensity > maxIntensity) {
        maxIntensity = intensity;
      }
    }
    return maxIntensity;
  }
}
