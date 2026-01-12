import 'package:equatable/equatable.dart';

/// Represents the state of connectivity
class ConnectivityState extends Equatable {
  final bool isConnected;

  const ConnectivityState({required this.isConnected});

  /// Factory constructor for connected state
  factory ConnectivityState.connected() {
    return const ConnectivityState(isConnected: true);
  }

  /// Factory constructor for disconnected state
  factory ConnectivityState.disconnected() {
    return const ConnectivityState(isConnected: false);
  }

  @override
  List<Object> get props => [isConnected];

  @override
  String toString() => 'ConnectivityState(isConnected: $isConnected)';
}
