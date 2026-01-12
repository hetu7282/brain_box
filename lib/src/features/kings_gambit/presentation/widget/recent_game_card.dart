import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/kings_gambit/domain/entity/recent_game_entity.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class RecentGameCard extends StatelessWidget {
  final RecentGameEntity game;

  const RecentGameCard({super.key, required this.game});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final gameDay = DateTime(date.year, date.month, date.day);

    if (gameDay == today) {
      return 'Today';
    } else if (gameDay == yesterday) {
      return 'Yesterday';
    } else {
      // Format as "MMM d" (e.g., "Aug 21")
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final isWin = game.result == GameResult.win;
    final isLoss = game.result == GameResult.loss;
    final ratingChangeColor = AppColor.white; // White for draws

    return Container(
      margin: EdgeInsets.only(bottom: 12.px),
      padding: EdgeInsets.all(16.px),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: themeState.gradientColors,
        ),
        borderRadius: BorderRadius.circular(12.px),
        border: Border.all(
          color: themeState.splashLogoColor!.withOpacityValue(0.3),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: themeState.settingCustomContainerShadowColor!
                .withOpacityValue(0.2),
            blurRadius: 8.px,
            spreadRadius: 0.px,
            offset: Offset(0, 2.px),
          ),
        ],
      ),
      child: Row(
        children: [
          // Status indicator (green/red dot)
          Container(
            width: 10.px,
            height: 10.px,
            decoration: BoxDecoration(
              color: isWin
                  ? AppColor
                        .k03958A // Green dot for wins
                  : isLoss
                  ? AppColor
                        .kFF383C // Red dot for losses
                  : AppColor.white, // White dot for draws
              shape: BoxShape.circle,
            ),
          ),
          GapW(12.px),
          // Opponent info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                      text: game.opponentName,
                      fontSize: 15.px,
                      fontWeight: FontWeight.bold,
                      color: AppColor.white,
                    ),
                    GapW(6.px),
                    CustomText(
                      text: '(${game.opponentRating})',
                      fontSize: 13.px,
                      fontWeight: FontWeight.w500,
                      color: AppColor.white.withOpacityValue(0.7),
                    ),
                  ],
                ),
                GapH(6.px),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14.px,
                      color: AppColor.white.withOpacityValue(0.6),
                    ),
                    GapW(6.px),
                    CustomText(
                      text: _formatDate(game.gameDate),
                      fontSize: 12.px,
                      fontWeight: FontWeight.w500,
                      color: AppColor.white.withOpacityValue(0.6),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Rating change
          CustomText(
            text: '${game.ratingChange > 0 ? '+' : ''}${game.ratingChange}',
            fontSize: 16.px,
            fontWeight: FontWeight.bold,
            color: ratingChangeColor,
          ),
        ],
      ),
    );
  }
}
