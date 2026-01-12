import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_selection_state.dart';

class HomeSelectionCubit extends Cubit<HomeSelectionState> {
  HomeSelectionCubit() : super(HomeSelectionState.initial());

  void toggleSelection(String key) {
    if (state.selectedKey == key) {
      emit(state.copyWith(selectedKey: null));
    } else {
      emit(state.copyWith(selectedKey: key));
    }
  }
}

