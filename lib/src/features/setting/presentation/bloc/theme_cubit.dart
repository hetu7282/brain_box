import 'package:bloc/bloc.dart';
import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/services/theme_service.dart';
import 'package:flutter/material.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : _themeService = ThemeService(), super(ThemeState.initial()) {
    _emitCurrentTheme();
    // Listen to ThemeService changes to keep state in sync
    _themeService.addListener(_onThemeServiceChanged);
  }

  final ThemeService _themeService;

  void _onThemeServiceChanged() {
    _emitCurrentTheme();
  }

  @override
  Future<void> close() {
    _themeService.removeListener(_onThemeServiceChanged);
    return super.close();
  }

  Future<void> setTheme(AppThemeMode mode) async {
    await _themeService.setTheme(mode);
    _emitCurrentTheme();
  }

  void _emitCurrentTheme() {
    final mode = _themeService.currentTheme;
    emit(
      state.copyWith(
        mode: mode,
        gradient: _gradientForMode(mode),
        splashLogoColor: mode == AppThemeMode.defult
            ? AppColor.defaultTheme
            : mode == AppThemeMode.dark
            ? AppColor.darkTheme
            : mode == AppThemeMode.cosmic
            ? AppColor.cosmicTheme
            : mode == AppThemeMode.light
            ? AppColor.lightTheme
            : AppColor.defaultTheme,
        bgImage: mode == AppThemeMode.defult
            ? Assets.assetsImageThemeBgDefult
            : mode == AppThemeMode.dark
            ? Assets.assetsImageThemeBgDark
            : mode == AppThemeMode.cosmic
            ? Assets.assetsImageThemeBgCosmic
            : mode == AppThemeMode.light
            ? Assets.assetsImageThemeBgLight
            : Assets.assetsImageThemeBgDefult,
        iconBackgroundColor: mode == AppThemeMode.defult
            ? AppColor.k152440
            : mode == AppThemeMode.dark
            ? const Color(0xFFBBB8C5)
            : mode == AppThemeMode.cosmic
            ? const Color.fromARGB(255, 5, 59, 73)
            : mode == AppThemeMode.light
            ? AppColor.white
            : AppColor.defaultTheme,
        iconColor: mode == AppThemeMode.defult
            ? AppColor.defaultTheme
            : mode == AppThemeMode.dark
            ? AppColor.darkTheme
            : mode == AppThemeMode.cosmic
            ? AppColor.cosmicTheme
            : mode == AppThemeMode.light
            ? AppColor.lightTheme
            : AppColor.defaultTheme,
        textOnboardingColor: AppColor.white,
        textOnboardingSubtitleColor: AppColor.white,
        textOnboardingBackgroundColor: mode == AppThemeMode.defult
            ? AppColor.primary
            : mode == AppThemeMode.dark
            ? AppColor.darkTheme
            : mode == AppThemeMode.cosmic
            ? AppColor.cosmicTheme1
            : mode == AppThemeMode.light
            ? AppColor.lightTheme
            : AppColor.defaultTheme,
        textOnboardingBorderColor: mode == AppThemeMode.defult
            ? AppColor.defaultTheme
            : mode == AppThemeMode.dark
            ? const Color.fromARGB(255, 86, 74, 124)
            : mode == AppThemeMode.cosmic
            ? AppColor.cosmicTheme
            : mode == AppThemeMode.light
            ? AppColor.lightTheme
            : AppColor.defaultTheme,
        btnColor: mode == AppThemeMode.defult
            ? AppColor.white
            : mode == AppThemeMode.dark
            ? AppColor.white
            : mode == AppThemeMode.cosmic
            ? AppColor.cosmicTheme1
            : mode == AppThemeMode.light
            ? AppColor.white
            : AppColor.white,
        gradientColors: mode == AppThemeMode.defult
            ? [AppColor.k1A2A4A, AppColor.k152440]
            : mode == AppThemeMode.dark
            ? [const Color(0xFF2A1D50), AppColor.darkTheme]
            : mode == AppThemeMode.cosmic
            ? [AppColor.cosmicTheme1, AppColor.cosmicTheme1]
            : mode == AppThemeMode.light
            ? [const Color(0xFF1B3C63), AppColor.lightTheme]
            : [AppColor.defaultTheme, AppColor.defaultTheme],
        gradientColors2: mode == AppThemeMode.defult
            ? [
                AppColor.k7FC2F4.withOpacityValue(0.25),
                AppColor.k64B5F6.withOpacityValue(0.15),
              ]
            : mode == AppThemeMode.dark
            ? [
                const Color(0xFF2A1D50).withOpacityValue(0.7),
                const Color(0xFFC0B6E1).withOpacityValue(0.4),
              ]
            : mode == AppThemeMode.cosmic
            ? [
                AppColor.cosmicTheme.withOpacityValue(0.4),
                AppColor.cosmicTheme.withOpacityValue(0.15),
              ]
            : mode == AppThemeMode.light
            ? [
                Color(0xFF1B3C63).withOpacityValue(0.8),
                AppColor.lightTheme.withOpacityValue(0.5),
              ]
            : [AppColor.defaultTheme, AppColor.defaultTheme],
        appBarIconBackgroundColor: mode == AppThemeMode.defult
            ? AppColor.k1D325A
            : mode == AppThemeMode.dark
            ? const Color.fromARGB(255, 71, 57, 114)
            : mode == AppThemeMode.cosmic
            ? const Color.fromARGB(255, 9, 56, 68)
            : mode == AppThemeMode.light
            ? AppColor.lightTheme
            : AppColor.defaultTheme,
        settingIconBackgroundColor: mode == AppThemeMode.defult
            ? AppColor.primary
            : mode == AppThemeMode.dark
            ? const Color.fromARGB(255, 71, 57, 114)
            : mode == AppThemeMode.cosmic
            ? const Color.fromARGB(255, 9, 56, 68)
            : mode == AppThemeMode.light
            ? AppColor.lightTheme
            : AppColor.defaultTheme,
        appBarTitleColor: mode == AppThemeMode.light
            ? AppColor.lightTheme
            : AppColor.white,
        settingCustomContainerColor: mode == AppThemeMode.defult
            ? AppColor.k7FC2F4.withOpacityValue(0.15)
            : mode == AppThemeMode.dark
            ? Color.fromARGB(255, 71, 57, 114).withOpacityValue(0.25)
            : mode == AppThemeMode.cosmic
            ? AppColor.cosmicTheme1.withOpacityValue(0.25)
            : mode == AppThemeMode.light
            ? const Color(0xFFA2CBFE).withOpacityValue(0.25)
            : AppColor.defaultTheme,
        settingCustomContainerBorderColor: mode == AppThemeMode.defult
            ? AppColor.k7FC2F4.withOpacityValue(0.2)
            : mode == AppThemeMode.dark
            ? const Color.fromARGB(255, 71, 57, 114)
            : mode == AppThemeMode.cosmic
            ? const Color.fromARGB(255, 9, 56, 68)
            : mode == AppThemeMode.light
            ? AppColor.lightTheme
            : AppColor.defaultTheme,
        settingCustomContainerShadowColor: mode == AppThemeMode.defult
            ? AppColor.black.withOpacityValue(0.3)
            : mode == AppThemeMode.dark
            ? AppColor.black.withOpacityValue(0.3)
            : mode == AppThemeMode.cosmic
            ? AppColor.cosmicTheme1.withOpacityValue(0.3)
            : mode == AppThemeMode.light
            ? const Color(0xFFA2CBFE).withOpacityValue(0.3)
            : AppColor.black.withOpacityValue(0.3),
        ticTacTwistColor: mode == AppThemeMode.defult
            ? AppColor.k7FC2F4
            : mode == AppThemeMode.dark
            ? AppColor.darkTheme
            : mode == AppThemeMode.cosmic
            ? Color.fromARGB(255, 9, 56, 68)
            : mode == AppThemeMode.light
            ? AppColor.lightTheme
            : AppColor.defaultTheme,
        difficultyButtonColor: mode == AppThemeMode.defult
            ? AppColor.k7FC2F4
            : mode == AppThemeMode.dark
            ? AppColor.white
            : mode == AppThemeMode.cosmic
            ? AppColor.white
            : mode == AppThemeMode.light
            ? AppColor.white
            : AppColor.defaultTheme,
        jigsawPainterBackgroundBorderColor: mode == AppThemeMode.defult
            ? AppColor.k7FC2F4
            : mode == AppThemeMode.dark
            ? const Color.fromARGB(255, 201, 185, 247)
            : mode == AppThemeMode.cosmic
            ? const Color.fromARGB(255, 166, 228, 244)
            : mode == AppThemeMode.light
            ? const Color.fromARGB(255, 170, 195, 226)
            : AppColor.defaultTheme,
        lostedPlayerBackgroundColor: mode == AppThemeMode.defult
            ? AppColor.k7FC2F4.withOpacityValue(0.15)
            : mode == AppThemeMode.dark
            ? Color.fromARGB(255, 193, 181, 231).withOpacityValue(0.25)
            : mode == AppThemeMode.cosmic
            ? AppColor.cosmicTheme1.withOpacityValue(0.25)
            : mode == AppThemeMode.light
            ? const Color(0xFFA2CBFE).withOpacityValue(0.25)
            : AppColor.defaultTheme,
        lostedPlayerBorderColor: mode == AppThemeMode.defult
            ? AppColor.k7FC2F4.withOpacityValue(0.2)
            : mode == AppThemeMode.dark
            ? const Color.fromARGB(255, 71, 57, 114)
            : mode == AppThemeMode.cosmic
            ? const Color.fromARGB(255, 9, 56, 68)
            : mode == AppThemeMode.light
            ? AppColor.lightTheme
            : AppColor.defaultTheme,
        lostedPlayerShadowColor: mode == AppThemeMode.defult
            ? AppColor.black.withOpacityValue(0.3)
            : mode == AppThemeMode.dark
            ? AppColor.black.withOpacityValue(0.3)
            : mode == AppThemeMode.cosmic
            ? AppColor.cosmicTheme1.withOpacityValue(0.3)
            : mode == AppThemeMode.light
            ? const Color(0xFFA2CBFE).withOpacityValue(0.3)
            : AppColor.black.withOpacityValue(0.3),
        noInternetImage: mode == AppThemeMode.defult
            ? Assets.assetsImageNoInternetNoInternetDefault
            : mode == AppThemeMode.dark
            ? Assets.assetsImageNoInternetNoInternetDark
            : mode == AppThemeMode.cosmic
            ? Assets.assetsImageNoInternetNoInternetCosmic
            : mode == AppThemeMode.light
            ? Assets.assetsImageNoInternetNoInternetLight
            : Assets.assetsImageNoInternetNoInternetDefault,
      ),
    );
  }

  LinearGradient _gradientForMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.dark:
        return AppColor.darkGradient;
      case AppThemeMode.cosmic:
        return AppColor.cosmicGradient;
      case AppThemeMode.light:
        return AppColor.lightGradient;
      case AppThemeMode.defult:
        return AppColor.defultGradient;
    }
  }
}
