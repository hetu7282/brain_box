import 'package:brain_box/src/core/utils/log.dart';
import 'package:brain_box/src/core/utils/notify_listener_mixin.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier with NotifyListenerMixin {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  ConnectivityService() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Perform initial connectivity check
    var initialResult = await Connectivity().checkConnectivity();
    _isConnected = initialResult.first != ConnectivityResult.none;
    notifyListeners();

    // Listen for future changes
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      bool isConnectedNow = connectivityResult.first != ConnectivityResult.none;
      Log.d("Connectivity  $isConnectedNow");
      if (_isConnected != isConnectedNow) {
        _isConnected = isConnectedNow;
        notifyListeners();
      }
    });
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.first != ConnectivityResult.none;
  }
}
