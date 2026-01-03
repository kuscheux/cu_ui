import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import '../../theme/cu_theme.dart';
import '../_base/cu_component.dart';

/// Text element types
enum CuTextElement {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  p,
  b,
  small,
  i,
  span,
  del,
  em,
  blockquote,
}

/// CU UI Text Component
/// Flexible text with various element types and variants
class CuText extends StatelessWidget {
  final String text;
  final CuTextElement element;
  final CuVariant? type;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  const CuText(
    this.text, {
    super.key,
    this.element = CuTextElement.p,
    this.type,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  /// Heading 1
  const CuText.h1(
    this.text, {
    super.key,
    this.type,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : element = CuTextElement.h1;

  /// Heading 2
  const CuText.h2(
    this.text, {
    super.key,
    this.type,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : element = CuTextElement.h2;

  /// Heading 3
  const CuText.h3(
    this.text, {
    super.key,
    this.type,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : element = CuTextElement.h3;

  /// Heading 4
  const CuText.h4(
    this.text, {
    super.key,
    this.type,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : element = CuTextElement.h4;

  /// Heading 5
  const CuText.h5(
    this.text, {
    super.key,
    this.type,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : element = CuTextElement.h5;

  /// Heading 6
  const CuText.h6(
    this.text, {
    super.key,
    this.type,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : element = CuTextElement.h6;

  /// Paragraph
  const CuText.p(
    this.text, {
    super.key,
    this.type,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : element = CuTextElement.p;

  /// Bold
  const CuText.b(
    this.text, {
    super.key,
    this.type,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : element = CuTextElement.b;

  /// Small
  const CuText.small(
    this.text, {
    super.key,
    this.type,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : element = CuTextElement.small;

  /// Italic
  const CuText.i(
    this.text, {
    super.key,
    this.type,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : element = CuTextElement.i;

  /// Span
  const CuText.span(
    this.text, {
    super.key,
    this.type,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : element = CuTextElement.span;

  /// Deleted (strikethrough)
  const CuText.del(
    this.text, {
    super.key,
    this.type,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : element = CuTextElement.del;

  /// Emphasis
  const CuText.em(
    this.text, {
    super.key,
    this.type,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : element = CuTextElement.em;

  /// Blockquote
  const CuText.blockquote(
    this.text, {
    super.key,
    this.type,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : element = CuTextElement.blockquote;

  @override
  Widget build(BuildContext context) {
    final typography = context.cuTypography;
    final colors = context.cuColors;
    final spacing = context.cuSpacing;

    TextStyle baseStyle = _getBaseStyle(typography);
    Color textColor = _getTextColor(colors);

    final finalStyle = baseStyle.copyWith(color: textColor).merge(style);

    if (element == CuTextElement.blockquote) {
      return Container(
        padding: EdgeInsets.only(left: spacing.space4),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: colors.border,
              width: 3,
            ),
          ),
        ),
        child: Text(
          text,
          style: finalStyle.copyWith(
            color: colors.accents5,
            fontStyle: FontStyle.italic,
          ),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
        ),
      );
    }

    return Text(
      text,
      style: finalStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  TextStyle _getBaseStyle(CuTypographyTokens typography) {
    switch (element) {
      case CuTextElement.h1:
        return typography.h1;
      case CuTextElement.h2:
        return typography.h2;
      case CuTextElement.h3:
        return typography.h3;
      case CuTextElement.h4:
        return typography.h4;
      case CuTextElement.h5:
        return typography.h5;
      case CuTextElement.h6:
        return typography.h6;
      case CuTextElement.p:
        return typography.body;
      case CuTextElement.b:
        return typography.body.copyWith(fontWeight: FontWeight.bold);
      case CuTextElement.small:
        return typography.caption;
      case CuTextElement.i:
        return typography.body.copyWith(fontStyle: FontStyle.italic);
      case CuTextElement.span:
        return typography.body;
      case CuTextElement.del:
        return typography.body.copyWith(decoration: TextDecoration.lineThrough);
      case CuTextElement.em:
        return typography.body.copyWith(fontStyle: FontStyle.italic);
      case CuTextElement.blockquote:
        return typography.body;
    }
  }

  Color _getTextColor(CuColorTokens colors) {
    if (type == null) {
      switch (element) {
        case CuTextElement.h1:
        case CuTextElement.h2:
        case CuTextElement.h3:
        case CuTextElement.h4:
        case CuTextElement.h5:
        case CuTextElement.h6:
        case CuTextElement.b:
          return colors.foreground;
        case CuTextElement.p:
        case CuTextElement.span:
        case CuTextElement.i:
        case CuTextElement.em:
        case CuTextElement.del:
          return colors.accents6;
        case CuTextElement.small:
        case CuTextElement.blockquote:
          return colors.accents5;
      }
    }

    return type!.resolveColor(colors);
  }
}
