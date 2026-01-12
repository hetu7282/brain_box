part of 'kings_gambit_puzzle_cubit.dart';

class KingsGambitPuzzleState extends Equatable {
  final bool allowUndoRedo;
  final bool showHints;
  final bool isInitialized;

  const KingsGambitPuzzleState({
    required this.allowUndoRedo,
    required this.showHints,
    required this.isInitialized,
  });

  factory KingsGambitPuzzleState.initial() {
    return const KingsGambitPuzzleState(
      allowUndoRedo: true,
      showHints: true,
      isInitialized: false,
    );
  }

  KingsGambitPuzzleState copyWith({
    bool? allowUndoRedo,
    bool? showHints,
    bool? isInitialized,
  }) {
    return KingsGambitPuzzleState(
      allowUndoRedo: allowUndoRedo ?? this.allowUndoRedo,
      showHints: showHints ?? this.showHints,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [allowUndoRedo, showHints, isInitialized];
}

