import 'package:equatable/equatable.dart';

enum GameResult { win, loss, draw }

class RecentGameEntity extends Equatable {
  final String opponentName;
  final int opponentRating;
  final GameResult result;
  final DateTime gameDate;
  final int ratingChange;

  const RecentGameEntity({
    required this.opponentName,
    required this.opponentRating,
    required this.result,
    required this.gameDate,
    required this.ratingChange,
  });

  @override
  List<Object> get props => [
        opponentName,
        opponentRating,
        result,
        gameDate,
        ratingChange,
      ];
}

