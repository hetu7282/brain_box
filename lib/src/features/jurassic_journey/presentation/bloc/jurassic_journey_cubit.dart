import 'dart:math';

import 'package:brain_box/src/features/jurassic_journey/presentation/widget/cactus.dart';
import 'package:brain_box/src/features/jurassic_journey/presentation/widget/cloud.dart';
import 'package:brain_box/src/features/jurassic_journey/presentation/widget/constants.dart';
import 'package:brain_box/src/features/jurassic_journey/presentation/widget/dino.dart';
import 'package:brain_box/src/features/jurassic_journey/presentation/widget/ground.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'jurassic_journey_state.dart';

class JurassicJourneyCubit extends Cubit<JurassicJourneyState> {
  JurassicJourneyCubit() : super(JurassicJourneyState.initial());

  Duration _lastUpdateCall = Duration.zero;

  void reset() {
    emit(JurassicJourneyState.initial());
    _lastUpdateCall = Duration.zero;
  }

  void markGameStarted() {
    emit(state.copyWith(isGameStarted: true));
  }

  void markGameStopped() {
    emit(state.copyWith(isGameStarted: false));
  }

  void stopGameAndDie() {
    state.dino.die();
    emit(state.copyWith(isGameStarted: false));
  }

  void updatePhysicsConstants({
    required int newGravity,
    required double newAcceleration,
    required double newInitialVelocity,
    required double newJumpVelocity,
    required int newDayNightOffset,
  }) {
    gravity = newGravity;
    acceleration = newAcceleration;
    initialVelocity = newInitialVelocity;
    jumpVelocity = newJumpVelocity;
    dayNightOffest = newDayNightOffset;
    emit(state.copyWith(runVelocity: newInitialVelocity));
  }

  void startNewGame() {
    final updatedHighScore = max(state.highScore, state.runDistance.toInt());
    final newDino = state.dino
      ..state = DinoState.running
      ..dispY = 0;

    emit(
      state.copyWith(
        highScore: updatedHighScore,
        runDistance: 0,
        runVelocity: initialVelocity,
        dino: newDino,
        cacti: [
          Cactus(worldLocation: const Offset(200, 0)),
          Cactus(worldLocation: const Offset(300, 0)),
          Cactus(worldLocation: const Offset(450, 0)),
        ],
        ground: [
          Ground(worldLocation: const Offset(0, 0)),
          Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0)),
        ],
        clouds: [
          Cloud(worldLocation: const Offset(100, 20)),
          Cloud(worldLocation: const Offset(200, 10)),
          Cloud(worldLocation: const Offset(350, -15)),
          Cloud(worldLocation: const Offset(500, 10)),
          Cloud(worldLocation: const Offset(550, -10)),
        ],
        isGameStarted: true,
      ),
    );
    _lastUpdateCall = Duration.zero;
  }

  bool updateFrame(Duration? elapsedDuration, Size screenSize) {
    if (!state.isGameStarted || elapsedDuration == null) {
      _lastUpdateCall = elapsedDuration ?? _lastUpdateCall;
      return false;
    }

    state.dino.update(_lastUpdateCall, elapsedDuration);
    double elapsedTimeSeconds =
        (elapsedDuration - _lastUpdateCall).inMilliseconds / 1000;
    _lastUpdateCall = elapsedDuration;

    double runDistance =
        state.runDistance + state.runVelocity * elapsedTimeSeconds;
    if (runDistance < 0) runDistance = 0;
    double runVelocity = state.runVelocity + acceleration * elapsedTimeSeconds;

    final updatedCacti = List<Cactus>.from(state.cacti);
    final updatedGround = List<Ground>.from(state.ground);
    final updatedClouds = List<Cloud>.from(state.clouds);

    final Rect dinoRect = state.dino.getRect(screenSize, runDistance);

    for (final cactus in List<Cactus>.from(updatedCacti)) {
      final obstacleRect = cactus.getRect(screenSize, runDistance);
      if (dinoRect.overlaps(obstacleRect.deflate(20))) {
        state.dino.die();
        emit(
          state.copyWith(
            runDistance: runDistance,
            runVelocity: runVelocity,
            isGameStarted: false,
          ),
        );
        return true;
      }
      if (obstacleRect.right < 0) {
        updatedCacti
          ..remove(cactus)
          ..add(
            Cactus(
              worldLocation: Offset(
                runDistance +
                    Random().nextInt(100) +
                    screenSize.width / worlToPixelRatio,
                0,
              ),
            ),
          );
      }
    }

    for (final groundlet in List<Ground>.from(updatedGround)) {
      if (groundlet.getRect(screenSize, runDistance).right < 0) {
        updatedGround
          ..remove(groundlet)
          ..add(
            Ground(
              worldLocation: Offset(
                updatedGround.last.worldLocation.dx +
                    groundSprite.imageWidth / 10,
                0,
              ),
            ),
          );
      }
    }

    for (final cloud in List<Cloud>.from(updatedClouds)) {
      if (cloud.getRect(screenSize, runDistance).right < 0) {
        updatedClouds
          ..remove(cloud)
          ..add(
            Cloud(
              worldLocation: Offset(
                updatedClouds.last.worldLocation.dx +
                    Random().nextInt(200) +
                    screenSize.width / worlToPixelRatio,
                Random().nextInt(50) - 25.0,
              ),
            ),
          );
      }
    }

    emit(
      state.copyWith(
        runDistance: runDistance,
        runVelocity: runVelocity,
        cacti: updatedCacti,
        ground: updatedGround,
        clouds: updatedClouds,
      ),
    );
    return false;
  }
}
