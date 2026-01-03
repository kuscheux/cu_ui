import 'dart:typed_data';
import 'dart:math' as math;

/// Particle shape types
enum ParticleShape {
  circle,
  triangle,
  square,
  diamond,
}

/// High-performance particle grid using Float32List for SIMD-friendly memory layout
/// Each particle has 12 floats for truly independent behavior
class ParticleGrid {
  static const int stride = 12;
  static const int xOffset = 0;
  static const int yOffset = 1;
  static const int opacityOffset = 2;
  static const int targetOpacityOffset = 3;
  static const int sizeOffset = 4;
  static const int targetSizeOffset = 5;
  static const int scaleOffset = 6;
  static const int targetScaleOffset = 7;
  static const int baseSizeOffset = 8; // Unique random base size for each particle
  static const int breathingPhaseOffset = 9; // Random phase offset
  static const int breathingSpeedOffset = 10; // Random breathing speed per particle
  static const int breathingAmplitudeOffset = 11; // Random breathing amplitude per particle

  final Float32List data;
  final int cols;
  final int rows;
  final double spacing;
  final double offsetX;
  final double offsetY;
  final math.Random _random = math.Random();

  int get particleCount => cols * rows;

  ParticleGrid({
    required this.cols,
    required this.rows,
    required this.spacing,
    required this.offsetX,
    required this.offsetY,
    double minSize = 1.0,
    double maxSize = 3.5,
  }) : data = Float32List(cols * rows * stride) {
    _initialize(minSize, maxSize);
  }

  /// Factory to create grid that fits a given size
  factory ParticleGrid.fitToSize({
    required double width,
    required double height,
    double spacing = 8.0,
    double minSize = 1.5, // Not too tiny (prevents glitching)
    double maxSize = 4.0, // Larger dots
  }) {
    final cols = (width / spacing).floor();
    final rows = (height / spacing).floor();
    final gridWidth = (cols - 1) * spacing;
    final gridHeight = (rows - 1) * spacing;
    final offsetX = (width - gridWidth) / 2;
    final offsetY = (height - gridHeight) / 2;

    return ParticleGrid(
      cols: cols,
      rows: rows,
      spacing: spacing,
      offsetX: offsetX,
      offsetY: offsetY,
      minSize: minSize,
      maxSize: maxSize,
    );
  }

  void _initialize(double minSize, double maxSize) {
    final sizeRange = maxSize - minSize;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final index = row * cols + col;
        final baseIndex = index * stride;

        // Position
        data[baseIndex + xOffset] = offsetX + col * spacing;
        data[baseIndex + yOffset] = offsetY + row * spacing;

        // Opacity (start dim)
        data[baseIndex + opacityOffset] = 0.08;
        data[baseIndex + targetOpacityOffset] = 0.08;

        // Random base size - use non-linear distribution for more variety
        // Some particles tiny, some medium, fewer large
        final sizeRandom = _random.nextDouble();
        final skewedSize = sizeRandom * sizeRandom; // Skew towards smaller
        final particleBaseSize = minSize + skewedSize * sizeRange;
        data[baseIndex + baseSizeOffset] = particleBaseSize;

        // Random breathing phase (0 to 2*PI)
        data[baseIndex + breathingPhaseOffset] =
            _random.nextDouble() * 2 * math.pi;

        // Random breathing speed (0.3 to 1.2) - each particle breathes at different rate
        data[baseIndex + breathingSpeedOffset] = 0.3 + _random.nextDouble() * 0.9;

        // Random breathing amplitude (0.1 to 0.4) - each particle fluctuates different amount
        data[baseIndex + breathingAmplitudeOffset] =
            0.1 + _random.nextDouble() * 0.3;

        // Current size starts at base
        data[baseIndex + sizeOffset] = particleBaseSize;
        data[baseIndex + targetSizeOffset] = particleBaseSize;

        // Scale
        data[baseIndex + scaleOffset] = 1.0;
        data[baseIndex + targetScaleOffset] = 1.0;
      }
    }
  }

  // Getters
  double getX(int index) => data[index * stride + xOffset];
  double getY(int index) => data[index * stride + yOffset];
  double getOpacity(int index) => data[index * stride + opacityOffset];
  double getTargetOpacity(int index) =>
      data[index * stride + targetOpacityOffset];
  double getSize(int index) => data[index * stride + sizeOffset];
  double getTargetSize(int index) => data[index * stride + targetSizeOffset];
  double getScale(int index) => data[index * stride + scaleOffset];
  double getTargetScale(int index) => data[index * stride + targetScaleOffset];
  double getBaseSize(int index) => data[index * stride + baseSizeOffset];
  double getBreathingPhase(int index) =>
      data[index * stride + breathingPhaseOffset];
  double getBreathingSpeed(int index) =>
      data[index * stride + breathingSpeedOffset];
  double getBreathingAmplitude(int index) =>
      data[index * stride + breathingAmplitudeOffset];

  /// Calculate breathing multiplier for a particle at given time
  /// Each particle has its own speed, phase, and amplitude for truly independent fluctuation
  double getBreathingMultiplier(int index, double time) {
    final phase = getBreathingPhase(index);
    final speed = getBreathingSpeed(index);
    final amplitude = getBreathingAmplitude(index);

    // Each particle breathes at its own rate
    final breathCycle = math.sin(time * speed * math.pi + phase);
    // Use particle's own amplitude for unique fluctuation range
    return 1.0 + breathCycle * amplitude;
  }

  /// Calculate breathing opacity adjustment for a particle
  /// Each particle fluctuates opacity independently
  double getBreathingOpacity(int index, double time) {
    final phase = getBreathingPhase(index);
    final speed = getBreathingSpeed(index);
    final amplitude = getBreathingAmplitude(index);

    // Slightly offset from size breathing for organic feel
    final breathCycle = math.sin(time * speed * math.pi + phase + 0.7);
    // Scale opacity fluctuation to particle's amplitude
    return breathCycle * amplitude * 0.3;
  }

  // Setters
  void setOpacity(int index, double value) {
    data[index * stride + opacityOffset] = value.clamp(0.0, 1.0);
  }

  void setTargetOpacity(int index, double value) {
    data[index * stride + targetOpacityOffset] = value.clamp(0.0, 1.0);
  }

  void setSize(int index, double value) {
    data[index * stride + sizeOffset] = value;
  }

  void setTargetSize(int index, double value) {
    data[index * stride + targetSizeOffset] = value;
  }

  void setScale(int index, double value) {
    data[index * stride + scaleOffset] = value;
  }

  void setTargetScale(int index, double value) {
    data[index * stride + targetScaleOffset] = value;
  }

  /// Get particle index from grid position
  int getIndex(int col, int row) => row * cols + col;

  /// Get grid position from index
  (int col, int row) getGridPosition(int index) {
    return (index % cols, index ~/ cols);
  }

  /// Get center of grid
  (double x, double y) get center {
    return (
      offsetX + (cols - 1) * spacing / 2,
      offsetY + (rows - 1) * spacing / 2,
    );
  }

  /// Calculate distance from particle to a point
  double distanceToPoint(int index, double px, double py) {
    final x = getX(index);
    final y = getY(index);
    return math.sqrt((x - px) * (x - px) + (y - py) * (y - py));
  }

  /// Lerp all particles towards their targets
  void lerpToTargets(double speed) {
    for (int i = 0; i < particleCount; i++) {
      final baseIndex = i * stride;

      // Lerp opacity
      final opacity = data[baseIndex + opacityOffset];
      final targetOpacity = data[baseIndex + targetOpacityOffset];
      data[baseIndex + opacityOffset] =
          opacity + (targetOpacity - opacity) * speed;

      // Lerp size
      final size = data[baseIndex + sizeOffset];
      final targetSize = data[baseIndex + targetSizeOffset];
      data[baseIndex + sizeOffset] = size + (targetSize - size) * speed;

      // Lerp scale
      final scale = data[baseIndex + scaleOffset];
      final targetScale = data[baseIndex + targetScaleOffset];
      data[baseIndex + scaleOffset] = scale + (targetScale - scale) * speed;
    }
  }

  /// Reset all particles to their individual base state
  void reset({double baseOpacity = 0.15}) {
    for (int i = 0; i < particleCount; i++) {
      final particleBaseSize = getBaseSize(i);
      setOpacity(i, baseOpacity);
      setTargetOpacity(i, baseOpacity);
      setSize(i, particleBaseSize);
      setTargetSize(i, particleBaseSize);
      setScale(i, 1.0);
      setTargetScale(i, 1.0);
    }
  }
}
