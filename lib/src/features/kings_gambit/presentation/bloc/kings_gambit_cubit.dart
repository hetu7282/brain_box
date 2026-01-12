import 'package:brain_box/src/core/database/storage.dart';
import 'package:brain_box/src/core/utils/log.dart';
import 'package:brain_box/src/features/kings_gambit/domain/entity/recent_game_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'kings_gambit_state.dart';

class KingsGambitCubit extends Cubit<KingsGambitState> {
  final Storage _storage = Storage.instance;

  KingsGambitCubit() : super(_loadInitialState()) {
    Log.d('Kings Gambit Cubit initialized');
  }

  /// Load initial state from storage
  static KingsGambitState _loadInitialState() {
    try {
      final storage = Storage.instance;
      final wins = storage.getKingsGambitWins();
      final losses = storage.getKingsGambitLosses();
      final draws = storage.getKingsGambitDraws();

      Log.d(
        'Kings Gambit statistics loaded: wins=$wins, losses=$losses, draws=$draws',
      );
      return KingsGambitState(
        wins: wins,
        losses: losses,
        draws: draws,
        selectedGameMode: null,
        recentGames: _getDummyRecentGames(),
      );
    } catch (e) {
      Log.e('Error loading Kings Gambit statistics: $e');
      return KingsGambitState.initial().copyWith(
        recentGames: _getDummyRecentGames(),
      );
    }
  }

  /// Get dummy recent games data
  static List<RecentGameEntity> _getDummyRecentGames() {
    final now = DateTime.now();
    return [
      RecentGameEntity(
        opponentName: 'AndrewMaster',
        opponentRating: 1805,
        result: GameResult.win,
        gameDate: now,
        ratingChange: 8,
      ),
      RecentGameEntity(
        opponentName: 'ChessQueen',
        opponentRating: 1920,
        result: GameResult.loss,
        gameDate: now.subtract(const Duration(days: 1)),
        ratingChange: -10,
      ),
      RecentGameEntity(
        opponentName: 'GrandMaster44',
        opponentRating: 1945,
        result: GameResult.win,
        gameDate: DateTime(now.year, 8, 21),
        ratingChange: 15,
      ),
    ];
  }

  /// Set selected game mode
  void selectGameMode(GameMode? mode) {
    emit(state.copyWith(selectedGameMode: mode));
    Log.d('Game mode selected: $mode');
  }

  /// Increment wins
  Future<void> incrementWins() async {
    try {
      final newWins = state.wins + 1;
      await _storage.setKingsGambitWins(newWins);
      emit(state.copyWith(wins: newWins));
      Log.d('Kings Gambit wins incremented: $newWins');
    } catch (e) {
      Log.e('Error incrementing wins: $e');
    }
  }

  /// Increment losses
  Future<void> incrementLosses() async {
    try {
      final newLosses = state.losses + 1;
      await _storage.setKingsGambitLosses(newLosses);
      emit(state.copyWith(losses: newLosses));
      Log.d('Kings Gambit losses incremented: $newLosses');
    } catch (e) {
      Log.e('Error incrementing losses: $e');
    }
  }

  /// Increment draws
  Future<void> incrementDraws() async {
    try {
      final newDraws = state.draws + 1;
      await _storage.setKingsGambitDraws(newDraws);
      emit(state.copyWith(draws: newDraws));
      Log.d('Kings Gambit draws incremented: $newDraws');
    } catch (e) {
      Log.e('Error incrementing draws: $e');
    }
  }

  /// Reset statistics
  Future<void> resetStatistics() async {
    try {
      await _storage.setKingsGambitWins(0);
      await _storage.setKingsGambitLosses(0);
      await _storage.setKingsGambitDraws(0);
      emit(const KingsGambitState(wins: 0, losses: 0, draws: 0));
      Log.d('Kings Gambit statistics reset');
    } catch (e) {
      Log.e('Error resetting statistics: $e');
    }
  }
}
