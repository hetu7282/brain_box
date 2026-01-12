import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ScoreboardWidget extends StatelessWidget {
  final int xWins;
  final int draws;
  final int oWins;

  const ScoreboardWidget({
    super.key,
    required this.xWins,
    required this.draws,
    required this.oWins,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return Container(
      decoration: BoxDecoration(
        color: themeState.settingCustomContainerColor!,
        borderRadius: BorderRadius.circular(16.px),
        border: Border.all(
          color: themeState.settingCustomContainerBorderColor!,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: themeState.settingCustomContainerShadowColor!,
            blurRadius: 15.px,
            offset: Offset(0, 5.px),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 10.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ScoreItem(title: 'Player X', value: xWins, suffix: 'wins'),
          _ScoreItem(title: 'Draws', value: draws),
          _ScoreItem(title: 'Player O', value: oWins, suffix: 'wins'),
        ],
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final String title;
  final int value;
  final String? suffix;

  const _ScoreItem({required this.title, required this.value, this.suffix});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: title,
          color: themeState.appBarTitleColor!,
          fontSize: 14.px,
          fontWeight: FontWeight.w600,
        ),
        GapH(6.px),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
              text: value.toString(),
              color: title == 'Player X'
                  ? themeState.splashLogoColor!
                  : themeState.appBarTitleColor!,
              fontSize: 16.px,
              fontWeight: FontWeight.w800,
            ),
            if (suffix != null) ...[
              GapW(6.px),
              CustomText(
                text: suffix!,
                color: title == 'Player X'
                    ? themeState.splashLogoColor!
                    : themeState.appBarTitleColor!,
                fontSize: 16.px,
                fontWeight: FontWeight.w700,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
