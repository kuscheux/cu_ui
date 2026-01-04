/// Density modes for UI scaling
enum CuDensity {
  /// Tight/condensed - minimal spacing
  tight,
  /// Comfortable - balanced spacing (default)
  comfortable,
  /// Spacious - generous spacing
  spacious,
}

/// Density multipliers for spacing
class CuDensityTokens {
  final CuDensity density;

  const CuDensityTokens({this.density = CuDensity.comfortable});

  /// Get spacing multiplier based on density
  double get multiplier {
    switch (density) {
      case CuDensity.tight:
        return 0.75;
      case CuDensity.comfortable:
        return 1.0;
      case CuDensity.spacious:
        return 1.5;
    }
  }

  /// Scale a value by density
  double scale(double value) => value * multiplier;

  /// Get button padding multiplier
  double get buttonPadding {
    switch (density) {
      case CuDensity.tight:
        return 0.7;
      case CuDensity.comfortable:
        return 1.0;
      case CuDensity.spacious:
        return 1.4;
    }
  }

  /// Get input padding multiplier
  double get inputPadding {
    switch (density) {
      case CuDensity.tight:
        return 0.75;
      case CuDensity.comfortable:
        return 1.0;
      case CuDensity.spacious:
        return 1.35;
    }
  }

  /// Get card padding multiplier
  double get cardPadding {
    switch (density) {
      case CuDensity.tight:
        return 0.7;
      case CuDensity.comfortable:
        return 1.0;
      case CuDensity.spacious:
        return 1.5;
    }
  }

  /// Get list item height multiplier
  double get listItemHeight {
    switch (density) {
      case CuDensity.tight:
        return 0.8;
      case CuDensity.comfortable:
        return 1.0;
      case CuDensity.spacious:
        return 1.3;
    }
  }

  /// Get icon size multiplier
  double get iconSize {
    switch (density) {
      case CuDensity.tight:
        return 0.9;
      case CuDensity.comfortable:
        return 1.0;
      case CuDensity.spacious:
        return 1.15;
    }
  }

  /// Get gap/spacing multiplier
  double get gap {
    switch (density) {
      case CuDensity.tight:
        return 0.6;
      case CuDensity.comfortable:
        return 1.0;
      case CuDensity.spacious:
        return 1.6;
    }
  }

  CuDensityTokens copyWith({CuDensity? density}) {
    return CuDensityTokens(density: density ?? this.density);
  }
}
