import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/app_string.dart';
import 'package:brain_box/src/core/database/storage.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/utils/notify_listener_mixin.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

enum AppThemeMode { light, dark, defult, cosmic }

class ThemeService extends ChangeNotifier with NotifyListenerMixin {
  static ThemeService? _instance;
  AppThemeMode _currentTheme = AppThemeMode.light;

  ThemeService._internal() {
    _loadTheme();
  }

  factory ThemeService() {
    _instance ??= ThemeService._internal();
    return _instance!;
  }

  AppThemeMode get currentTheme => _currentTheme;

  Color get primaryColor => AppColor.k7FC2F4;

  Color get backgroundColor => _currentTheme == AppThemeMode.dark
      ? const Color(0xFF121212)
      : _currentTheme == AppThemeMode.cosmic
      ? const Color(0xFF0F0C29)
      : const Color(0xFF1A1A2E);

  Color get surfaceColor => _currentTheme == AppThemeMode.dark
      ? AppColor.k7FC2F4.withOpacityValue(0.1)
      : AppColor.k7FC2F4.withOpacityValue(0.15);

  Color get borderColor => _currentTheme == AppThemeMode.dark
      ? AppColor.k7FC2F4.withOpacityValue(0.3)
      : AppColor.k7FC2F4.withOpacityValue(0.2);

  Color get textColor =>
      _currentTheme == AppThemeMode.dark ? Colors.white : Colors.white;

  /// Get the effective theme mode (resolves system to light or dark)
  AppThemeMode getEffectiveThemeMode(BuildContext? context) {
    if (_currentTheme == AppThemeMode.defult) {
      final brightness = context != null
          ? MediaQuery.of(context).platformBrightness
          : Brightness.light;
      return brightness == Brightness.dark
          ? AppThemeMode.dark
          : AppThemeMode.light;
    }
    return _currentTheme;
  }

  /// Get ThemeData based on current theme mode
  ThemeData getThemeData(BuildContext? context) {
    final effectiveTheme = getEffectiveThemeMode(context);

    switch (effectiveTheme) {
      case AppThemeMode.light:
        return getLightTheme();
      case AppThemeMode.dark:
        return getDarkTheme();
      case AppThemeMode.cosmic:
        return getCosmicTheme();
      case AppThemeMode.defult:
        // Should not reach here, but fallback to light
        return getLightTheme();
    }
  }

  ThemeData getLightTheme() {
    return ThemeData(
      fontFamily: AppString.fontFamily,
      scaffoldBackgroundColor: AppColor.white,
      primaryColor: AppColor.primary,
      primarySwatch: AppMaterialColor.primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.primary,
        surface: AppColor.white,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        surfaceTintColor: AppColor.transparent,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: const Color(0xFFFFFFFF),
        dialHandColor: AppColor.primary,
        hourMinuteShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        dialTextColor: const Color(0xFF333333),
        timeSelectorSeparatorColor: WidgetStateProperty.all(
          const Color(0xFF333333),
        ),
        dayPeriodColor: AppColor.primary,
        dayPeriodTextColor: const Color(0xFF333333),
        dialTextStyle: TextStyle(
          fontSize: 20.px,
          color: const Color(0xFF333333),
        ),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(AppColor.primary),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(AppColor.primary),
        ),
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      fontFamily: AppString.fontFamily,
      scaffoldBackgroundColor: const Color(0xFF121212),
      primaryColor: AppColor.k7FC2F4,
      primarySwatch: AppMaterialColor.primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.k7FC2F4,
        surface: const Color(0xFF1E1E1E),
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        surfaceTintColor: AppColor.transparent,
        backgroundColor: const Color(0xFF121212),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        dialHandColor: AppColor.k7FC2F4,
        hourMinuteShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        dialTextColor: Colors.white,
        timeSelectorSeparatorColor: WidgetStateProperty.all(Colors.white),
        dayPeriodColor: AppColor.k7FC2F4,
        dayPeriodTextColor: Colors.white,
        dialTextStyle: TextStyle(fontSize: 20.px, color: Colors.white),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(AppColor.k7FC2F4),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(AppColor.k7FC2F4),
        ),
      ),
    );
  }

  ThemeData getCosmicTheme() {
    return ThemeData(
      fontFamily: AppString.fontFamily,
      scaffoldBackgroundColor: const Color(0xFF0F0C29),
      primaryColor: const Color(0xFF00BCD4),
      primarySwatch: MaterialColor(0xFF00BCD4, <int, Color>{
        50: const Color(0xFFE0F7FA),
        100: const Color(0xFFB2EBF2),
        200: const Color(0xFF80DEEA),
        300: const Color(0xFF4DD0E1),
        400: const Color(0xFF26C6DA),
        500: const Color(0xFF00BCD4),
        600: const Color(0xFF00ACC1),
        700: const Color(0xFF0097A7),
        800: const Color(0xFF00838F),
        900: const Color(0xFF006064),
      }),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF00BCD4),
        surface: const Color(0xFF16213E),
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        surfaceTintColor: AppColor.transparent,
        backgroundColor: const Color(0xFF0F0C29),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: const Color(0xFF16213E),
        dialHandColor: const Color(0xFF00BCD4),
        hourMinuteShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        dialTextColor: Colors.white,
        timeSelectorSeparatorColor: WidgetStateProperty.all(Colors.white),
        dayPeriodColor: const Color(0xFF00BCD4),
        dayPeriodTextColor: Colors.white,
        dialTextStyle: TextStyle(fontSize: 20.px, color: Colors.white),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(const Color(0xFF00BCD4)),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(const Color(0xFF00BCD4)),
        ),
      ),
    );
  }

  Future<void> _loadTheme() async {
    final themeString = Storage.instance.getAppThemeMode();
    if (themeString.isNotEmpty) {
      _currentTheme = AppThemeMode.values.firstWhere(
        (theme) => theme.name == themeString,
        orElse: () => AppThemeMode.light,
      );
      notifyListeners();
    }
  }

  Future<void> setTheme(AppThemeMode theme) async {
    await Storage.instance.setAppThemeMode(theme.name);
    _currentTheme = theme;
    notifyListeners();
  }

  String getThemeName() {
    switch (_currentTheme) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.defult:
        return 'System';
      case AppThemeMode.cosmic:
        return 'Cosmic';
    }
  }
}
