import 'dart:io';

import 'package:async/async.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/main_menu_view/game_options/side_picker.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/chess_piece_sprite.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/move_calculation/ai_move_calculation.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/move_calculation/move_calculation.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/move_calculation/move_classes/move_meta.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/shared_functions.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'chess_board.dart';
import 'chess_piece.dart';
import 'move_calculation/move_classes/move.dart';

class ChessGame extends FlameGame {
  double? width;
  double? tileSize;
  AppModel appModel;
  BuildContext context;
  ChessBoard board = ChessBoard();
  Map<ChessPiece, ChessPieceSprite> spriteMap = {};

  CancelableOperation? aiOperation;
  List<int> validMoves = [];
  ChessPiece? selectedPiece;
  int? checkHintTile;
  Move? latestMove;

  ChessGame(this.appModel, this.context) : super() {
    // width = MediaQuery.of(context).size.width - 68;/
    width = Platform.isMacOS
        ? MediaQuery.of(context).size.width - 685
        : MediaQuery.of(context).size.width - 68;
    // width =1235;
    tileSize = Platform.isMacOS ? (width ?? 0) / 10 : (width ?? 0) / 8;
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece] = ChessPieceSprite(piece, appModel.pieceTheme);
    }
    _initSpritePositions();
    if (appModel.isAIsTurn) {
      _aiMove();
    }
  }

  void handleTap(Vector2 position) {
    if (appModel.gameOver || !(appModel.isAIsTurn)) {
      var tile = _vector2ToTile(position);
      var touchedPiece = board.tiles[tile];
      if (touchedPiece == selectedPiece) {
        validMoves = [];

        selectedPiece = null;
      } else {
        if (selectedPiece != null &&
            touchedPiece != null &&
            touchedPiece.player == selectedPiece?.player) {
          if (validMoves.contains(tile)) {
            _movePiece(tile);
          } else {
            validMoves = [];
            _selectPiece(touchedPiece);
          }
        } else if (selectedPiece == null) {
          _selectPiece(touchedPiece);
        } else {
          _movePiece(tile);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _drawBoard(canvas);
    if (appModel.showHints) {
      _drawCheckHint(canvas);
      _drawLatestMove(canvas);
    }
    _drawSelectedPieceHint(canvas);
    _drawPieces(canvas);
    if (appModel.showHints) {
      _drawMoveHints(canvas);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]?.update(tileSize ?? 0, appModel, piece);
    }
  }

  void _initSpritePositions() {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]?.initSpritePosition(tileSize ?? 0, appModel);
    }
  }

  void _selectPiece(ChessPiece? piece) {
    if (piece != null) {
      if (piece.player == appModel.turn) {
        selectedPiece = piece;
        if (selectedPiece != null) {
          validMoves = movesForPiece(piece, board);
        }
        if (validMoves.isEmpty) {
          selectedPiece = null;
        }
      }
    }
  }

  void _movePiece(int tile) {
    if (validMoves.contains(tile)) {
      validMoves = [];
      var meta = push(
        Move(selectedPiece?.tile ?? 0, tile),
        board,
        getMeta: true,
      );
      if (meta.promotion) {
        appModel.requestPromotion();
      }
      _moveCompletion(meta, changeTurn: !meta.promotion);
    }
  }

  void _aiMove() async {
    await Future.delayed(const Duration(milliseconds: 500));
    var args = {};
    args['aiPlayer'] = appModel.aiTurn;
    args['aiDifficulty'] = appModel.aiDifficulty;
    args['board'] = board;
    aiOperation = CancelableOperation.fromFuture(
      compute(calculateAIMove, args),
    );
    aiOperation?.value.then((move) {
      if (move == null || appModel.gameOver) {
        appModel.endGame();
      } else {
        validMoves = [];
        var meta = push(move, board, getMeta: true);
        _moveCompletion(meta, changeTurn: !meta.promotion);
        if (meta.promotion) {
          promote(move.promotionType);
        }
      }
    });
  }

  void cancelAIMove() {
    aiOperation?.cancel();
  }

  void undoMove() {
    var poppedMove = pop(board);
    board.redoStack.add(poppedMove);

    // Handle captured piece removal if the undone move captured a piece
    if (appModel.moveMetaList.isNotEmpty) {
      var undoneMeta = appModel.moveMetaList.last;
      if (undoneMeta.took &&
          undoneMeta.capturedPieceType != null &&
          undoneMeta.capturedPiecePlayer != null &&
          undoneMeta.player != null) {
        // The player who made the move (undoneMeta.player) is the capturing player
        appModel.removeCapturedPiece(
          undoneMeta.capturedPieceType!,
          undoneMeta.player!,
        );
      }
    }

    if (appModel.moveMetaList.length > 1) {
      var meta = appModel.moveMetaList[appModel.moveMetaList.length - 2];
      _moveCompletion(meta, clearRedo: false, undoing: true);
    } else {
      _undoOpeningMove();
      appModel.changeTurn();
    }
  }

  void undoTwoMoves() {
    var poppedMove1 = pop(board);
    var poppedMove2 = pop(board);
    board.redoStack.add(poppedMove1);
    board.redoStack.add(poppedMove2);

    // Handle captured pieces removal for both undone moves
    // Most recent move is at the end of moveMetaList
    if (appModel.moveMetaList.isNotEmpty) {
      // Remove captured piece from the most recent move
      var undoneMeta2 = appModel.moveMetaList.last;
      if (undoneMeta2.took &&
          undoneMeta2.capturedPieceType != null &&
          undoneMeta2.capturedPiecePlayer != null &&
          undoneMeta2.player != null) {
        appModel.removeCapturedPiece(
          undoneMeta2.capturedPieceType!,
          undoneMeta2.player!,
        );
      }
      appModel.popMoveMeta();
    }

    // Now handle the previous move
    if (appModel.moveMetaList.isNotEmpty) {
      // Remove captured piece from the previous move
      var undoneMeta1 = appModel.moveMetaList.last;
      if (undoneMeta1.took &&
          undoneMeta1.capturedPieceType != null &&
          undoneMeta1.capturedPiecePlayer != null &&
          undoneMeta1.player != null) {
        appModel.removeCapturedPiece(
          undoneMeta1.capturedPieceType!,
          undoneMeta1.player!,
        );
      }
      appModel.popMoveMeta();
    }

    if (appModel.moveMetaList.isNotEmpty) {
      _moveCompletion(
        appModel.moveMetaList.last,
        clearRedo: false,
        undoing: true,
        changeTurn: false,
      );
    } else {
      _undoOpeningMove();
    }
  }

  void _undoOpeningMove() {
    selectedPiece = null;
    validMoves = [];
    latestMove = null;
    checkHintTile = null;
    appModel.popMoveMeta();
  }

  void redoMove() {
    var msoToRedo = board.redoStack.removeLast();
    var meta = pushMSO(msoToRedo, board);
    // _moveCompletion will handle adding captured pieces for redo
    _moveCompletion(meta, clearRedo: false, updateMetaList: false);
  }

  void redoTwoMoves() {
    // Redo first move (second-to-last in redo stack, since stack is LIFO)
    var msoToRedo1 = board.redoStack[board.redoStack.length - 2];
    var meta1 = pushMSO(msoToRedo1, board);
    // _moveCompletion will handle adding captured pieces for redo
    _moveCompletion(meta1, clearRedo: false, updateMetaList: true);

    // Redo second move (last in redo stack)
    var msoToRedo2 = board.redoStack.removeLast();
    var meta2 = pushMSO(msoToRedo2, board);
    // _moveCompletion will handle adding captured pieces for redo
    _moveCompletion(meta2, clearRedo: false, updateMetaList: true);
  }

  void promote(ChessPieceType type) {
    board.moveStack.last.movedPiece?.type = type;
    board.moveStack.last.promotionType = type;
    addPromotedPiece(board, board.moveStack.last);
    appModel.moveMetaList.last.promotionType = type;
    _moveCompletion(appModel.moveMetaList.last, updateMetaList: false);
  }

  void _moveCompletion(
    MoveMeta meta, {
    bool clearRedo = true,
    bool undoing = false,
    bool changeTurn = true,
    bool updateMetaList = true,
  }) {
    if (clearRedo) {
      board.redoStack = [];
    }
    validMoves = [];
    latestMove = meta.move;
    checkHintTile = null;
    var oppositeTurn = oppositePlayer(appModel.turn);
    if (kingInCheck(oppositeTurn, board)) {
      meta.isCheck = true;
      checkHintTile = kingForPlayer(oppositeTurn, board)?.tile;
    }
    if (kingInCheckmate(oppositeTurn, board)) {
      if (!meta.isCheck) {
        appModel.stalemate = true;
        meta.isStalemate = true;
      }
      meta.isCheck = false;
      meta.isCheckmate = true;
      appModel.endGame();
    }

    // Track captured pieces (only for normal moves, not undo/redo which handle it separately)
    if (meta.took && meta.capturedPieceType != null && meta.capturedPiecePlayer != null && !undoing) {
      // A piece was captured - add it to the capturing player's list
      // The capturing player is the player who made the move (meta.player)
      if (meta.player != null) {
        appModel.addCapturedPiece(
          meta.capturedPieceType!,
          meta.player!,
        );
      }
    }

    if (undoing) {
      appModel.popMoveMeta();
      appModel.undoEndGame();
    } else if (updateMetaList) {
      appModel.pushMoveMeta(meta);
    }
    if (changeTurn) {
      appModel.changeTurn();
    }
    selectedPiece = null;
    if (appModel.isAIsTurn && clearRedo && changeTurn) {
      _aiMove();
    }
  }

  int _vector2ToTile(Vector2 vector2) {
    // If player selected Black (Player.player2), flip the coordinates
    if (appModel.playingWithAI && appModel.playerSide == Player.player2) {
      return (7 - (vector2.y / (tileSize ?? 0)).floor()) * 8 +
          (7 - (vector2.x / (tileSize ?? 0)).floor());
    } else {
      return (vector2.y / (tileSize ?? 0)).floor() * 8 +
          (vector2.x / (tileSize ?? 0)).floor();
    }
  }

  void _drawBoard(Canvas canvas) {
    for (int tileNo = 0; tileNo < 64; tileNo++) {
      canvas.drawRect(
        Rect.fromLTWH(
          (tileNo % 8) * (tileSize ?? 0),
          (tileNo / 8).floor() * (tileSize ?? 0),
          (tileSize ?? 0),
          (tileSize ?? 0),
        ),
        Paint()
          ..color = (tileNo + (tileNo / 8).floor()) % 2 == 0
              ? appModel.theme.lightTile
              : appModel.theme.darkTile,
      );
    }
  }

  void _drawPieces(Canvas canvas) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]?.sprite?.render(
        canvas,
        size: Vector2((tileSize ?? 0) - 10, (tileSize ?? 0) - 10),
        position: Vector2(
          (spriteMap[piece]?.spriteX ?? 0) + 5,
          (spriteMap[piece]?.spriteY ?? 0) + 5,
        ),
      );
    }
  }

  void _drawMoveHints(Canvas canvas) {
    for (var tile in validMoves) {
      canvas.drawCircle(
        Offset(
          getXFromTile(tile, (tileSize ?? 0), appModel) + ((tileSize ?? 0) / 2),
          getYFromTile(tile, (tileSize ?? 0), appModel) + ((tileSize ?? 0) / 2),
        ),
        (tileSize ?? 0) / 5,
        Paint()..color = appModel.theme.moveHint,
      );
    }
  }

  void _drawLatestMove(Canvas canvas) {
    if (latestMove != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(latestMove!.from, tileSize ?? 0, appModel),
          getYFromTile(latestMove!.from, tileSize ?? 0, appModel),
          tileSize ?? 0,
          tileSize ?? 0,
        ),
        Paint()..color = appModel.theme.latestMove,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(latestMove!.to, tileSize ?? 0, appModel),
          getYFromTile(latestMove!.to, tileSize ?? 0, appModel),
          tileSize ?? 0,
          tileSize ?? 0,
        ),
        Paint()..color = appModel.theme.latestMove,
      );
    }
  }

  void _drawCheckHint(Canvas canvas) {
    if (checkHintTile != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(checkHintTile!, tileSize ?? 0, appModel),
          getYFromTile(checkHintTile!, tileSize ?? 0, appModel),
          tileSize ?? 0,
          tileSize ?? 0,
        ),
        Paint()..color = appModel.theme.checkHint,
      );
    }
  }

  void _drawSelectedPieceHint(Canvas canvas) {
    if (selectedPiece != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(selectedPiece!.tile, tileSize ?? 0, appModel),
          getYFromTile(selectedPiece!.tile, tileSize ?? 0, appModel),
          tileSize ?? 0,
          tileSize ?? 0,
        ),
        Paint()..color = appModel.theme.moveHint,
      );
    }
  }
}
