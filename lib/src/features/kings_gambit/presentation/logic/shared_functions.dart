import 'package:brain_box/src/features/kings_gambit/presentation/components/main_menu_view/game_options/side_picker.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/chess_piece.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';

int tileToRow(int tile) {
  return (tile / 8).floor();
}

int tileToCol(int tile) {
  return tile % 8;
}

double getXFromTile(int tile, double tileSize, AppModel appModel) {
  // If player selected Black (Player.player2), flip the board horizontally
  if (appModel.playingWithAI && appModel.playerSide == Player.player2) {
    return (7 - tileToCol(tile)) * tileSize;
  }
  return tileToCol(tile) * tileSize;
}

double getYFromTile(int tile, double tileSize, AppModel appModel) {
  // If player selected Black (Player.player2), flip the board vertically
  // This puts black pieces at the bottom
  if (appModel.playingWithAI && appModel.playerSide == Player.player2) {
    return (7 - tileToRow(tile)) * tileSize;
  }
  return tileToRow(tile) * tileSize;
}

Player oppositePlayer(Player player) {
  return player == Player.player1 ? Player.player2 : Player.player1;
}

String formatPieceTheme(String themeString) {
  // Convert to lowercase and remove spaces
  String formatted = themeString.toLowerCase().replaceAll(' ', '');

  // Handle special case: directory is "8-bit" but storage format is "8bit"
  if (formatted == '8bit') {
    return '8-bit';
  }

  return formatted;
}

String pieceTypeToString(ChessPieceType type) {
  return type.toString().substring(type.toString().indexOf('.') + 1);
}
