import 'dart:async';

import 'package:brain_box/app/app.dart';
import 'package:brain_box/locator.dart';
import 'package:brain_box/src/core/database/storage_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';

final systemOverlayStyle = SystemUiOverlayStyle.light.copyWith(
  statusBarColor: Colors.transparent,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarDividerColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light, // Android dark icons
  statusBarBrightness:
      Brightness.dark, // iOS dark icons/text on light background
  systemNavigationBarIconBrightness: Brightness.light,
);
final lightSystemOverlayStyle = SystemUiOverlayStyle.light.copyWith(
  statusBarColor: Colors.transparent,
  systemNavigationBarColor: Colors.white, // White background for navigation bar
  systemNavigationBarDividerColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark, // Dark icons for status bar
  statusBarBrightness: Brightness.light, // Light status bar on iOS
  systemNavigationBarIconBrightness:
      Brightness.dark, // Dark icons on navigation bar
);

final darkSystemOverlayStyle = SystemUiOverlayStyle.dark.copyWith(
  statusBarColor: Colors.transparent,
  systemNavigationBarColor: Colors.black, // Black background for navigation bar
  systemNavigationBarDividerColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light, // Light icons for status bar
  statusBarBrightness: Brightness.dark, // Dark status bar on iOS
  systemNavigationBarIconBrightness:
      Brightness.light, // Light icons on navigation bar
);

Future<void> boxOpen() async {
  await Hive.openBox(StorageString.authenticationBoxName);
}

Future<void> init() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(systemOverlayStyle);
  unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
  await Hive.initFlutter();
  await boxOpen();
  initLocator();
}

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await init();
  runApp(const App());
}
