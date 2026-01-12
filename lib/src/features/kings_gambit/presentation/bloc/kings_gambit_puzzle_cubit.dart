import 'package:brain_box/src/core/database/storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'kings_gambit_puzzle_state.dart';

class KingsGambitPuzzleCubit extends Cubit<KingsGambitPuzzleState> {
  final Storage _storage = Storage.instance;

  KingsGambitPuzzleCubit() : super(KingsGambitPuzzleState.initial()) {
    _loadSettings();
  }

  void _loadSettings() {
    final allowUndoRedo = _storage.getKingsGambitAllowUndoRedo();
    final showHints = _storage.getKingsGambitShowHints();
    emit(
      state.copyWith(
        allowUndoRedo: allowUndoRedo,
        showHints: showHints,
      ),
    );
  }

  void reloadSettings() {
    _loadSettings();
  }

  void markInitialized() {
    emit(state.copyWith(isInitialized: true));
  }
}

