import 'package:equatable/equatable.dart';

class HapticsState extends Equatable {
  final bool enabled;

  const HapticsState({required this.enabled});

  factory HapticsState.initial() => const HapticsState(enabled: true);

  HapticsState copyWith({bool? enabled}) =>
      HapticsState(enabled: enabled ?? this.enabled);

  @override
  List<Object?> get props => [enabled];
}
