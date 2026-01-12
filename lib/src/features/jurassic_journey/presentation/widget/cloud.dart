import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants.dart';
import 'game_object.dart';
import 'sprite.dart';

Sprite cloudSprite = Sprite()
  ..imagePath = Assets.assetsImageDinosaurCloud1
  ..imageWidth = 92
  ..imageHeight = 27;

class Cloud extends GameObject {
  final Offset worldLocation;

  Cloud({required this.worldLocation});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * worlToPixelRatio / 5,
      screenSize.height / 3 - cloudSprite.imageHeight - worldLocation.dy,
      cloudSprite.imageWidth.toDouble(),
      cloudSprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return Image.asset(
          cloudSprite.imagePath,
          color: themeState.splashLogoColor!,
        );
      },
    );
  }
}
