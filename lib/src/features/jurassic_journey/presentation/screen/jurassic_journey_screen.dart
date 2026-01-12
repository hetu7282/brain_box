import 'dart:ui';

import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/widgets/custom_appbar.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_icon.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/jurassic_journey/presentation/bloc/jurassic_journey_cubit.dart';
import 'package:brain_box/src/features/jurassic_journey/presentation/widget/change_physics_dialog.dart';
import 'package:brain_box/src/features/jurassic_journey/presentation/widget/constants.dart';
import 'package:brain_box/src/features/jurassic_journey/presentation/widget/dino.dart';
import 'package:brain_box/src/features/jurassic_journey/presentation/widget/game_object.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class JurassicJourneyScreen extends StatefulWidget {
  const JurassicJourneyScreen({super.key});

  @override
  State<JurassicJourneyScreen> createState() => _JurassicJourneyScreenState();
}

class _JurassicJourneyScreenState extends State<JurassicJourneyScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController gravityController = TextEditingController(
    text: gravity.toString(),
  );
  TextEditingController accelerationController = TextEditingController(
    text: acceleration.toString(),
  );
  TextEditingController jumpVelocityController = TextEditingController(
    text: jumpVelocity.toString(),
  );
  TextEditingController runVelocityController = TextEditingController(
    text: initialVelocity.toString(),
  );

  late AnimationController worldController;
  late final JurassicJourneyCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = JurassicJourneyCubit();
    worldController = AnimationController(
      vsync: this,
      duration: const Duration(days: 99),
    );
    worldController.addListener(_update);
    _die();
  }

  void _die() {
      worldController.stop();
    _cubit.stopGameAndDie();
  }

  void _newGame() {
    _cubit.startNewGame();
    worldController
      ..reset()
      ..forward();
  }

  void _startGame() {
    final currentState = _cubit.state;
    if (!currentState.isGameStarted && currentState.dino.state == DinoState.dead) {
      _newGame();
    } else if (!currentState.isGameStarted) {
      _cubit.markGameStarted();
        worldController.forward();
    }
  }

  void _update() {
    try {
      final screenSize = MediaQuery.of(context).size;
      final didDie = _cubit.updateFrame(
        worldController.lastElapsedDuration,
        screenSize,
            );
      if (didDie) {
        worldController.stop();
      }
    } catch (_) {
      // ignore frame errors
    }
  }

  @override
  void dispose() {
    _cubit.close();
    worldController.dispose();
    gravityController.dispose();
    accelerationController.dispose();
    jumpVelocityController.dispose();
    runVelocityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<JurassicJourneyCubit, JurassicJourneyState>(
        builder: (context, gameState) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> children = [];

          for (GameObject object
              in [...gameState.clouds, ...gameState.ground, ...gameState.cacti, gameState.dino]) {
      children.add(
        AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {
                  Rect objectRect = object.getRect(screenSize, gameState.runDistance);
            return Positioned(
              left: objectRect.left,
              top: objectRect.top,
              width: objectRect.width,
              height: objectRect.height,
              child: object.render(),
            );
          },
        ),
      );
    }
    return CustomBgWidget(
      appBar: CustomAppBar(
        title: 'Jurassic Journey',
        actionWidget: GestureDetector(
          onTap: () {
            _die();
            showDialog(
              context: context,
              builder: (context) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: ChangePhysicsDialog(
                    gravity: gravity,
                    acceleration: acceleration,
                    initialVelocity: initialVelocity,
                    jumpVelocity: jumpVelocity,
                    dayNightOffset: dayNightOffest,
                    onSave:
                        (
                          newGravity,
                          newAcceleration,
                          newInitialVelocity,
                          newJumpVelocity,
                          newDayNightOffset,
                        ) {
                                _cubit.updatePhysicsConstants(
                                  newGravity: newGravity,
                                  newAcceleration: newAcceleration,
                                  newInitialVelocity: newInitialVelocity,
                                  newJumpVelocity: newJumpVelocity,
                                  newDayNightOffset: newDayNightOffset,
                                );
                                gravityController.text = newGravity.toString();
                                accelerationController.text =
                                    newAcceleration.toString();
                                runVelocityController.text =
                                    newInitialVelocity.toString();
                                jumpVelocityController.text =
                                    newJumpVelocity.toString();
                        },
                  ),
                );
              },
            );
          },
          child: CustomIcon(
            icon: Assets.assetsIconsSettings,
            size: 40.px,
            color: themeState.textOnboardingColor!,
            backgroundColor: themeState.appBarIconBackgroundColor!,
          ),
        ),
      ),
      body: Column(
        children: [
          // Game Area
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                      if (gameState.isGameStarted &&
                          gameState.dino.state != DinoState.dead) {
                        gameState.dino.jump();
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [...children],
              ),
            ),
          ),
          GapH(20),
          // Score Display
          AnimatedBuilder(
            animation: worldController,
            builder: (context, _) {
              return Column(
                children: [
                  CustomText(
                          text: 'Score: ${gameState.runDistance.toInt()}',
                    fontSize: 40.px,
                    fontWeight: FontWeight.bold,
                    color: themeState.appBarTitleColor!,
                  ),
                  GapH(5.px),
                  CustomText(
                          text: 'High Score: ${gameState.highScore}',
                    fontSize: 18.px,
                    fontWeight: FontWeight.w700,
                    color: themeState.appBarTitleColor!,
                  ),
                ],
              );
            },
          ),
          GapH(20),
          // Start Button
          AnimatedBuilder(
            animation: worldController,
            builder: (context, _) {
              String buttonText = 'Start';
                    if (gameState.isGameStarted &&
                        gameState.dino.state == DinoState.dead) {
                buttonText = 'Restart';
                    } else if (gameState.isGameStarted &&
                        worldController.isAnimating) {
                buttonText = 'Pause';
                    } else if (gameState.isGameStarted &&
                        !worldController.isAnimating) {
                buttonText = 'Resume';
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.px),
                child: CustomButton(
                  text: buttonText,
                  onTap: () {
                          if (!gameState.isGameStarted) {
                      _startGame();
                          } else if (gameState.dino.state == DinoState.dead) {
                      _newGame();
                    } else {
                        if (worldController.isAnimating) {
                          worldController.stop();
                        } else {
                          worldController.forward();
                        }
                    }
                  },
                ),
              );
            },
          ),
          GapBottom(extraHight: 10),
        ],
            ),
          );
        },
      ),
    );
  }
}
