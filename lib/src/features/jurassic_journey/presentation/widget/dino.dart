import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/services/theme_service.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants.dart';
import 'game_object.dart';
import 'sprite.dart';

List<Sprite> getDinoForTheme(AppThemeMode theme) {
  switch (theme) {
    case AppThemeMode.light:
      return [
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoLightDino1
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoLightDino2
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoLightDino3
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoLightDino4
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoLightDino5
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoLightDino6
          ..imageWidth = 45
          ..imageHeight = 50,
      ];
    case AppThemeMode.dark:
      return [
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoDarkDino1
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoDarkDino2
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoDarkDino3
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoDarkDino4
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoDarkDino5
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoDarkDino6
          ..imageWidth = 45
          ..imageHeight = 50,
      ];
    case AppThemeMode.cosmic:
      return [
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoCosmicDino1
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoCosmicDino2
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoCosmicDino3
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoCosmicDino4
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoCosmicDino5
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoCosmicDino6
          ..imageWidth = 45
          ..imageHeight = 50,
      ];
    case AppThemeMode.defult:
      return [
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoDefaultDino1
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoDefaultDino2
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoDefaultDino3
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoDefaultDino4
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoDefaultDino5
          ..imageWidth = 45
          ..imageHeight = 50,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurDinoDefaultDino6
          ..imageWidth = 45
          ..imageHeight = 50,
      ];
  }
}

enum DinoState { jumping, running, dead }

class Dino extends GameObject {
  int currentSpriteIndex = 0;
  double dispY = 0;
  double velY = 0;
  DinoState state = DinoState.running;

  @override
  Widget render() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final theme = themeState.mode;
        final dino = getDinoForTheme(theme);
        final currentSprite = dino[currentSpriteIndex];
        return Image.asset(currentSprite.imagePath);
      },
    );
  }

  @override
  Rect getRect(Size screenSize, double runDistance) {
    // Use default theme for sizing (all themes have same dimensions)
    final defaultDino = getDinoForTheme(AppThemeMode.defult);
    final currentSprite = defaultDino[currentSpriteIndex];
    return Rect.fromLTWH(
      screenSize.width / 10,
      screenSize.height / 1.85 - currentSprite.imageHeight - dispY,
      currentSprite.imageWidth.toDouble(),
      currentSprite.imageHeight.toDouble(),
    );
  }

  @override
  void update(Duration lastUpdate, Duration? elapsedTime) {
    double elapsedTimeSeconds;
    try {
      currentSpriteIndex = (elapsedTime!.inMilliseconds / 100).floor() % 2 + 2;
    } catch (_) {
      currentSpriteIndex = 0;
    }
    try {
      elapsedTimeSeconds = (elapsedTime! - lastUpdate).inMilliseconds / 1000;
    } catch (_) {
      elapsedTimeSeconds = 0;
    }

    dispY += velY * elapsedTimeSeconds;
    if (dispY <= 0) {
      dispY = 0;
      velY = 0;
      state = DinoState.running;
    } else {
      velY -= gravity * elapsedTimeSeconds;
    }
  }

  void jump() {
    if (state != DinoState.jumping) {
      state = DinoState.jumping;
      velY = jumpVelocity;
    }
  }

  void die() {
    currentSpriteIndex = 5;
    state = DinoState.dead;
  }
}
