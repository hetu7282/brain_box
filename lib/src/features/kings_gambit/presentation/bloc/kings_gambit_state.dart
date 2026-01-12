import 'package:brain_box/src/features/kings_gambit/domain/entity/recent_game_entity.dart';
import 'package:equatable/equatable.dart';

enum GameMode { vsAI, friend }

class _Undefined {
  const _Undefined();
}

const _undefined = _Undefined();

class KingsGambitState extends Equatable {
  final int wins;
  final int losses;
  final int draws;
  final GameMode? selectedGameMode;
  final List<RecentGameEntity> recentGames;

  const KingsGambitState({
    required this.wins,
    required this.losses,
    required this.draws,
    this.selectedGameMode,
    this.recentGames = const [],
  });

  factory KingsGambitState.initial() {
    return const KingsGambitState(
      wins: 0,
      losses: 0,
      draws: 0,
      selectedGameMode: null,
      recentGames: [],
    );
  }

  KingsGambitState copyWith({
    int? wins,
    int? losses,
    int? draws,
    Object? selectedGameMode = _undefined,
    List<RecentGameEntity>? recentGames,
  }) {
    return KingsGambitState(
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
      selectedGameMode: selectedGameMode == _undefined
          ? this.selectedGameMode
          : selectedGameMode as GameMode?,
      recentGames: recentGames ?? this.recentGames,
    );
  }

  @override
  List<Object?> get props => [
        wins,
        losses,
        draws,
        selectedGameMode,
        recentGames,
      ];
}
