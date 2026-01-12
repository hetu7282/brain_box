import 'dart:ui' as ui;

import 'package:brain_box/src/features/kings_gambit/presentation/logic/shared_functions.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class PiecePreview extends Game {
  AppModel appModel;
  final bool showPieces;

  Map<int, String> get imageMap {
    return {
      0: 'assets/image/kings_gambit/pieces/${formatPieceTheme(appModel.pieceTheme)}/king_black.png',
      1: 'assets/image/kings_gambit/pieces/${formatPieceTheme(appModel.pieceTheme)}/queen_white.png',
      2: 'assets/image/kings_gambit/pieces/${formatPieceTheme(appModel.pieceTheme)}/bishop_black.png',
      3: 'assets/image/kings_gambit/pieces/${formatPieceTheme(appModel.pieceTheme)}/rook_white.png',
      4: 'assets/image/kings_gambit/pieces/${formatPieceTheme(appModel.pieceTheme)}/knight_black.png',
      5: 'assets/image/kings_gambit/pieces/${formatPieceTheme(appModel.pieceTheme)}/pawn_white.png',
    };
  }

  Map<int, Sprite> spriteMap = {};
  bool rendered = false;

  PiecePreview(this.appModel, {this.showPieces = false}) {
    if (showPieces) {
      loadSpriteImages();
    }
  }

  loadSpriteImages() async {
    for (var index = 0; index < 6; index++) {
      final imagePath = imageMap[index] ?? "";
      if (imagePath.isNotEmpty) {
        final ByteData data = await rootBundle.load(imagePath);
        final ui.Codec codec = await ui.instantiateImageCodec(
          data.buffer.asUint8List(),
        );
        final ui.FrameInfo frameInfo = await codec.getNextFrame();
        spriteMap[index] = Sprite(frameInfo.image);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final double boxSize = showPieces
        ? 25.0
        : 15.0; // Reduced from 40 to 25 for better fit
    const double spacing = 1.0; // Small spacing between boxes
    // Horizontal layout for pieces (6 columns x 1 row), vertical for board theme (3 columns x 3 rows)
    final int columns = 3;
    final int totalBoxes = showPieces ? 6 : 9;

    for (var index = 0; index < totalBoxes; index++) {
      final col = index % columns;
      final row = (index / columns).floor();
      final x = col * (boxSize + spacing);
      final y = row * (boxSize + spacing);

      if (showPieces) {
        // Horizontal layout for pieces - alternating colors in a row
        canvas.drawRect(
          Rect.fromLTWH(x, y, boxSize, boxSize),
          Paint()
            ..color = index % 2 == 0
                ? appModel.theme.lightTile
                : appModel.theme.darkTile,
        );
      } else {
        // Vertical layout for board theme - checkerboard pattern
        canvas.drawRect(
          Rect.fromLTWH(x, y, boxSize, boxSize),
          Paint()
            ..color = (index) % 2 == 0
                ? appModel.theme.lightTile
                : appModel.theme.darkTile,
        );
      }

      // Render piece sprites if available (only when showPieces is true)
      if (showPieces && spriteMap.containsKey(index) && index < 6) {
        spriteMap[index]?.render(
          canvas,
          size: Vector2(boxSize - 10, boxSize - 10),
          position: Vector2(x + 5, y + 5),
        );
      }
    }
  }

  @override
  void update(double t) {}
}
