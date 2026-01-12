import 'package:brain_box/src/core/database/storage.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/main_menu_view/game_options/side_picker.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/chess_game.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/chess_piece.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/move_calculation/move_classes/move_meta.dart';
import 'package:flutter/material.dart';

class ChessTheme {
  final String name;
  final Color lightTile;
  final Color darkTile;
  final Color moveHint;
  final Color latestMove;
  final Color checkHint;
  final Color border;

  const ChessTheme({
    required this.name,
    required this.lightTile,
    required this.darkTile,
    required this.moveHint,
    required this.latestMove,
    required this.checkHint,
    required this.border,
  });
}

class AppModel extends ChangeNotifier {
  ChessGame? game;
  Player turn = Player.player1;
  bool gameOver = false;
  bool showHints = true;
  String pieceTheme = 'classic';
  ChessTheme theme = const ChessTheme(
    name: 'Classic',
    lightTile: Color(0xFFF0D9B5),
    darkTile: Color(0xFFB58863),
    moveHint: Color(0x88FFFF00),
    latestMove: Color(0x88FF0000),
    checkHint: Color(0x88FF0000),
    border: Color(0xFF8B4513),
  );
  bool isAIsTurn = false;
  Player aiTurn = Player.player2;
  int aiDifficulty = 3;
  int playerCount = 1; // 1 for AI, 2 for friend
  Player playerSide = Player.player1;
  bool flip = false;
  bool playingWithAI = true;
  bool soundEnabled = true;
  bool stalemate = false;
  List<MoveMeta> moveMetaList = [];
  bool promotionRequested = false;
  bool showMoveHistory = true;
  bool allowUndoRedo = true;
  bool moveListUpdated = false;
  int timeLimit = 0;
  Duration player1TimeLeft = const Duration(minutes: 10);
  Duration player2TimeLeft = const Duration(minutes: 10);
  Player selectedSide = Player.player1;

  // Captured pieces tracking
  List<ChessPieceType> capturedPiecesPlayer1 = [];
  List<ChessPieceType> capturedPiecesPlayer2 = [];

  // Theme lists
  static final List<ChessTheme> themeList = [
    const ChessTheme(
      name: 'Classic',
      lightTile: Color(0xFFF0D9B5), // Warm beige
      darkTile: Color(0xFFB58863), // Medium brown
      moveHint: Color(0x88FFFF00), // Yellow
      latestMove: Color(0x88FF0000), // Bright red
      checkHint: Color(0x88FF0000), // Bright red
      border: Color(0xFF8B4513), // Saddle brown
    ),
    const ChessTheme(
      name: 'Desert',
      lightTile: Color(0xFFD4C5A9), // Sandy beige/grey (lighter)
      darkTile: Color(0xFF6B7D5A), // Olive green/grey (darker)
      moveHint: Color(0x88FFFF00), // Yellow
      latestMove: Color(0x88FF0000), // Bright red
      checkHint: Color(0x88FF0000), // Bright red
      border: Color(0xFF5A6B4A), // Dark olive
    ),
    const ChessTheme(
      name: 'Cherry Funk',
      lightTile: Color.fromARGB(255, 244, 182, 176), // Light pink/rose
      darkTile: Color(0xFF8B0000), // Dark red
      moveHint: Color.fromARGB(133, 138, 64, 64), // Yellow
      latestMove: Color(0x88FF0000), // Bright red
      checkHint: Color(0x88FF0000), // Bright red
      border: Color(0xFF6B0000), // Darker red
    ),
    const ChessTheme(
      name: 'Sage',
      lightTile: Color.fromARGB(255, 175, 187, 248), // Light sage green
      darkTile: Color.fromARGB(255, 113, 112, 180), // Sage green
      moveHint: Color.fromARGB(135, 13, 0, 252), // Yellow
      latestMove: Color.fromARGB(135, 255, 0, 0), // Bright red
      checkHint: Color(0x88FF0000), // Bright red
      border: Color.fromARGB(255, 113, 112, 180), // Darker sage
    ),
    const ChessTheme(
      name: 'Warm Tan',
      lightTile: Color.fromARGB(255, 171, 130, 176), // Light tan/cream
      darkTile: Color.fromARGB(255, 123, 29, 115), // Warm tan
      moveHint: Color.fromARGB(135, 255, 0, 230), // Yellow
      latestMove: Color(0x88FF0000), // Bright red
      checkHint: Color(0x88FF0000), // Bright red
      border: Color.fromARGB(255, 123, 29, 115), // Dark goldenrod
    ),
    // New "Dark Mode" Theme
    const ChessTheme(
      name: 'Dark Mode',
      lightTile: Color.fromARGB(
        255,
        158,
        154,
        154,
      ), // Dark grey for light tiles
      darkTile: Color.fromARGB(
        255,
        77,
        73,
        73,
      ), // Very dark grey for dark tiles
      moveHint: Color.fromARGB(135, 24, 24, 24), // Yellow for move hint
      latestMove: Color(0x88FF0000), // Bright red for latest move
      checkHint: Color(0x88FF0000), // Bright red for check hint
      border: Color(0xFF444444), // A neutral grey for the border
    ),
  ];

  static final List<String> pieceThemes = ['classic', 'angular', 'letters'];

  int get themeIndex => 0; // Default to first theme
  int get pieceThemeIndex => pieceThemes.indexOf(pieceTheme);

  void setGame(ChessGame? newGame) {
    game = newGame;
    notifyListeners();
  }

  void changeTurn() {
    turn = turn == Player.player1 ? Player.player2 : Player.player1;
    isAIsTurn = playingWithAI && turn == aiTurn;
    notifyListeners();
  }

  void endGame() {
    gameOver = true;
    notifyListeners();
  }

  void undoEndGame() {
    gameOver = false;
    stalemate = false;
    notifyListeners();
  }

  void requestPromotion() {
    promotionRequested = true;
    notifyListeners();
  }

  void clearPromotionRequest() {
    promotionRequested = false;
    notifyListeners();
  }

  void pushMoveMeta(MoveMeta meta) {
    moveMetaList.add(meta);
    notifyListeners();
  }

  void popMoveMeta() {
    if (moveMetaList.isNotEmpty) {
      moveMetaList.removeLast();
    }
    notifyListeners();
  }

  void setShowHints(bool value) {
    showHints = value;
    notifyListeners();
  }

  void setPieceThemeString(String theme) {
    pieceTheme = theme;
    notifyListeners();
  }

  void setThemeObject(ChessTheme newTheme) {
    theme = newTheme;
    notifyListeners();
  }

  void setSoundEnabled(bool value) {
    soundEnabled = value;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  void setShowMoveHistory(bool value) {
    showMoveHistory = value;
    notifyListeners();
  }

  void setAllowUndoRedo(bool value) {
    allowUndoRedo = value;
    notifyListeners();
  }

  void setTimeLimit(int? value) {
    timeLimit = value ?? 0;
    notifyListeners();
  }

  void setPlayerCount(int? value) {
    if (value != null) {
      playerCount = value;
      playingWithAI = value == 1;
      notifyListeners();
    }
  }

  void setAIDifficulty(int? value) {
    if (value != null) {
      aiDifficulty = value;
      // Save to storage so it persists across app sessions
      Storage.instance.setKingsGambitAIDifficulty(value);
      notifyListeners();
    }
  }

  /// Load AI difficulty from storage
  void loadAIDifficultyFromStorage() {
    aiDifficulty = Storage.instance.getKingsGambitAIDifficulty();
    notifyListeners();
  }

  void setPlayerSide(Player? value) {
    if (value != null) {
      playerSide = value;
      selectedSide = value;
      aiTurn = value == Player.player1 ? Player.player2 : Player.player1;
      notifyListeners();
    }
  }

  void setTheme(int index) {
    if (index >= 0 && index < themeList.length) {
      theme = themeList[index];
      notifyListeners();
    }
  }

  void setPieceTheme(int index) {
    if (index >= 0 && index < pieceThemes.length) {
      pieceTheme = pieceThemes[index];
      notifyListeners();
    }
  }

  void newGame(BuildContext context, {bool notify = true}) {
    // Reset game state
    gameOver = false;
    stalemate = false;

    // Check if it's friend mode (2 players, no AI)
    if (!playingWithAI && playerCount == 2) {
      // Friend mode: 2 players, no AI
      turn = Player.player1; // White always starts in chess
      isAIsTurn = false;
    } else {
      // vsAI mode: Load saved player side from storage, default to player1
      final savedPlayerSideString = Storage.instance.getKingsGambitPlayerSide();
      Player savedPlayerSide = Player.player1;
      if (savedPlayerSideString == 'player2') {
        savedPlayerSide = Player.player2;
      } else if (savedPlayerSideString == 'random') {
        savedPlayerSide = DateTime.now().millisecond % 2 == 0
            ? Player.player1
            : Player.player2;
      }
      playerSide = savedPlayerSide;
      aiTurn = savedPlayerSide == Player.player1
          ? Player.player2
          : Player.player1;

      // If player selected Black, AI (White) goes first
      // If player selected White, Player goes first
      if (savedPlayerSide == Player.player2) {
        // Player is Black, AI (White/Player1) goes first
        turn = Player.player1;
        isAIsTurn = playingWithAI;
      } else {
        // Player is White, Player goes first
        turn = Player.player1;
        isAIsTurn = false;
      }
    }
    moveMetaList.clear();
    promotionRequested = false;
    clearCapturedPieces();

    // Reset timers if time limit is set
    if (timeLimit > 0) {
      player1TimeLeft = Duration(minutes: timeLimit);
      player2TimeLeft = Duration(minutes: timeLimit);
    }

    // Create new game
    final newChessGame = ChessGame(this, context);
    setGame(newChessGame);

    if (notify) {
      notifyListeners();
    }
  }

  void exitChessView() {
    game?.cancelAIMove();
    game = null;
    notifyListeners();
  }

  void addCapturedPiece(ChessPieceType pieceType, Player capturingPlayer) {
    // Add captured piece to the capturing player's list
    if (capturingPlayer == Player.player1) {
      capturedPiecesPlayer1.add(pieceType);
    } else {
      capturedPiecesPlayer2.add(pieceType);
    }
    notifyListeners();
  }

  void removeCapturedPiece(ChessPieceType pieceType, Player capturingPlayer) {
    // Remove captured piece from the capturing player's list
    if (capturingPlayer == Player.player1) {
      capturedPiecesPlayer1.remove(pieceType);
    } else {
      capturedPiecesPlayer2.remove(pieceType);
    }
    notifyListeners();
  }

  void clearCapturedPieces() {
    capturedPiecesPlayer1.clear();
    capturedPiecesPlayer2.clear();
    notifyListeners();
  }
}
