import 'package:hive_flutter/hive_flutter.dart';

import 'storage_strings.dart';

/// A class for managing storage operations (reading/writing to Hive).
class Storage {
  Storage._();
  static Storage instance = Storage._();

  /// Set the access token in the Hive storage.
  Future<void> setToken(String token) async {
    final box = await Hive.openBox(StorageString.authenticationBoxName);
    await box.put(StorageString.accessToken, token);
  }

  /// Get the access token from the Hive storage.
  String? getToken() {
    final box = Hive.box(StorageString.authenticationBoxName);
    return box.get(StorageString.accessToken, defaultValue: null);
  }

  Future<void> setLanguage(String language) async {
    final box = await Hive.openBox(StorageString.authenticationBoxName);
    await box.put(StorageString.language, language);
  }

  String? getLanguage() {
    final box = Hive.box(StorageString.authenticationBoxName);
    return box.get(
      StorageString.language,
      defaultValue: 'en',
    ); // Default to English
  }

  /// Set music enabled state
  Future<void> setMusicEnabled(bool enabled) async {
    final box = await Hive.openBox(StorageString.authenticationBoxName);
    await box.put(StorageString.musicEnabled, enabled);
  }

  /// Get music enabled state (defaults to true for new installs)
  bool getMusicEnabled() {
    final box = Hive.box(StorageString.authenticationBoxName);
    // If key doesn't exist, return true (first install)
    if (!box.containsKey(StorageString.musicEnabled)) {
      return true;
    }
    return box.get(StorageString.musicEnabled, defaultValue: true);
  }

  /// Set sound enabled state
  Future<void> setSoundEnabled(bool enabled) async {
    final box = await Hive.openBox(StorageString.authenticationBoxName);
    await box.put(StorageString.soundEnabled, enabled);
  }

  /// Get sound enabled state (defaults to true for new installs)
  bool getSoundEnabled() {
    final box = Hive.box(StorageString.authenticationBoxName);
    // If key doesn't exist, return true (first install)
    if (!box.containsKey(StorageString.soundEnabled)) {
      return true;
    }
    return box.get(StorageString.soundEnabled, defaultValue: true);
  }

  /// Set Kings Gambit wins
  Future<void> setKingsGambitWins(int wins) async {
    final box = await Hive.openBox(StorageString.authenticationBoxName);
    await box.put(StorageString.kingsGambitWins, wins);
  }

  /// Get Kings Gambit wins
  int getKingsGambitWins() {
    final box = Hive.box(StorageString.authenticationBoxName);
    return box.get(StorageString.kingsGambitWins, defaultValue: 0);
  }

  /// Set Kings Gambit losses
  Future<void> setKingsGambitLosses(int losses) async {
    final box = await Hive.openBox(StorageString.authenticationBoxName);
    await box.put(StorageString.kingsGambitLosses, losses);
  }

  /// Get Kings Gambit losses
  int getKingsGambitLosses() {
    final box = Hive.box(StorageString.authenticationBoxName);
    return box.get(StorageString.kingsGambitLosses, defaultValue: 0);
  }

  /// Set Kings Gambit draws
  Future<void> setKingsGambitDraws(int draws) async {
    final box = await Hive.openBox(StorageString.authenticationBoxName);
    await box.put(StorageString.kingsGambitDraws, draws);
  }

  /// Get Kings Gambit draws
  int getKingsGambitDraws() {
    final box = Hive.box(StorageString.authenticationBoxName);
    return box.get(StorageString.kingsGambitDraws, defaultValue: 0);
  }

  /// Set Kings Gambit allow undo/redo setting
  Future<void> setKingsGambitAllowUndoRedo(bool enabled) async {
    final box = await Hive.openBox(StorageString.authenticationBoxName);
    await box.put(StorageString.kingsGambitAllowUndoRedo, enabled);
  }

  /// Get Kings Gambit allow undo/redo setting (defaults to true)
  bool getKingsGambitAllowUndoRedo() {
    final box = Hive.box(StorageString.authenticationBoxName);
    if (!box.containsKey(StorageString.kingsGambitAllowUndoRedo)) {
      return true;
    }
    return box.get(StorageString.kingsGambitAllowUndoRedo, defaultValue: true);
  }

  /// Set Kings Gambit show hints setting
  Future<void> setKingsGambitShowHints(bool enabled) async {
    final box = await Hive.openBox(StorageString.authenticationBoxName);
    await box.put(StorageString.kingsGambitShowHints, enabled);
  }

  /// Get Kings Gambit show hints setting (defaults to true)
  bool getKingsGambitShowHints() {
    final box = Hive.box(StorageString.authenticationBoxName);
    if (!box.containsKey(StorageString.kingsGambitShowHints)) {
      return true;
    }
    return box.get(StorageString.kingsGambitShowHints, defaultValue: true);
  }

  /// Set Kings Gambit piece theme
  Future<void> setKingsGambitPieceTheme(String theme) async {
    final box = await Hive.openBox(StorageString.authenticationBoxName);
    await box.put(StorageString.kingsGambitPieceTheme, theme);
  }

  /// Get Kings Gambit piece theme (defaults to 'classic')
  String getKingsGambitPieceTheme() {
    final box = Hive.box(StorageString.authenticationBoxName);
    if (!box.containsKey(StorageString.kingsGambitPieceTheme)) {
      return 'classic';
    }
    return box.get(
      StorageString.kingsGambitPieceTheme,
      defaultValue: 'classic',
    );
  }

  /// Set Kings Gambit app theme
  Future<void> setKingsGambitAppTheme(String themeName) async {
    final box = await Hive.openBox(StorageString.authenticationBoxName);
    await box.put(StorageString.kingsGambitAppTheme, themeName);
  }

  /// Get Kings Gambit app theme (defaults to 'Desert')
  String getKingsGambitAppTheme() {
    final box = Hive.box(StorageString.authenticationBoxName);
    if (!box.containsKey(StorageString.kingsGambitAppTheme)) {
      return 'Desert';
    }
    return box.get(StorageString.kingsGambitAppTheme, defaultValue: 'Desert');
  }

  /// Set Kings Gambit player side
  Future<void> setKingsGambitPlayerSide(String side) async {
    final box = await Hive.openBox(StorageString.authenticationBoxName);
    await box.put(StorageString.kingsGambitPlayerSide, side);
  }

  /// Get Kings Gambit player side (defaults to 'player1')
  String getKingsGambitPlayerSide() {
    final box = Hive.box(StorageString.authenticationBoxName);
    if (!box.containsKey(StorageString.kingsGambitPlayerSide)) {
      return 'player1';
    }
    return box.get(
      StorageString.kingsGambitPlayerSide,
      defaultValue: 'player1',
    );
  }

  /// Set Kings Gambit AI difficulty
  Future<void> setKingsGambitAIDifficulty(int difficulty) async {
    final box = await Hive.openBox(StorageString.authenticationBoxName);
    await box.put(StorageString.kingsGambitAIDifficulty, difficulty);
  }

  /// Get Kings Gambit AI difficulty (defaults to 3)
  int getKingsGambitAIDifficulty() {
    final box = Hive.box(StorageString.authenticationBoxName);
    if (!box.containsKey(StorageString.kingsGambitAIDifficulty)) {
      return 3;
    }
    return box.get(StorageString.kingsGambitAIDifficulty, defaultValue: 3);
  }

  /// Set app theme mode
  Future<void> setAppThemeMode(String themeMode) async {
    final box = await Hive.openBox(StorageString.authenticationBoxName);
    await box.put(StorageString.appThemeMode, themeMode);
  }

  /// Get app theme mode (defaults to 'light')
  String getAppThemeMode() {
    final box = Hive.box(StorageString.authenticationBoxName);
    if (!box.containsKey(StorageString.appThemeMode)) {
      return 'light';
    }
    return box.get(StorageString.appThemeMode, defaultValue: 'light');
  }

  /// Set stop music on background setting
  Future<void> setStopMusicOnBackground(bool enabled) async {
    final box = await Hive.openBox(StorageString.authenticationBoxName);
    await box.put(StorageString.stopMusicOnBackground, enabled);
  }

  /// Get stop music on background setting (defaults to false - music continues in background)
  bool getStopMusicOnBackground() {
    final box = Hive.box(StorageString.authenticationBoxName);
    if (!box.containsKey(StorageString.stopMusicOnBackground)) {
      return false; // Default: music continues in background
    }
    return box.get(StorageString.stopMusicOnBackground, defaultValue: false);
  }

  Future<void> clear() async {
    final authenticationBox = await Hive.openBox(
      StorageString.authenticationBoxName,
    );
    await authenticationBox.delete(StorageString.accessToken);
    await authenticationBox.delete(StorageString.user);
    await authenticationBox.delete(StorageString.recentSearch);
  }
}
