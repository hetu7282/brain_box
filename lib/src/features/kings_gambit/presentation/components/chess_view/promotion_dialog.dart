import 'package:flutter/cupertino.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/chess_piece.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/chess_view/promotion_option.dart';

final PROMOTIONS = [
  ChessPieceType.queen,
  ChessPieceType.rook,
  ChessPieceType.bishop,
  ChessPieceType.knight
];

class PromotionDialog extends StatelessWidget {
  final AppModel appModel;

  const PromotionDialog(this.appModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      actions: [
        SizedBox(
          height: 66,
          child: Row(
            children: PROMOTIONS
                .map(
                  (promotionType) => PromotionOption(
                    appModel,
                    promotionType,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
