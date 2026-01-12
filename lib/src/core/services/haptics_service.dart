import 'dart:io';

import 'package:brain_box/src/core/utils/log.dart';
import 'package:flutter/services.dart';

class HapticsService {
  HapticsService._();
  static final HapticsService instance = HapticsService._();

  Future<void> tap() async {
    try {
      if (Platform.isIOS) {
        await HapticFeedback.selectionClick();
      } else {
        // Use Flutter's built-in haptic feedback for Android
        await HapticFeedback.lightImpact();
      }
    } catch (e) {
      Log.e('Error tapping: $e');
    }
  }
}
