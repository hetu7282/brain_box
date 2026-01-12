import 'dart:math';

import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/services/theme_service.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants.dart';
import 'game_object.dart';
import 'sprite.dart';

List<Sprite> getCactiForTheme(AppThemeMode theme) {
  switch (theme) {
    case AppThemeMode.light:
      return [
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiLightCactiGroup
          ..imageWidth = 80
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiLightCactiLarge1
          ..imageWidth = 50
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiLightCactiLarge2
          ..imageWidth = 60
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiLightCactiSmall1
          ..imageWidth = 50
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiLightCactiSmall2
          ..imageWidth = 60
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiLightCactiSmall3
          ..imageWidth = 80
          ..imageHeight = 70,
      ];
    case AppThemeMode.dark:
      return [
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiDarkCactiGroup
          ..imageWidth = 80
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiDarkCactiLarge1
          ..imageWidth = 50
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiDarkCactiLarge2
          ..imageWidth = 60
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiDarkCactiSmall1
          ..imageWidth = 50
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiDarkCactiSmall2
          ..imageWidth = 60
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiDarkCactiSmall3
          ..imageWidth = 80
          ..imageHeight = 70,
      ];
    case AppThemeMode.cosmic:
      return [
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiCosmicCactiGroup
          ..imageWidth = 80
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiCosmicCactiLarge1
          ..imageWidth = 50
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiCosmicCactiLarge2
          ..imageWidth = 60
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiCosmicCactiSmall1
          ..imageWidth = 50
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiCosmicCactiSmall2
          ..imageWidth = 60
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiCosmicCactiSmall3
          ..imageWidth = 80
          ..imageHeight = 70,
      ];
    case AppThemeMode.defult:
      return [
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiDefaultCactiGroup
          ..imageWidth = 80
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiDefaultCactiLarge1
          ..imageWidth = 50
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiDefaultCactiLarge2
          ..imageWidth = 60
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiDefaultCactiSmall1
          ..imageWidth = 50
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiDefaultCactiSmall2
          ..imageWidth = 60
          ..imageHeight = 70,
        Sprite()
          ..imagePath = Assets.assetsImageDinosaurCactiDefaultCactiSmall3
          ..imageWidth = 80
          ..imageHeight = 70,
      ];
  }
}

class Cactus extends GameObject {
  final int spriteIndex;
  final Offset worldLocation;

  Cactus({required this.worldLocation})
    : spriteIndex = Random().nextInt(6); // 6 cactus types available

  @override
  Rect getRect(Size screenSize, double runDistance) {
    // Use default theme for sizing (all themes have same dimensions)
    final defaultCacti = getCactiForTheme(AppThemeMode.defult);
    final sprite = defaultCacti[spriteIndex];
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * worlToPixelRatio,
      screenSize.height / 1.85 - sprite.imageHeight,
      sprite.imageWidth.toDouble(),
      sprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final theme = themeState.mode;
        final cacti = getCactiForTheme(theme);
        final sprite = cacti[spriteIndex];
        return Image.asset(sprite.imagePath);
      },
    );
  }
}
