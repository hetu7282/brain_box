part of 'slide_mastermind_cubit.dart';

class SlideMastermindState extends Equatable {
  final List<int> tiles; // 0 is empty
  final int moves;
  final int elapsedSeconds; // seconds
  final bool running;
  final bool won;

  const SlideMastermindState({
    required this.tiles,
    required this.moves,
    required this.elapsedSeconds,
    required this.running,
    required this.won,
  });

  factory SlideMastermindState.initial() => const SlideMastermindState(
    tiles: [],
    moves: 0,
    elapsedSeconds: 0,
    running: false,
    won: false,
  );

  SlideMastermindState copyWith({
    List<int>? tiles,
    int? moves,
    int? elapsedSeconds,
    bool? running,
    bool? won,
  }) {
    return SlideMastermindState(
      tiles: tiles ?? this.tiles,
      moves: moves ?? this.moves,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      running: running ?? this.running,
      won: won ?? this.won,
    );
  }

  @override
  List<Object?> get props => [tiles, moves, elapsedSeconds, running, won];
}
