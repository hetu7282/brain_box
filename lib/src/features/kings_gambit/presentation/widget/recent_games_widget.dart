import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/kings_gambit/domain/entity/recent_game_entity.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/widget/recent_game_card.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class RecentGamesWidget extends StatelessWidget {
  final List<RecentGameEntity> games;

  const RecentGamesWidget({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    if (games.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and calendar icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Recent Games',
              fontSize: 20.px,
              fontWeight: FontWeight.bold,
              color: themeState.appBarTitleColor!,
            ),
            Icon(
              Icons.calendar_today,
              size: 20.px,
              color: themeState.appBarTitleColor!.withOpacityValue(0.7),
            ),
          ],
        ),
        GapH(15.px),
        // Game list
        ...games.map((game) => RecentGameCard(game: game)),
      ],
    );
  }
}
