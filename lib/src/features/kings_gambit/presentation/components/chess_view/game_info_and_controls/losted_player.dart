// ignore_for_file: must_be_immutable

import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/main_menu_view/game_options/side_picker.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/chess_piece.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/shared_functions.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LostedPlayer extends StatelessWidget {
  final Player player;
  final List<String>? list; // Keep for backward compatibility

  const LostedPlayer({super.key, this.player = Player.player1, this.list});

  @override
  Widget build(BuildContext context) {
    // If list is provided (backward compatibility), use it
    if (list != null) {
      return _buildFromList(list!);
    }

    // Otherwise, use AppModel to get captured pieces
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        final capturedPieces = player == Player.player1
            ? appModel.capturedPiecesPlayer1
            : appModel.capturedPiecesPlayer2;

        if (capturedPieces.isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildCapturedPieces(capturedPieces, appModel, context);
      },
    );
  }

  Widget _buildFromList(List<String> imageList) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 15),

      decoration: BoxDecoration(
        color: AppColor.k7FC2F4.withOpacityValue(0.15),
        borderRadius: BorderRadius.circular(5.px),
        border: Border.all(
          color: AppColor.k7FC2F4.withOpacityValue(0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacityValue(0.3),
            blurRadius: 15.px,
            offset: Offset(0, 5.px),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Image.asset(imageList[index]);
          },
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemCount: imageList.length,
        ),
      ),
    );
  }

  Widget _buildCapturedPieces(
    List<ChessPieceType> capturedPieces,
    AppModel appModel,
    BuildContext context,
  ) {
    final themeState = context.watch<ThemeCubit>().state;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.px),
        gradient: LinearGradient(
          colors: themeState.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: themeState.lostedPlayerBorderColor!,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacityValue(0.3),
            blurRadius: 15.px,
            offset: Offset(0, 5.px),
          ),
        ],
      ),
      child: SizedBox(
        height: 30,
        width: double.infinity,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final pieceType = capturedPieces[index];
            final pieceName = pieceTypeToString(pieceType);
            // Captured pieces show the color of the original owner (opposite of capturing player)
            // Player1's captured pieces = pieces originally owned by Player2 (black)
            // Player2's captured pieces = pieces originally owned by Player1 (white)
            final color = player == Player.player1 ? 'black' : 'white';
            final imagePath =
                'assets/image/kings_gambit/pieces/${formatPieceTheme(appModel.pieceTheme)}/${pieceName}_$color.png';
            return Image.asset(
              imagePath,
              width: 25,
              height: 25,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(width: 25, height: 25);
              },
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemCount: capturedPieces.length,
        ),
      ),
    );
  }
}
