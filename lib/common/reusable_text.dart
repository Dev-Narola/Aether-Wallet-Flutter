// ignore_for_file: must_be_immutable, depend_on_referenced_packages, camel_case_types

import 'package:aether_wallet/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ReusableText extends StatelessWidget {
  final String text;
  double? fontSize;
  FontWeight? fontWeight;
  Color? color;
  String? fontFamily;
  double? letterSpace;
  double? wordSpace;
  int? maxLines;

  ReusableText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.fontFamily,
    this.letterSpace,
    this.wordSpace,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? headingText,
        fontSize: fontSize ?? 16.sp,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontFamily: fontFamily ?? 'Kingred',
        letterSpacing: letterSpace ?? 0,
        wordSpacing: wordSpace ?? 0,
      ),
      maxLines: maxLines ?? 2,
    );
  }
}

class typeWriterAnimatedText extends StatelessWidget {
  final String text;
  double? fontSize;
  FontWeight? fontWeight;
  Color? color;
  String? fontFamily;
  double? letterSpace;
  typeWriterAnimatedText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.fontFamily,
    this.letterSpace,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          text,
          textStyle: TextStyle(
              color: color ?? normalText,
              fontSize: fontSize ?? 12.sp,
              fontWeight: fontWeight ?? FontWeight.normal,
              letterSpacing: letterSpace ?? 1,
              fontFamily: 'Kingred'),
          speed: const Duration(milliseconds: 100),
        ),
      ],
      repeatForever: false,
      isRepeatingAnimation: false,
    );
  }
}
