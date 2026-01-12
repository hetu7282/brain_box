import 'package:brain_box/src/features/kings_gambit/presentation/components/main_menu_view/game_options/side_picker.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/chess_piece.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/shared_functions.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';
import 'package:flutter/cupertino.dart';

class PromotionOption extends StatelessWidget {
  final AppModel appModel;
  final ChessPieceType promotionType;

  const PromotionOption(this.appModel, this.promotionType, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Image(
        image: AssetImage(
          'assets/image/kings_gambit/pieces/${formatPieceTheme(appModel.pieceTheme)}/${pieceTypeToString(promotionType)}_${_playerColor()}.png',
        ),
      ),
      onPressed: () {
        appModel.game?.promote(promotionType);
        appModel.update();
        Navigator.pop(context);
      },
    );
  }

  String _playerColor() {
    return appModel.turn == Player.player1 ? 'white' : 'black';
  }
}
