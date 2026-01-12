import 'dart:developer';

import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/main_menu_view/game_options/side_picker.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/chess_piece.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/move_calculation/move_classes/move_meta.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/shared_functions.dart';
import 'package:flutter/material.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';

import '../../../../model/app_model.dart';

class MoveList extends StatelessWidget {
  final AppModel appModel;
  final ScrollController scrollController = ScrollController();

  MoveList(this.appModel, {super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.brown.withOpacityValue(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Center(
          child: CustomText(
            text: _allMoves(),
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    if (appModel.moveListUpdated) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      appModel.moveListUpdated = false;
    }
  }

  String _allMoves() {
    var moveString = '';
    appModel.moveMetaList.asMap().forEach((index, move) {
      var turnNumber = ((index + 1) / 2).ceil();
      if (index % 2 == 0) {
        moveString += index == 0 ? '$turnNumber. ' : '   $turnNumber. ';
      }
      moveString += _moveToString(move);
      if (index % 2 == 0) {
        moveString += ' ';
      }
    });
    if (appModel.gameOver) {
      if (appModel.turn == Player.player1) {
        moveString += ' ';
      }
      if (appModel.stalemate) {
        moveString += '  ½-½';
      } else {
        moveString += appModel.turn == Player.player2 ? '  1-0' : '  0-1';
      }
    }
    return moveString;
  }

  String _moveToString(MoveMeta meta) {
    String move;
    if (meta.kingCastle) {
      move = 'O-O';
    } else if (meta.queenCastle) {
      move = 'O-O-O';
    } else {
      String ambiguity = meta.rowIsAmbiguous
          ? _colToChar(tileToCol(meta.move?.from ?? 0))
          : '';
      ambiguity += meta.colIsAmbiguous
          ? '${8 - tileToRow(meta.move?.from ?? 0)}'
          : '';
      String takeString = meta.took ? 'x' : '';
      String promotion = meta.promotion
          ? '=${_pieceToChar(meta.promotionType ?? ChessPieceType.promotion)}'
          : '';
      String row = '${8 - tileToRow(meta.move?.to ?? 0)}';
      String col = _colToChar(tileToCol(meta.move?.to ?? 0));
      move =
          '${_pieceToChar(meta.type ?? ChessPieceType.promotion)}$ambiguity$takeString'
          '$col$row$promotion';
    }
    String check = meta.isCheck ? '+' : '';
    String checkmate = meta.isCheckmate && !meta.isStalemate ? '#' : '';
    return '$move$check$checkmate';
  }

  String _pieceToChar(ChessPieceType type) {
    switch (type) {
      case ChessPieceType.king:
        {
          log("walk king");
          return 'K';
        }
      case ChessPieceType.queen:
        {
          log("walk queen");
          return 'Q';
        }
      case ChessPieceType.rook:
        {
          log("walk rook");
          return 'R';
        }
      case ChessPieceType.bishop:
        {
          log("walk bishop");
          return 'B';
        }
      case ChessPieceType.knight:
        {
          log("walk knight");
          return 'N';
        }
      case ChessPieceType.pawn:
        {
          log("walk pawn");
          return '';
        }
      default:
        {
          return '?';
        }
    }
  }

  String _colToChar(int col) {
    return String.fromCharCode(97 + col);
  }
}
