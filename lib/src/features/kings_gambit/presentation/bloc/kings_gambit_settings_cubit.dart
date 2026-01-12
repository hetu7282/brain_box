import 'package:brain_box/src/core/database/storage.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/main_menu_view/game_options/side_picker.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/constants/kings_gambit_constants.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'kings_gambit_settings_state.dart';

class KingsGambitSettingsCubit extends Cubit<KingsGambitSettingsState> {
  final Storage _storage = Storage.instance;

  KingsGambitSettingsCubit() : super(KingsGambitSettingsState.initial()) {
    _loadSettings();
  }

  void _loadSettings() {
    final allowUndoRedo = _storage.getKingsGambitAllowUndoRedo();
    final showHints = _storage.getKingsGambitShowHints();
    final savedPieceTheme = _storage.getKingsGambitPieceTheme();
    final savedAppTheme = _storage.getKingsGambitAppTheme();
    final savedPlayerSide = _storage.getKingsGambitPlayerSide();
    final savedDifficulty = _storage.getKingsGambitAIDifficulty();

    emit(
      state.copyWith(
        allowUndoRedo: allowUndoRedo,
        showHints: showHints,
        selectedPieceTheme: _displayNameFromFormattedTheme(savedPieceTheme),
        selectedTheme: _themeFromName(savedAppTheme),
        selectedPlayerSide: _playerFromString(savedPlayerSide),
        selectedAIDifficulty: _mapDifficultyToOption(savedDifficulty),
      ),
    );
  }

  void toggleAllowUndoRedo(bool value) {
    _storage.setKingsGambitAllowUndoRedo(value);
    emit(state.copyWith(allowUndoRedo: value));
  }

  void toggleShowHints(bool value) {
    _storage.setKingsGambitShowHints(value);
    emit(state.copyWith(showHints: value));
  }

  void selectTheme(ChessTheme theme) {
    _storage.setKingsGambitAppTheme(theme.name);
    emit(state.copyWith(selectedTheme: theme));
  }

  void selectPieceTheme(String themeDisplayName) {
    final formatted = _formatThemeName(themeDisplayName);
    _storage.setKingsGambitPieceTheme(formatted);
    emit(state.copyWith(selectedPieceTheme: themeDisplayName));
  }

  void selectAIDifficulty(int difficulty) {
    _storage.setKingsGambitAIDifficulty(difficulty);
    emit(state.copyWith(selectedAIDifficulty: difficulty));
  }

  void selectPlayerSide(Player player) {
    _storage.setKingsGambitPlayerSide(_playerToString(player));
    emit(state.copyWith(selectedPlayerSide: player));
  }

  // Helpers
  String _displayNameFromFormattedTheme(String formattedTheme) {
    for (final theme in kKingsGambitPieceThemes) {
      if (_formatThemeName(theme) == formattedTheme) {
        return theme;
      }
    }
    return kKingsGambitPieceThemes.first;
  }

  String _formatThemeName(String displayName) {
    return displayName.toLowerCase().replaceAll(' ', '').replaceAll('-', '');
  }

  ChessTheme _themeFromName(String name) {
    return AppModel.themeList.firstWhere(
      (theme) => theme.name == name,
      orElse: () => AppModel.themeList.firstWhere(
        (theme) => theme.name == 'Desert',
        orElse: () => AppModel.themeList.first,
      ),
    );
  }

  Player _playerFromString(String side) {
    switch (side) {
      case 'player2':
        return Player.player2;
      case 'random':
        return Player.random;
      case 'player1':
      default:
        return Player.player1;
    }
  }

  String _playerToString(Player player) {
    switch (player) {
      case Player.player2:
        return 'player2';
      case Player.random:
        return 'random';
      case Player.player1:
      default:
        return 'player1';
    }
  }

  int _mapDifficultyToOption(int difficulty) {
    if (difficulty <= 2) return 2;
    if (difficulty <= 4) return 3;
    return 5;
  }
}
