import 'package:brain_box/src/core/utils/log.dart';
import 'package:flutter/material.dart';

mixin NotifyListenerMixin on ChangeNotifier {
  @override
  void notifyListeners() {
    try {
      super.notifyListeners();
    } catch (e) {
      Log.release(e);
    }
  }
}
