import 'package:flutter/widgets.dart';

/// CU UI Shadow/Elevation Tokens
@immutable
class CuShadowTokens {
  final BoxShadow small;
  final BoxShadow medium;
  final BoxShadow large;
  final BoxShadow hover;
  final BoxShadow dropdown;

  const CuShadowTokens({
    required this.small,
    required this.medium,
    required this.large,
    required this.hover,
    required this.dropdown,
  });

  // ============================================
  // LIST HELPERS
  // ============================================
  List<BoxShadow> get smallList => [small];
  List<BoxShadow> get mediumList => [medium];
  List<BoxShadow> get largeList => [large];
  List<BoxShadow> get hoverList => [hover];
  List<BoxShadow> get dropdownList => [dropdown];

  CuShadowTokens copyWith({
    BoxShadow? small,
    BoxShadow? medium,
    BoxShadow? large,
    BoxShadow? hover,
    BoxShadow? dropdown,
  }) {
    return CuShadowTokens(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      hover: hover ?? this.hover,
      dropdown: dropdown ?? this.dropdown,
    );
  }
}

/// Light theme shadows
const lightShadowTokens = CuShadowTokens(
  small: BoxShadow(
    color: Color(0x1F000000), // rgba(0,0,0,0.12)
    blurRadius: 10,
    offset: Offset(0, 5),
  ),
  medium: BoxShadow(
    color: Color(0x1F000000), // rgba(0,0,0,0.12)
    blurRadius: 30,
    offset: Offset(0, 8),
  ),
  large: BoxShadow(
    color: Color(0x1F000000), // rgba(0,0,0,0.12)
    blurRadius: 60,
    offset: Offset(0, 30),
  ),
  hover: BoxShadow(
    color: Color(0x33000000), // rgba(0,0,0,0.2)
    blurRadius: 30,
    offset: Offset(0, 8),
  ),
  dropdown: BoxShadow(
    color: Color(0x05000000), // rgba(0,0,0,0.02)
    blurRadius: 4,
    offset: Offset(0, 4),
  ),
);

/// Dark theme shadows (use borders instead of soft shadows)
const darkShadowTokens = CuShadowTokens(
  small: BoxShadow(
    color: Color(0xFF333333),
    blurRadius: 0,
    spreadRadius: 1,
    offset: Offset.zero,
  ),
  medium: BoxShadow(
    color: Color(0xFF333333),
    blurRadius: 0,
    spreadRadius: 1,
    offset: Offset.zero,
  ),
  large: BoxShadow(
    color: Color(0xFF333333),
    blurRadius: 0,
    spreadRadius: 1,
    offset: Offset.zero,
  ),
  hover: BoxShadow(
    color: Color(0xFF444444),
    blurRadius: 0,
    spreadRadius: 1,
    offset: Offset.zero,
  ),
  dropdown: BoxShadow(
    color: Color(0xFF333333),
    blurRadius: 0,
    spreadRadius: 1,
    offset: Offset.zero,
  ),
);
