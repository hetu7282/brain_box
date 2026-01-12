import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:flutter/material.dart';

abstract class AppColor {
  // Primary colors
  static const Color primary = Color(0xFF182848); // Primary color
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Most used colors
  static const Color k7FC2F4 = Color(0xFF7FC2F4); // Light blue
  static const Color k64B5F6 = Color(0xFF64B5F6); // Medium blue
  static const Color k1A2A4A = Color(0xFF1A2A4A); // Dark blue
  static const Color k152440 = Color(0xFF152440); // Darker blue
  static const Color k1D325A = Color(0xFF1D325A); // Darker blue
  // Grayscale colors
  static const Color k6A6262 = Color(0xFF6A6262);
  static const Color kF7F7F7 = Color(0xFFF7F7F7);
  static const Color kABA6A6 = Color(0xFFABA6A6);
  static const Color k787272 = Color(0xFF787272);
  static const Color kE2E2E2 = Color(0xFFE2E2E2);
  static const Color kA6B0C3 = Color(0xFFA6B0C3);
  static const Color kE9E9E9 = Color(0xFFE9E9E9);
  static const Color k2F2C31 = Color(0xFF2F2C31);
  static const Color kB0B7C3 = Color(0xFFB0B7C3);

  // Status colors
  static const Color kFF3B30 = Color(0xFFFF3B30);
  static const Color kFF383C = Color(0xFFFF383C);
  static const Color k64070A = Color(0xFF64070A);
  static const Color kFF9500 = Color(0xFFFF9500);
  static const Color kF7B31D = Color(0xFFF7B31D);
  static const Color k007AFF = Color(0xFF007AFF);
  static const Color k2D98DA = Color(0xFF2D98DA);
  static const Color k043E54 = Color(0xFF043E54);
  static const Color k03958A = Color(0xFF03958A);
  static const Color k53C1E3 = Color(0xFF53C1E3);

  // Accent colors
  static const Color kF0FFF2 = Color(0xFFF0FFF2);
  static const Color kECF3EC = Color(0xFFECF3EC);
  static const Color kEAF9EC = Color(0xFFEAF9EC);

  static const Color defaultTheme = Color(0xFF7FC2F4);
  static const Color lightTheme = Color(0xFF2D6FBE);
  static const Color darkTheme = Color(0xFF6754A0);
  static const Color cosmicTheme = Color(0xFFD0F4FC);
  static const Color cosmicTheme1 = Color(0xFF054D5F);

  static const LinearGradient defultGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF132039),
      Color(0xFF1A2A4A),
      Color(0xFF132039),
    ], // Gradient from medium blue to primary
  );
  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color.fromARGB(255, 195, 223, 253),
      Color.fromARGB(255, 212, 230, 250),
      Color.fromARGB(255, 230, 238, 247),
      Color.fromARGB(255, 212, 230, 250),
      Color.fromARGB(255, 195, 223, 253),
    ], // Gradient from medium blue to primary
  );
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColor.black,

      Color(0xFF0F0F0F),
      AppColor.black,
    ], // Gradient from medium blue to primary
  );
  static const LinearGradient cosmicGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF054D5F),
      Color(0xFF4C8A9A),
      Color(0xFF054D5F),
    ], // Gradient from medium blue to primary
  );

  static LinearGradient gradient1 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1D325A).withOpacityValue(0.5),
      Color(0xFF182848),
    ], // Gradient from light blue to primary with opacity
  );
}

abstract class AppMaterialColor {
  static const MaterialColor primaryColor = MaterialColor(
    _primaryColorPrimaryValue,
    <int, Color>{
      50: Color(0xFFE8EBF0), // Lightest shade
      100: Color(0xFFC4CBDD),
      200: Color(0xFF9CABC8),
      300: Color(0xFF7488B3),
      400: Color(0xFF566EA2),
      500: Color(0xFF182848), // Primary color
      600: Color(0xFF142142),
      700: Color(0xFF0F193A),
      800: Color(0xFF0B1232),
      900: Color(0xFF070A24), // Darkest shade
    },
  );
  static const int _primaryColorPrimaryValue =
      0xFF182848; // Primary color value (182848)
}
