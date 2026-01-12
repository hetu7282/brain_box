import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  // final String? fontFamily;
  final int? maxLines;
  final double? height;
  final TextOverflow? textOverFlow;
  final TextDecoration? decoration;
  final TextOverflow? overflow;
  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight = FontWeight.w500,
    this.textAlign,
    // this.fontFamily,
    this.maxLines,
    this.height,
    this.textOverFlow,
    this.decoration,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        overflow: textOverFlow,
        height: height ?? 0,
        fontFamily: AppString.fontFamily,
        fontSize: fontSize ?? 16.sp,
        color: color ?? AppColor.black,
        fontWeight: fontWeight,
        decoration: decoration,
      ),
      overflow: overflow,
    );
  }
}
