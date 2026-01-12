import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    fontFamily: AppString.fontFamily,
    scaffoldBackgroundColor: AppColor.white,
    primaryColor: AppColor.primary,
    primarySwatch: AppMaterialColor.primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.primary,
      surface: AppColor.white,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      surfaceTintColor: AppColor.transparent,
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: Color(0xFFFFFFFF),
      dialHandColor: AppColor.primary,
      hourMinuteShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      dialTextColor: Color(0xFF333333),
      timeSelectorSeparatorColor: WidgetStateProperty.all(Color(0xFF333333)),
      dayPeriodColor: AppColor.primary,
      dayPeriodTextColor: Color(0xFF333333),
      dialTextStyle: TextStyle(fontSize: 20.px, color: Color(0xFF333333)),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColor.primary),
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColor.primary),
      ),
    ),
  );
}
