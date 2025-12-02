
import '../../../exports.dart';

// Define FontFamily if not already defined in exports.dart
class FontFamily {
  // ignore: constant_identifier_names
  static const String Montserrat = 'Montserrat';
}


class AppText extends Text {
  final Color? color;
  final FontWeight? fontWeight;
  final double? height;
  final double? letterSpacing;
  final double fontSize;

  AppText.small(super.data,
      {super.key,
      this.color = ColorName.blackColor,
      this.fontWeight = FontWeight.normal,
      super.textAlign = TextAlign.justify,
      int? maxLine,
      TextOverflow? textOverflow,
      this.height,
      this.letterSpacing,
      this.fontSize = 12})
      : super(
          maxLines: maxLine,
          style: TextStyle(
              fontFamily: FontFamily.Montserrat,
              fontSize: fontSize,
              color: color,
              height: height,
              fontWeight: fontWeight,
              overflow: textOverflow,
              letterSpacing: letterSpacing),
        );

  AppText.medium(
    super.data, {
    super.key,
    this.color = ColorName.blackColor,
    this.fontWeight = FontWeight.w600,
    super.textAlign = TextAlign.justify,
    int? maxLine,
    TextOverflow? textOverflow,
    this.height,
    this.letterSpacing,
    this.fontSize = 14,
    TextDecoration textDecoration = TextDecoration.none,
  }) : super(
          maxLines: maxLine,
          style: TextStyle(
              fontFamily: FontFamily.Montserrat,
              fontSize: fontSize,
              color: color,
              height: height,
              fontWeight: fontWeight,
              overflow: textOverflow,
              letterSpacing: letterSpacing),
        );

  AppText.large(
    super.data, {
    super.key,
    this.color = ColorName.blackColor,
    this.fontWeight = FontWeight.bold,
    super.textAlign = TextAlign.justify,
    int? maxLine,
    TextOverflow? textOverflow,
    this.height,
    this.letterSpacing,
    this.fontSize = 24,
  }) : super(
          maxLines: maxLine,
          style: TextStyle(
              fontFamily: FontFamily.Montserrat,
              fontSize: fontSize,
              color: color,
              height: height,
              fontWeight: fontWeight,
              overflow: textOverflow,
              letterSpacing: letterSpacing),
        );
}

class AppTextSpan extends TextSpan {
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final double? height;
  final double? letterSpacing;
  final double fontSize;

  AppTextSpan.large(String data, {
    this.color = ColorName.blackColor,
    this.fontWeight = FontWeight.bold,
    this.textAlign,
    this.height,
    this.fontSize = 24,
    this.letterSpacing,
    super.recognizer
  }) : super(
    text: data,
    style: TextStyle(
      fontFamily: FontFamily.Montserrat,
      fontSize: fontSize,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
    ),
  );

  AppTextSpan.medium(String data, {
    this.color = ColorName.blackColor,
    this.fontWeight = FontWeight.w600,
    this.textAlign,
    this.height,
    this.fontSize = 14,
    this.letterSpacing,
    TextDecoration textDecoration = TextDecoration.none,
    super.recognizer
  }) : super(
    text: data,
    style: TextStyle(
      fontFamily: FontFamily.Montserrat,
      fontSize: fontSize,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
    ),
  );

  AppTextSpan.small(String data, {
    this.color = ColorName.blackColor,
    this.fontWeight = FontWeight.w600,
    this.textAlign,
    this.height,
    this.fontSize = 12,
    this.letterSpacing,
    TextDecoration textDecoration = TextDecoration.none,
    super.recognizer
  }) : super(
    text: data,
    style: TextStyle(
      fontFamily: FontFamily.Montserrat,
      fontSize: fontSize,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
    ),
  );
}
