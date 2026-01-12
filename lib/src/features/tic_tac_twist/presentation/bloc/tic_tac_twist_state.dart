part of 'tic_tac_twist_cubit.dart';

class TicTacTwistState extends Equatable {
  final List<String> board; // 9 entries: '', 'X', 'O'
  final String currentPlayer; // 'X' or 'O'
  final int xWins;
  final int oWins;
  final int draws;
  final bool gameOver;
  final String? winner; // 'X', 'O', or null for draw/in-progress
  final GameMode mode; // vs AI or 2 players

  const TicTacTwistState({
    required this.board,
    required this.currentPlayer,
    required this.xWins,
    required this.oWins,
    required this.draws,
    required this.gameOver,
    required this.winner,
    required this.mode,
  });

  factory TicTacTwistState.initial() => const TicTacTwistState(
    board: ['', '', '', '', '', '', '', '', ''],
    currentPlayer: 'X',
    xWins: 0,
    oWins: 0,
    draws: 0,
    gameOver: false,
    winner: null,
    mode: GameMode.twoPlayers,
  );

  TicTacTwistState copyWith({
    List<String>? board,
    String? currentPlayer,
    int? xWins,
    int? oWins,
    int? draws,
    bool? gameOver,
    String? winner,
    GameMode? mode,
  }) {
    return TicTacTwistState(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      xWins: xWins ?? this.xWins,
      oWins: oWins ?? this.oWins,
      draws: draws ?? this.draws,
      gameOver: gameOver ?? this.gameOver,
      winner: winner,
      mode: mode ?? this.mode,
    );
  }

  @override
  List<Object?> get props => [
    board,
    currentPlayer,
    xWins,
    oWins,
    draws,
    gameOver,
    winner,
    mode,
  ];
}

enum GameMode { vsAI, twoPlayers }
