import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';

class HeaderTextBlack extends StatelessWidget {
  const HeaderTextBlack({
    super.key,
    required this.title,
    required this.fontSize,
    this.fontWeight = FontWeight.w400,
    this.textDecoration = TextDecoration.none,
    this.overflow = TextOverflow.visible,
    this.maxLines,
    this.textAlign,
    this.decorationColor,
  });

  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final TextDecoration textDecoration;
  final TextOverflow overflow;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? decorationColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.textColor,
        decoration: textDecoration,
        decorationColor: decorationColor,
      ),
    );
  }
}

class HeaderTextPrimary extends StatelessWidget {
  const HeaderTextPrimary({
    super.key,
    required this.title,
    required this.fontSize,
    this.fontWeight = FontWeight.w400,
    this.textDecoration = TextDecoration.none,
    this.overflow = TextOverflow.visible,
    this.maxLines,
    this.textAlign,
    this.decorationColor,
  });

  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final TextDecoration textDecoration;
  final TextOverflow overflow;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? decorationColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.primaryOrange,
        decoration: textDecoration,
        decorationColor: decorationColor,
      ),
    );
  }
}

class BodyTextHint extends StatelessWidget {
  const BodyTextHint({
    super.key,
    required this.title,
    required this.fontSize,
    this.fontWeight = FontWeight.w400,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.start,
    this.maxLines,
  });

  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: AppColors.textGrey,
      ),
    );
  }
}

class BodyTextColors extends StatelessWidget {
  const BodyTextColors({
    super.key,
    required this.title,
    required this.fontSize,
    this.fontWeight = FontWeight.w400,
    required this.color,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.visible,
    this.textDecoration = TextDecoration.none,
    this.decorationColor,
    this.letterSpacing,
    this.maxLines,
  });

  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final TextDecoration textDecoration;
  final Color? decorationColor;
  final double? letterSpacing;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        decoration: textDecoration,
        decorationColor: decorationColor,
      ),
    );
  }
}

class HeaderTextWithReq extends StatelessWidget {
  const HeaderTextWithReq({super.key, required this.title, this.isReq = true});

  final String title;
  final bool isReq;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textAlign: TextAlign.start,
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor,
            ),
          ),
          TextSpan(
            text: isReq ? ' *' : '',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.primaryOrange,
            ),
          ),
        ],
      ),
    );
  }
}

class AppTextStyle {
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final Color? decorationColor;
  final TextDecoration? decoration;

  AppTextStyle({
    required this.fontSize,
    required this.fontWeight,
    this.decoration,
    this.decorationColor,
    required this.color,
  });

  TextStyle get textStyle => GoogleFonts.poppins(
    fontSize: fontSize,
    fontWeight: fontWeight,
    decoration: decoration,
    decorationColor: decorationColor,
    color: color,
  );
}
