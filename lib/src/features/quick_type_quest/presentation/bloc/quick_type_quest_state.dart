part of 'quick_type_quest_cubit.dart';

enum Difficulty { easy, medium, hard }

enum GameState { idle, playing, finished }

class QuickTypeQuestState extends Equatable {
  final Difficulty selectedDifficulty;
  final GameState gameState;
  final int wpm;
  final int accuracy;
  final int timeRemaining;
  final TypingContext? typingContext;
  final String challengeText;
  final String previousTextFieldValue;
  final int totalCharacters;
  final int correctCharacters;
  final int startTime;
  final int typingVersion;

  const QuickTypeQuestState({
    required this.selectedDifficulty,
    required this.gameState,
    required this.wpm,
    required this.accuracy,
    required this.timeRemaining,
    required this.typingContext,
    required this.challengeText,
    required this.previousTextFieldValue,
    required this.totalCharacters,
    required this.correctCharacters,
    required this.startTime,
    required this.typingVersion,
  });

  factory QuickTypeQuestState.initial() => QuickTypeQuestState(
        selectedDifficulty: Difficulty.easy,
        gameState: GameState.idle,
        wpm: 0,
        accuracy: 0,
        timeRemaining: 90,
        typingContext: null,
        challengeText:
            "The phenomenon of bioluminescence, the production and emission of light by living organisms, is observed across a diverse range of species, from fireflies to deep-sea fish. This light is generated through chemical reactions within specialized cells, often involving a light-emitting molecule and an enzyme. The ecological functions of bioluminescence are varied, including attracting mates, luring prey, deterring predators, and camouflage in the vast, dark ocean depths. It truly is a remarkable natural process.",
        previousTextFieldValue: '',
        totalCharacters: 0,
        correctCharacters: 0,
        startTime: 0,
        typingVersion: 0,
      );

  QuickTypeQuestState copyWith({
    Difficulty? selectedDifficulty,
    GameState? gameState,
    int? wpm,
    int? accuracy,
    int? timeRemaining,
    TypingContext? typingContext,
    String? challengeText,
    String? previousTextFieldValue,
    int? totalCharacters,
    int? correctCharacters,
    int? startTime,
    int? typingVersion,
  }) {
    return QuickTypeQuestState(
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
      gameState: gameState ?? this.gameState,
      wpm: wpm ?? this.wpm,
      accuracy: accuracy ?? this.accuracy,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      typingContext: typingContext ?? this.typingContext,
      challengeText: challengeText ?? this.challengeText,
      previousTextFieldValue:
          previousTextFieldValue ?? this.previousTextFieldValue,
      totalCharacters: totalCharacters ?? this.totalCharacters,
      correctCharacters: correctCharacters ?? this.correctCharacters,
      startTime: startTime ?? this.startTime,
      typingVersion: typingVersion ?? this.typingVersion,
    );
  }

  @override
  List<Object?> get props => [
        selectedDifficulty,
        gameState,
        wpm,
        accuracy,
        timeRemaining,
        typingContext,
        challengeText,
        previousTextFieldValue,
        totalCharacters,
        correctCharacters,
        startTime,
        typingVersion,
      ];
}

