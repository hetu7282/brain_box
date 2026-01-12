import 'package:equatable/equatable.dart';

/// Represents the state of audio settings
class AudioState extends Equatable {
  final bool isMusicEnabled;

  const AudioState({
    required this.isMusicEnabled,
  });

  /// Factory constructor for initial state (both enabled by default)
  factory AudioState.initial() {
    return const AudioState(isMusicEnabled: true);
  }

  /// Create a copy with updated values
  AudioState copyWith({bool? isMusicEnabled}) {
    return AudioState(
      isMusicEnabled: isMusicEnabled ?? this.isMusicEnabled,
    );
  }

  @override
  List<Object> get props => [isMusicEnabled];

  @override
  String toString() =>
      'AudioState(isMusicEnabled: $isMusicEnabled)';
}
