import 'dart:async';

import 'package:brain_box/src/features/quick_type_quest/presentation/widget/typing_context.dart';
import 'package:brain_box/src/features/quick_type_quest/presentation/widget/word_generator.dart';
import 'package:characters/characters.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'quick_type_quest_state.dart';

class QuickTypeQuestCubit extends Cubit<QuickTypeQuestState> {
  QuickTypeQuestCubit() : super(QuickTypeQuestState.initial()) {
    _initializeTyping();
  }

  Timer? _timer;

  void selectDifficulty(Difficulty difficulty) {
    if (state.gameState == GameState.playing) return;
    emit(
      state.copyWith(
        selectedDifficulty: difficulty,
        timeRemaining: _getTimeForDifficulty(difficulty),
      ),
    );
  }

  void setCustomTime(int timeInSeconds) {
    if (state.gameState == GameState.playing) return;
    emit(state.copyWith(timeRemaining: timeInSeconds));
  }

  void setDifficultyAndTime(Difficulty difficulty, int timeInSeconds) {
    if (state.gameState == GameState.playing) return;
    emit(
      state.copyWith(
        selectedDifficulty: difficulty,
        timeRemaining: timeInSeconds,
      ),
    );
  }

  void startGame() {
    if (state.gameState == GameState.playing) return;
    final typingContext = _createTypingContext();
    // Use current timeRemaining (which may be custom) or default for difficulty
    final initialTime = state.timeRemaining > 0
        ? state.timeRemaining
        : _getTimeForDifficulty(state.selectedDifficulty);
    emit(
      state.copyWith(
        typingContext: typingContext,
        typingVersion: state.typingVersion + 1,
        gameState: GameState.playing,
        timeRemaining: initialTime,
        wpm: 0,
        accuracy: 0,
        startTime: DateTime.now().millisecondsSinceEpoch,
        totalCharacters: 0,
        correctCharacters: 0,
        previousTextFieldValue: '',
      ),
    );
    _startTimer();
  }

  void resetGame() {
    _timer?.cancel();
    final typingContext = _createTypingContext();
    emit(
      state.copyWith(
        gameState: GameState.idle,
        wpm: 0,
        accuracy: 0,
        timeRemaining: _getTimeForDifficulty(state.selectedDifficulty),
        startTime: 0,
        totalCharacters: 0,
        correctCharacters: 0,
        typingContext: typingContext,
        typingVersion: state.typingVersion + 1,
        previousTextFieldValue: '',
      ),
    );
  }

  void processTextFieldInput(String newValue) {
    if (state.gameState == GameState.idle) {
      startGame();
    }
    final currentState = state;
    if (currentState.gameState != GameState.playing ||
        currentState.typingContext == null) {
      emit(currentState.copyWith(previousTextFieldValue: newValue));
      return;
    }

    final previousValue = currentState.previousTextFieldValue;
    if (newValue.length > previousValue.length) {
      final addedText = newValue.substring(previousValue.length);
      for (final char in addedText.characters) {
        if (char == ' ') {
          _onSpacePressed();
        } else {
          _onCharacterInput(char);
        }
      }
    } else if (newValue.length < previousValue.length) {
      final deletedCount = previousValue.length - newValue.length;
      for (int i = 0; i < deletedCount; i++) {
        _onBackspacePressed();
      }
    }

    emit(state.copyWith(previousTextFieldValue: ''));
  }

  void onCtrlBackspacePressed() {
    if (state.gameState != GameState.playing || state.typingContext == null) {
      return;
    }
    final typingContext = state.typingContext!;
    if (typingContext.deleteFullWord()) {
      emit(
        state.copyWith(
          typingContext: typingContext,
          typingVersion: state.typingVersion + 1,
        ),
      );
      _calculateMetrics();
    }
  }

  void handleCharacterInput(String character) {
    if (state.gameState == GameState.idle) {
      startGame();
    }
    _onCharacterInput(character);
  }

  void handleSpacePressed() {
    _onSpacePressed();
  }

  void handleBackspacePressed() {
    _onBackspacePressed();
  }

  void _onCharacterInput(String character) {
    if (state.gameState != GameState.playing || state.typingContext == null) {
      return;
    }

    final typingContext = state.typingContext!;
    final currentWord = typingContext.currentWord;
    final enteredText = typingContext.enteredText;
    final expectedCharIndex = enteredText.length;
    final isCorrect =
        expectedCharIndex < currentWord.length &&
        currentWord[expectedCharIndex] == character;

    typingContext.onCharacterEntered(character);

    emit(
      state.copyWith(
        typingContext: typingContext,
        typingVersion: state.typingVersion + 1,
        totalCharacters: state.totalCharacters + 1,
        correctCharacters: state.correctCharacters + (isCorrect ? 1 : 0),
      ),
    );
    _calculateMetrics();
  }

  void _onSpacePressed() {
    if (state.gameState != GameState.playing || state.typingContext == null) {
      return;
    }
    final typingContext = state.typingContext!;
    typingContext.onSpacePressed();

    // Check if paragraph is complete (after incrementing word index)
    final challengeWords = state.challengeText.split(' ');
    final isParagraphComplete =
        typingContext.currentWordIndex >= challengeWords.length;

    emit(
      state.copyWith(
        typingContext: typingContext,
        typingVersion: state.typingVersion + 1,
      ),
    );
    _calculateMetrics();

    // If paragraph is complete, end the game
    if (isParagraphComplete) {
      _endGame();
    }
  }

  void _onBackspacePressed() {
    if (state.gameState != GameState.playing || state.typingContext == null) {
      return;
    }
    final typingContext = state.typingContext!;
    final deleted = typingContext.deleteCharacter();
    emit(
      state.copyWith(
        typingContext: typingContext,
        typingVersion: state.typingVersion + 1,
        totalCharacters: deleted && state.totalCharacters > 0
            ? state.totalCharacters - 1
            : state.totalCharacters,
      ),
    );
    _calculateMetrics();
  }

  void _calculateMetrics() {
    if (state.startTime == 0 || state.typingContext == null) return;
    final elapsedSeconds =
        (DateTime.now().millisecondsSinceEpoch - state.startTime) / 1000;
    if (elapsedSeconds <= 0) return;
    final typedWords = state.typingContext!.getTypedWordCount();
    final newWpm = ((typedWords / elapsedSeconds) * 60).round();
    final newAccuracy = state.totalCharacters > 0
        ? ((state.correctCharacters / state.totalCharacters) * 100).round()
        : state.accuracy;

    emit(
      state.copyWith(
        wpm: newWpm,
        accuracy: state.totalCharacters > 0 ? newAccuracy : state.accuracy,
      ),
    );
  }

  void _initializeTyping() {
    final typingContext = _createTypingContext();
    emit(
      state.copyWith(
        typingContext: typingContext,
        typingVersion: state.typingVersion + 1,
      ),
    );
  }

  TypingContext _createTypingContext() {
    WordGenerator.initializeWordList(state.challengeText.split(' '));
    final seed = DateTime.now().millisecondsSinceEpoch;
    return TypingContext(seed, WordListType.top1000);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.gameState != GameState.playing) {
        timer.cancel();
        return;
      }
      if (state.timeRemaining > 0) {
        emit(state.copyWith(timeRemaining: state.timeRemaining - 1));
        _calculateMetrics();
      } else {
        _endGame();
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    emit(state.copyWith(gameState: GameState.finished));
  }

  int _getTimeForDifficulty(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 90;
      case Difficulty.medium:
        return 60;
      case Difficulty.hard:
        return 45;
    }
  }

  int getInitialTimeForDifficulty(Difficulty difficulty) {
    return _getTimeForDifficulty(difficulty);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
