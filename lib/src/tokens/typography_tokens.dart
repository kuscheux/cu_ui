import 'package:flutter/widgets.dart';

/// CU UI Typography Token System
@immutable
class CuTypographyTokens {
  // ============================================
  // FONT FAMILIES
  // ============================================
  final String fontSans; // Geist for body text
  final String fontMono; // GeistMono for code

  // ============================================
  // FONT SIZES (rem-based, 16px base)
  // ============================================
  final double fontSize10; // 0.625rem = 10px (labels)
  final double fontSize12; // 0.75rem = 12px (caption)
  final double fontSize14; // 0.875rem = 14px (body small)
  final double fontSize16; // 1rem = 16px (body)
  final double fontSize18; // 1.125rem = 18px (body large)
  final double fontSize20; // 1.25rem = 20px (h4)
  final double fontSize24; // 1.5rem = 24px (h3)
  final double fontSize36; // 2.25rem = 36px (h2)
  final double fontSize48; // 3rem = 48px (h1)
  final double fontSize72; // 4.5rem = 72px (display)

  // ============================================
  // FONT WEIGHTS
  // ============================================
  final FontWeight weightLight; // 300
  final FontWeight weightRegular; // 400
  final FontWeight weightMedium; // 500
  final FontWeight weightSemibold; // 600
  final FontWeight weightBold; // 700

  // ============================================
  // LINE HEIGHTS
  // ============================================
  final double lineHeightTight; // 1.25
  final double lineHeightNormal; // 1.5
  final double lineHeightRelaxed; // 1.625
  final double lineHeightLoose; // 2.0

  // ============================================
  // LETTER SPACING
  // ============================================
  final double letterSpacingTight; // -0.05em
  final double letterSpacingNormal; // 0
  final double letterSpacingWide; // 0.05em
  final double letterSpacingWider; // 0.1em

  const CuTypographyTokens({
    this.fontSans = 'Geist',
    this.fontMono = 'GeistMono',
    this.fontSize10 = 10.0,
    this.fontSize12 = 12.0,
    this.fontSize14 = 14.0,
    this.fontSize16 = 16.0,
    this.fontSize18 = 18.0,
    this.fontSize20 = 20.0,
    this.fontSize24 = 24.0,
    this.fontSize36 = 36.0,
    this.fontSize48 = 48.0,
    this.fontSize72 = 72.0,
    this.weightLight = FontWeight.w300,
    this.weightRegular = FontWeight.w400,
    this.weightMedium = FontWeight.w500,
    this.weightSemibold = FontWeight.w600,
    this.weightBold = FontWeight.w700,
    this.lineHeightTight = 1.25,
    this.lineHeightNormal = 1.5,
    this.lineHeightRelaxed = 1.625,
    this.lineHeightLoose = 2.0,
    this.letterSpacingTight = -0.8,
    this.letterSpacingNormal = 0.0,
    this.letterSpacingWide = 0.8,
    this.letterSpacingWider = 1.6,
  });

  // ============================================
  // PREDEFINED TEXT STYLES
  // ============================================

  TextStyle get display => TextStyle(
        fontFamily: fontSans,
        fontSize: fontSize72,
        fontWeight: weightBold,
        height: lineHeightTight,
        letterSpacing: letterSpacingTight,
      );

  TextStyle get h1 => TextStyle(
        fontFamily: fontSans,
        fontSize: fontSize48,
        fontWeight: weightBold,
        height: lineHeightTight,
        letterSpacing: letterSpacingTight,
      );

  TextStyle get h2 => TextStyle(
        fontFamily: fontSans,
        fontSize: fontSize36,
        fontWeight: weightSemibold,
        height: lineHeightTight,
      );

  TextStyle get h3 => TextStyle(
        fontFamily: fontSans,
        fontSize: fontSize24,
        fontWeight: weightSemibold,
        height: lineHeightNormal,
      );

  TextStyle get h4 => TextStyle(
        fontFamily: fontSans,
        fontSize: fontSize20,
        fontWeight: weightMedium,
        height: lineHeightNormal,
      );

  TextStyle get h5 => TextStyle(
        fontFamily: fontSans,
        fontSize: fontSize18,
        fontWeight: weightMedium,
        height: lineHeightNormal,
      );

  TextStyle get h6 => TextStyle(
        fontFamily: fontSans,
        fontSize: fontSize16,
        fontWeight: weightMedium,
        height: lineHeightNormal,
      );

  TextStyle get body => TextStyle(
        fontFamily: fontSans,
        fontSize: fontSize16,
        fontWeight: weightRegular,
        height: lineHeightRelaxed,
      );

  TextStyle get bodyLarge => TextStyle(
        fontFamily: fontSans,
        fontSize: fontSize18,
        fontWeight: weightRegular,
        height: lineHeightRelaxed,
      );

  TextStyle get bodySmall => TextStyle(
        fontFamily: fontSans,
        fontSize: fontSize14,
        fontWeight: weightRegular,
        height: lineHeightNormal,
      );

  TextStyle get caption => TextStyle(
        fontFamily: fontSans,
        fontSize: fontSize12,
        fontWeight: weightRegular,
        height: lineHeightNormal,
      );

  TextStyle get label => TextStyle(
        fontFamily: fontSans,
        fontSize: fontSize10,
        fontWeight: weightMedium,
        height: lineHeightNormal,
        letterSpacing: letterSpacingWide,
      );

  TextStyle get labelLarge => TextStyle(
        fontFamily: fontSans,
        fontSize: fontSize12,
        fontWeight: weightMedium,
        height: lineHeightNormal,
        letterSpacing: letterSpacingWide,
      );

  TextStyle get code => TextStyle(
        fontFamily: fontMono,
        fontSize: fontSize14,
        fontWeight: weightRegular,
        height: lineHeightNormal,
      );

  TextStyle get codeSmall => TextStyle(
        fontFamily: fontMono,
        fontSize: fontSize12,
        fontWeight: weightRegular,
        height: lineHeightNormal,
      );

  TextStyle get codeLarge => TextStyle(
        fontFamily: fontMono,
        fontSize: fontSize16,
        fontWeight: weightRegular,
        height: lineHeightNormal,
      );

  CuTypographyTokens copyWith({
    String? fontSans,
    String? fontMono,
    double? fontSize10,
    double? fontSize12,
    double? fontSize14,
    double? fontSize16,
    double? fontSize18,
    double? fontSize20,
    double? fontSize24,
    double? fontSize36,
    double? fontSize48,
    double? fontSize72,
    FontWeight? weightLight,
    FontWeight? weightRegular,
    FontWeight? weightMedium,
    FontWeight? weightSemibold,
    FontWeight? weightBold,
    double? lineHeightTight,
    double? lineHeightNormal,
    double? lineHeightRelaxed,
    double? lineHeightLoose,
    double? letterSpacingTight,
    double? letterSpacingNormal,
    double? letterSpacingWide,
    double? letterSpacingWider,
  }) {
    return CuTypographyTokens(
      fontSans: fontSans ?? this.fontSans,
      fontMono: fontMono ?? this.fontMono,
      fontSize10: fontSize10 ?? this.fontSize10,
      fontSize12: fontSize12 ?? this.fontSize12,
      fontSize14: fontSize14 ?? this.fontSize14,
      fontSize16: fontSize16 ?? this.fontSize16,
      fontSize18: fontSize18 ?? this.fontSize18,
      fontSize20: fontSize20 ?? this.fontSize20,
      fontSize24: fontSize24 ?? this.fontSize24,
      fontSize36: fontSize36 ?? this.fontSize36,
      fontSize48: fontSize48 ?? this.fontSize48,
      fontSize72: fontSize72 ?? this.fontSize72,
      weightLight: weightLight ?? this.weightLight,
      weightRegular: weightRegular ?? this.weightRegular,
      weightMedium: weightMedium ?? this.weightMedium,
      weightSemibold: weightSemibold ?? this.weightSemibold,
      weightBold: weightBold ?? this.weightBold,
      lineHeightTight: lineHeightTight ?? this.lineHeightTight,
      lineHeightNormal: lineHeightNormal ?? this.lineHeightNormal,
      lineHeightRelaxed: lineHeightRelaxed ?? this.lineHeightRelaxed,
      lineHeightLoose: lineHeightLoose ?? this.lineHeightLoose,
      letterSpacingTight: letterSpacingTight ?? this.letterSpacingTight,
      letterSpacingNormal: letterSpacingNormal ?? this.letterSpacingNormal,
      letterSpacingWide: letterSpacingWide ?? this.letterSpacingWide,
      letterSpacingWider: letterSpacingWider ?? this.letterSpacingWider,
    );
  }
}
