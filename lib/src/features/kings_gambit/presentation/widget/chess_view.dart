import 'dart:async';
import 'dart:io';

import 'package:brain_box/src/features/kings_gambit/presentation/components/chess_view/chess_board_widget.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/chess_view/game_info_and_controls.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/chess_view/game_info_and_controls/game_status.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/chess_view/game_info_and_controls/losted_player.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/chess_view/promotion_dialog.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/shared/bottom_padding.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChessView extends StatefulWidget {
  final AppModel appModel;

  const ChessView(this.appModel, {super.key});

  @override
  _ChessViewState createState() => _ChessViewState(appModel);
}

class _ChessViewState extends State<ChessView> {
  AppModel appModel;

  _ChessViewState(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        if (appModel.promotionRequested) {
          appModel.promotionRequested = false;
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _showPromotionDialog(appModel),
          );
        }
        return WillPopScope(
          onWillPop: _willPopCallback,
          child: Scaffold(
            body: Container(
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //       image: const AssetImage(
              //         'assets/chess_bg.png', // TODO: Add chess background asset
              //       ),
              //       fit: Platform.isMacOS ? BoxFit.cover : BoxFit.fitHeight,
              //       opacity: 0.6),
              // ),
              padding: const EdgeInsets.all(30),
              child: Platform.isMacOS
                  ? Row(
                      children: [
                        // const Spacer(),
                        // Expanded(
                        //   child: LostedPlayer(
                        //     list: const [
                        //       Assets.assetsImagesPiecesClassicBishopBlack
                        //     ],
                        //   ),
                        // ),
                        Expanded(flex: 4, child: ChessBoardWidget(appModel)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Column(
                              children: [
                                const Expanded(child: GameStatus()),
                                Expanded(child: GameInfoAndControls(appModel)),
                              ],
                            ),
                          ),
                        ),
                        // const Expanded(child: BottomPadding()),
                      ],
                    )
                  : Column(
                      children: [
                        // const Spacer(),
                        LostedPlayer(
                          list: const [
                            // 'assets/images/pieces/classic/bishop_black.png' // TODO: Add asset path
                          ],
                        ),
                        ChessBoardWidget(appModel),
                        const SizedBox(height: 20),
                        const GameStatus(),
                        LostedPlayer(list: const []),

                        const SizedBox(height: 10),
                        GameInfoAndControls(appModel),
                        const BottomPadding(),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  void _showPromotionDialog(AppModel appModel) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PromotionDialog(appModel);
      },
    );
  }

  Future<bool> _willPopCallback() async {
    appModel.exitChessView();

    return true;
  }
}
