import 'dart:io';

import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/main_menu_view/game_options/side_picker.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameStatus extends StatelessWidget {
  const GameStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: Platform.isMacOS ? null : 50,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: themeState.lostedPlayerBackgroundColor!,
                borderRadius: BorderRadius.circular(5.px),
                border: Border.all(
                  color: themeState.lostedPlayerBorderColor!,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: themeState.lostedPlayerShadowColor!,
                    blurRadius: 15.px,
                    offset: Offset(0, 5.px),
                  ),
                ],
              ),
              child: CustomText(
                text: _getStatus(appModel),
                textAlign: TextAlign.center,
                color: Colors.white,
                fontSize: 25.px,
              ),
            ),
          ),
          !appModel.gameOver && appModel.playerCount == 1 && appModel.isAIsTurn
              ? const CupertinoActivityIndicator(radius: 12)
              : Container(),
        ],
      ),
    );
  }

  String _getStatus(AppModel appModel) {
    if (!appModel.gameOver) {
      if (appModel.playerCount == 1) {
        if (appModel.isAIsTurn) {
          return 'AI turn ';
        } else {
          return 'Your turn';
        }
      } else {
        if (appModel.turn == Player.player1) {
          return 'White\'s turn';
        } else {
          return 'Black\'s turn';
        }
      }
    } else {
      if (appModel.stalemate) {
        return 'Stalemate';
      } else {
        if (appModel.playerCount == 1) {
          if (appModel.isAIsTurn) {
            return 'You Win!';
          } else {
            return 'You Lose :(';
          }
        } else {
          if (appModel.turn == Player.player1) {
            return 'Black wins!';
          } else {
            return 'White wins!';
          }
        }
      }
    }
  }
}
