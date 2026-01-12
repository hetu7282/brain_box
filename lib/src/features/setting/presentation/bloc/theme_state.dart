import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/services/theme_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final AppThemeMode mode;
  final LinearGradient gradient;
  final Color? splashLogoColor;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Color? textOnboardingColor;
  final Color? textOnboardingSubtitleColor;
  final Color? textOnboardingBackgroundColor;
  final Color? textOnboardingBorderColor;
  final Color? btnColor;
  final List<Color> gradientColors; // gradient colors for home screen
  final List<Color> gradientColors2; // gradient colors for home screen
  final String? bgImage;
  final String? noInternetImage;
  final Color? appBarIconBackgroundColor;
  final Color? appBarTitleColor;
  final Color? settingIconBackgroundColor;
  final Color? settingCustomContainerColor;
  final Color? settingCustomContainerBorderColor;
  final Color? settingCustomContainerShadowColor;
  final Color? ticTacTwistColor;
  final Color? difficultyButtonColor;
  final Color? jigsawPainterBackgroundBorderColor;
  final Color? lostedPlayerBackgroundColor;
  final Color? lostedPlayerBorderColor;
  final Color? lostedPlayerShadowColor;
  const ThemeState({
    required this.mode,
    required this.gradient,
    required this.splashLogoColor,
    required this.bgImage,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.textOnboardingColor,
    required this.textOnboardingSubtitleColor,
    required this.textOnboardingBackgroundColor,
    required this.textOnboardingBorderColor,
    required this.btnColor,
    required this.gradientColors,
    required this.gradientColors2,
    required this.appBarIconBackgroundColor,
    required this.appBarTitleColor,
    required this.settingIconBackgroundColor,
    required this.settingCustomContainerColor,
    required this.settingCustomContainerBorderColor,
    required this.settingCustomContainerShadowColor,
    required this.ticTacTwistColor,
    required this.difficultyButtonColor,
    required this.jigsawPainterBackgroundBorderColor,
    required this.lostedPlayerBackgroundColor,
    required this.lostedPlayerBorderColor,
    required this.lostedPlayerShadowColor,
    required this.noInternetImage,
  });

  factory ThemeState.initial() => ThemeState(
    textOnboardingSubtitleColor: AppColor.white,
    textOnboardingBackgroundColor: AppColor.white,
    mode: AppThemeMode.light,
    gradient: AppColor.lightGradient,
    splashLogoColor: null,
    bgImage: Assets.assetsImageThemeBgDefult,
    noInternetImage: Assets.assetsImageNoInternetNoInternetDefault,
    iconBackgroundColor: AppColor.primary,
    iconColor: AppColor.white,
    textOnboardingColor: AppColor.white,
    textOnboardingBorderColor: AppColor.white,
    btnColor: AppColor.primary,
    gradientColors: [AppColor.k1A2A4A, AppColor.k152440],
    gradientColors2: [AppColor.k1A2A4A, AppColor.k152440],
    appBarIconBackgroundColor: AppColor.primary,
    appBarTitleColor: AppColor.white,
    settingIconBackgroundColor: AppColor.primary,
    settingCustomContainerColor: AppColor.primary,
    settingCustomContainerBorderColor: AppColor.primary,
    settingCustomContainerShadowColor: AppColor.primary,
    ticTacTwistColor: AppColor.primary,
    difficultyButtonColor: AppColor.primary,
    jigsawPainterBackgroundBorderColor: AppColor.primary,
    lostedPlayerBackgroundColor: AppColor.primary,
    lostedPlayerBorderColor: AppColor.primary,
    lostedPlayerShadowColor: AppColor.primary,
  );

  ThemeState copyWith({
    AppThemeMode? mode,
    LinearGradient? gradient,
    Color? splashLogoColor,
    String? bgImage,
    Color? iconBackgroundColor,
    Color? iconColor,
    Color? textOnboardingColor,
    Color? textOnboardingSubtitleColor,
    Color? textOnboardingBackgroundColor,
    Color? textOnboardingBorderColor,
    Color? btnColor,
    List<Color>? gradientColors,
    List<Color>? gradientColors2,
    Color? appBarIconBackgroundColor,
    Color? appBarTitleColor,
    Color? settingIconBackgroundColor,
    Color? settingCustomContainerColor,
    Color? settingCustomContainerBorderColor,
    Color? settingCustomContainerShadowColor,
    Color? ticTacTwistColor,
    Color? difficultyButtonColor,
    Color? jigsawPainterBackgroundBorderColor,
    Color? lostedPlayerBackgroundColor, // for kings gambit
    Color? lostedPlayerBorderColor, // for kings gambit
    Color? lostedPlayerShadowColor, // for kings gambit
    String? noInternetImage,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      gradient: gradient ?? this.gradient,
      splashLogoColor: splashLogoColor ?? this.splashLogoColor,
      bgImage: bgImage ?? this.bgImage,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      iconColor: iconColor ?? this.iconColor,
      textOnboardingColor: textOnboardingColor ?? this.textOnboardingColor,
      textOnboardingSubtitleColor:
          textOnboardingSubtitleColor ?? this.textOnboardingSubtitleColor,
      textOnboardingBackgroundColor:
          textOnboardingBackgroundColor ?? this.textOnboardingBackgroundColor,
      textOnboardingBorderColor:
          textOnboardingBorderColor ?? this.textOnboardingBorderColor,
      btnColor: btnColor ?? this.btnColor,
      gradientColors: gradientColors ?? this.gradientColors,
      gradientColors2: gradientColors2 ?? this.gradientColors2,
      appBarIconBackgroundColor:
          appBarIconBackgroundColor ?? this.appBarIconBackgroundColor,
      appBarTitleColor: appBarTitleColor ?? this.appBarTitleColor,
      settingIconBackgroundColor:
          settingIconBackgroundColor ?? this.settingIconBackgroundColor,
      settingCustomContainerColor:
          settingCustomContainerColor ?? this.settingCustomContainerColor,
      settingCustomContainerBorderColor:
          settingCustomContainerBorderColor ??
          this.settingCustomContainerBorderColor,
      settingCustomContainerShadowColor:
          settingCustomContainerShadowColor ??
          this.settingCustomContainerShadowColor,
      ticTacTwistColor: ticTacTwistColor ?? this.ticTacTwistColor,
      difficultyButtonColor:
          difficultyButtonColor ?? this.difficultyButtonColor,
      jigsawPainterBackgroundBorderColor:
          jigsawPainterBackgroundBorderColor ??
          this.jigsawPainterBackgroundBorderColor,
      lostedPlayerBackgroundColor:
          lostedPlayerBackgroundColor ?? this.lostedPlayerBackgroundColor,
      lostedPlayerBorderColor:
          lostedPlayerBorderColor ?? this.lostedPlayerBorderColor,
      lostedPlayerShadowColor:
          lostedPlayerShadowColor ?? this.lostedPlayerShadowColor,
      noInternetImage: noInternetImage ?? this.noInternetImage,
    );
  }

  @override
  List<Object?> get props => [
    mode,
    gradient,
    splashLogoColor,
    bgImage,
    iconBackgroundColor,
    iconColor,
    textOnboardingColor,
    textOnboardingSubtitleColor,
    textOnboardingBackgroundColor,
    textOnboardingBorderColor,
    btnColor,
    gradientColors,
    gradientColors2,
    appBarIconBackgroundColor,
    appBarTitleColor,
    settingIconBackgroundColor,
    settingCustomContainerColor,
    settingCustomContainerBorderColor,
    settingCustomContainerShadowColor,
    ticTacTwistColor,
    difficultyButtonColor,
    jigsawPainterBackgroundBorderColor,
    lostedPlayerBackgroundColor,
    lostedPlayerBorderColor,
    lostedPlayerShadowColor,
    noInternetImage,
  ];
}
