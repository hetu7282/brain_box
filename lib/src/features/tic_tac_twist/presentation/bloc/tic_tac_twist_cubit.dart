import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tic_tac_twist_state.dart';

class TicTacTwistCubit extends Cubit<TicTacTwistState> {
  TicTacTwistCubit() : super(TicTacTwistState.initial());

  void onCellTap(int index) {
    if (state.mode == GameMode.vsAI && state.currentPlayer == 'O') return;
    if (state.gameOver || state.board[index].isNotEmpty) return;

    final List<String> newBoard = List.of(state.board);
    newBoard[index] = state.currentPlayer;

    final String? winner = _checkWinner(newBoard);

    if (winner != null) {
      if (winner == 'X') {
        emit(
          state.copyWith(
            board: newBoard,
            xWins: state.xWins + 1,
            winner: winner,
            gameOver: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            board: newBoard,
            oWins: state.oWins + 1,
            winner: winner,
            gameOver: true,
          ),
        );
      }
      return;
    }

    final bool isDraw = !newBoard.contains('');
    if (isDraw) {
      emit(
        state.copyWith(
          board: newBoard,
          draws: state.draws + 1,
          gameOver: true,
          winner: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        board: newBoard,
        currentPlayer: state.currentPlayer == 'X' ? 'O' : 'X',
      ),
    );
    _maybeAIMove();
  }

  void nextRound() {
    emit(
      state.copyWith(
        board: List.filled(9, ''),
        gameOver: false,
        winner: null,
        currentPlayer: state.winner == 'O' ? 'O' : 'X',
      ),
    );
    _maybeAIMove();
  }

  void resetScores() {
    emit(state.copyWith(xWins: 0, oWins: 0, draws: 0));
  }

  void restartBoard() {
    emit(
      state.copyWith(
        board: List.filled(9, ''),
        gameOver: false,
        winner: null,
        currentPlayer: 'X',
      ),
    );
    _maybeAIMove();
  }

  void setMode(GameMode mode) {
    if (mode == state.mode) return;
    emit(state.copyWith(mode: mode));
    restartBoard();
  }

  String? _checkWinner(List<String> board) {
    const List<List<int>> lines = [
      // rows
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      // cols
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      // diagonals
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (final l in lines) {
      final a = board[l[0]];
      if (a.isNotEmpty && a == board[l[1]] && a == board[l[2]]) {
        return a; // 'X' or 'O'
      }
    }
    return null;
  }

  void _maybeAIMove() async {
    if (state.mode != GameMode.vsAI || state.gameOver) return;
    if (state.currentPlayer != 'O') return;
    await Future.delayed(const Duration(milliseconds: 220));
    final List<int> empty = [];
    for (int i = 0; i < state.board.length; i++) {
      if (state.board[i].isEmpty) empty.add(i);
    }
    if (empty.isEmpty) return;

    int pick = _bestAIMove(empty);
    final List<String> newBoard = List.of(state.board);
    if (newBoard[pick].isNotEmpty || state.gameOver) return;
    newBoard[pick] = 'O';

    final String? winner = _checkWinner(newBoard);
    if (winner != null) {
      emit(
        state.copyWith(
          board: newBoard,
          oWins: state.oWins + 1,
          winner: winner,
          gameOver: true,
        ),
      );
      return;
    }

    final bool isDraw = !newBoard.contains('');
    if (isDraw) {
      emit(
        state.copyWith(
          board: newBoard,
          draws: state.draws + 1,
          gameOver: true,
          winner: null,
        ),
      );
      return;
    }

    emit(state.copyWith(board: newBoard, currentPlayer: 'X'));
  }

  int _bestAIMove(List<int> empty) {
    if (empty.contains(4)) return 4;
    const corners = [0, 2, 6, 8];
    for (final c in corners) {
      if (empty.contains(c)) return c;
    }
    return empty[Random().nextInt(empty.length)];
  }
}
