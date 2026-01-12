import 'package:equatable/equatable.dart';

class PuzzleStatistics extends Equatable {
  final int elapsedSeconds;
  final int moves;
  final int difficulty;

  const PuzzleStatistics({
    required this.elapsedSeconds,
    required this.moves,
    required this.difficulty,
  });

  String get formattedTime {
    final minutes = elapsedSeconds ~/ 60;
    final seconds = elapsedSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get difficultyName {
    switch (difficulty) {
      case 2:
        return 'Easy';
      case 5:
        return 'Medium';
      case 10:
        return 'Hard';
      default:
        return 'Medium';
    }
  }

  @override
  List<Object?> get props => [elapsedSeconds, moves, difficulty];
}

