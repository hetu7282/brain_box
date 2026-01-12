import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants.dart';
import 'game_object.dart';
import 'sprite.dart';

Sprite groundSprite = Sprite()
  ..imagePath = Assets.assetsImageDinosaurGround1
  ..imageWidth = 300
  ..imageHeight = 20;

class Ground extends GameObject {
  final Offset worldLocation;

  Ground({required this.worldLocation});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * worlToPixelRatio,
      screenSize.height / 1.82 - groundSprite.imageHeight,
      groundSprite.imageWidth.toDouble(),
      groundSprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return Image.asset(
          groundSprite.imagePath,
          color: themeState.splashLogoColor!,
        );
      },
    );
  }
}
