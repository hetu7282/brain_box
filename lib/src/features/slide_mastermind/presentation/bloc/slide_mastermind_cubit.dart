import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'slide_mastermind_state.dart';

class SlideMastermindCubit extends Cubit<SlideMastermindState> {
  static const int gridSize = 4;
  Timer? _timer;

  SlideMastermindCubit() : super(SlideMastermindState.initial());

  void initialize({bool shuffle = true}) {
    final tiles = List<int>.generate(gridSize * gridSize, (i) => i);
    final updated = state.copyWith(
      tiles: tiles,
      moves: 0,
      elapsedSeconds: 0,
      running: false,
      won: false,
    );
    emit(updated);
    if (shuffle) shuffleSolvable();
  }

  void shuffleSolvable() {
    final tiles = List<int>.from(state.tiles);
    tiles.shuffle();
    if (!_isSolvable(tiles)) {
      final a = tiles.indexWhere((e) => e != 0);
      final b = tiles.lastIndexWhere((e) => e != 0);
      final t = tiles[a];
      tiles[a] = tiles[b];
      tiles[b] = t;
    }
    _stopTimer();
    emit(
      state.copyWith(
        tiles: tiles,
        moves: 0,
        elapsedSeconds: 0,
        running: false,
        won: false,
      ),
    );
  }

  void resetOrdered() {
    final tiles = List<int>.generate(gridSize * gridSize, (i) => i);
    _stopTimer();
    emit(
      state.copyWith(
        tiles: tiles,
        moves: 0,
        elapsedSeconds: 0,
        running: false,
        won: false,
      ),
    );
  }

  void onTileTap(int index) {
    if (state.won) return;
    final tiles = List<int>.from(state.tiles);
    final emptyIndex = tiles.indexOf(0);
    if (!_areAdjacent(index, emptyIndex)) return;

    if (!state.running) _startTimer();

    final temp = tiles[index];
    tiles[index] = tiles[emptyIndex];
    tiles[emptyIndex] = temp;

    final moves = state.moves + 1;
    final won = _isCompleted(tiles);
    if (won) _stopTimer();

    emit(state.copyWith(tiles: tiles, moves: moves, won: won));
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(
        state.copyWith(elapsedSeconds: state.elapsedSeconds + 1, running: true),
      );
    });
    emit(state.copyWith(running: true));
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    emit(state.copyWith(running: false));
  }

  bool _areAdjacent(int a, int b) {
    final ax = a % gridSize;
    final ay = a ~/ gridSize;
    final bx = b % gridSize;
    final by = b ~/ gridSize;
    return (ax == bx && (ay - by).abs() == 1) ||
        (ay == by && (ax - bx).abs() == 1);
  }

  bool _isCompleted(List<int> tiles) {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) return false;
    }
    return tiles.last == 0;
  }

  bool _isSolvable(List<int> tiles) {
    int inversions = 0;
    for (int i = 0; i < tiles.length; i++) {
      for (int j = i + 1; j < tiles.length; j++) {
        if (tiles[i] != 0 && tiles[j] != 0 && tiles[i] > tiles[j]) inversions++;
      }
    }
    const width = gridSize;
    if (width.isOdd) return inversions.isEven;
    final rowFromBottom = width - (tiles.indexOf(0) ~/ width);
    return (rowFromBottom.isEven && inversions.isOdd) ||
        (rowFromBottom.isOdd && inversions.isEven);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
