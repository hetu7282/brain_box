part of 'select_difficulty_cubit.dart';

class SelectDifficultyState extends Equatable {
  final int selectedDifficulty;

  const SelectDifficultyState({required this.selectedDifficulty});

  factory SelectDifficultyState.initial() =>
      const SelectDifficultyState(selectedDifficulty: 5);

  SelectDifficultyState copyWith({int? selectedDifficulty}) {
    return SelectDifficultyState(
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
    );
  }

  @override
  List<Object?> get props => [selectedDifficulty];
}
