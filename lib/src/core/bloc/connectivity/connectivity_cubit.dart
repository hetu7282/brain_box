import 'dart:async';

import 'package:brain_box/src/core/bloc/connectivity/connectivity_state.dart';
import 'package:brain_box/src/core/utils/log.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing connectivity state
class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ConnectivityCubit() : super(const ConnectivityState(isConnected: true)) {
    _initialize();
  }

  /// Initialize connectivity monitoring
  Future<void> _initialize() async {
    try {
      // Perform initial connectivity check
      var initialResult = await _connectivity.checkConnectivity();
      bool isConnected = initialResult.first != ConnectivityResult.none;

      emit(
        isConnected
            ? ConnectivityState.connected()
            : ConnectivityState.disconnected(),
      );

      Log.d("Initial connectivity: $isConnected");

      // Listen for future changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
        connectivityResult,
      ) {
        bool isConnectedNow =
            connectivityResult.first != ConnectivityResult.none;
        Log.d("Connectivity changed: $isConnectedNow");

        if (state.isConnected != isConnectedNow) {
          emit(
            isConnectedNow
                ? ConnectivityState.connected()
                : ConnectivityState.disconnected(),
          );
        }
      });
    } catch (e) {
      Log.e("Error initializing connectivity: $e");
      emit(ConnectivityState.disconnected());
    }
  }

  /// Manually check internet connection
  Future<bool> checkInternetConnection() async {
    try {
      var connectivityResult = await _connectivity.checkConnectivity();
      bool isConnected = connectivityResult.first != ConnectivityResult.none;

      if (state.isConnected != isConnected) {
        emit(
          isConnected
              ? ConnectivityState.connected()
              : ConnectivityState.disconnected(),
        );
      }

      return isConnected;
    } catch (e) {
      Log.e("Error checking connectivity: $e");
      return false;
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
