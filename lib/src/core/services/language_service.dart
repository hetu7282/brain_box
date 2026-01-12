import 'package:brain_box/src/core/database/storage.dart';
import 'package:brain_box/src/core/utils/notify_listener_mixin.dart';
import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier with NotifyListenerMixin {
  static const _supportedLocales = [
    Locale('en', ''), // English
    Locale('fr', ''), // French
    Locale('es', ''), // Spanish
    Locale('hi', ''), // Hindi
  ];

  Locale _currentLocale = const Locale('en', ''); // Default to English

  LanguageService() {
    _loadLanguage();
  }

  Locale get currentLocale => _currentLocale;
  List<Locale> get supportedLocales => _supportedLocales;

  Future<void> _loadLanguage() async {
    final languageCode = Storage.instance.getLanguage() ?? 'en';
    _currentLocale = _supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => const Locale('en', ''),
    );
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    await Storage.instance.setLanguage(languageCode);
    _currentLocale = _supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => const Locale('en', ''),
    );
    notifyListeners();
  }
}
