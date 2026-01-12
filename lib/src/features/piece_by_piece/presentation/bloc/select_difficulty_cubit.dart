import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'select_difficulty_state.dart';

class SelectDifficultyCubit extends Cubit<SelectDifficultyState> {
  SelectDifficultyCubit() : super(SelectDifficultyState.initial());

  void selectDifficulty(int difficulty) {
    if (state.selectedDifficulty == difficulty) return;
    emit(state.copyWith(selectedDifficulty: difficulty));
  }
}
