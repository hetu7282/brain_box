part of 'kings_gambit_settings_cubit.dart';

class KingsGambitSettingsState extends Equatable {
  final bool showHints;
  final bool allowUndoRedo;
  final ChessTheme selectedTheme;
  final String selectedPieceTheme; // display name used in UI
  final Player selectedPlayerSide;
  final int selectedAIDifficulty;

  const KingsGambitSettingsState({
    required this.showHints,
    required this.allowUndoRedo,
    required this.selectedTheme,
    required this.selectedPieceTheme,
    required this.selectedPlayerSide,
    required this.selectedAIDifficulty,
  });

  factory KingsGambitSettingsState.initial() => KingsGambitSettingsState(
        showHints: true,
        allowUndoRedo: true,
        selectedTheme: AppModel.themeList.first,
        selectedPieceTheme: kKingsGambitPieceThemes.first,
        selectedPlayerSide: Player.player1,
        selectedAIDifficulty: 3,
      );

  KingsGambitSettingsState copyWith({
    bool? showHints,
    bool? allowUndoRedo,
    ChessTheme? selectedTheme,
    String? selectedPieceTheme,
    Player? selectedPlayerSide,
    int? selectedAIDifficulty,
  }) {
    return KingsGambitSettingsState(
      showHints: showHints ?? this.showHints,
      allowUndoRedo: allowUndoRedo ?? this.allowUndoRedo,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      selectedPieceTheme: selectedPieceTheme ?? this.selectedPieceTheme,
      selectedPlayerSide: selectedPlayerSide ?? this.selectedPlayerSide,
      selectedAIDifficulty: selectedAIDifficulty ?? this.selectedAIDifficulty,
    );
  }

  @override
  List<Object?> get props => [
        showHints,
        allowUndoRedo,
        selectedTheme,
        selectedPieceTheme,
        selectedPlayerSide,
        selectedAIDifficulty,
      ];
}

