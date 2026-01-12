import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class StatisticsWidget extends StatelessWidget {
  final int wins;
  final int losses;
  final int draws;

  const StatisticsWidget({
    super.key,
    required this.wins,
    required this.losses,
    required this.draws,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return Container(
      padding: EdgeInsets.all(20.px),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: themeState.gradientColors,
        ),
        borderRadius: BorderRadius.circular(16.px),
        border: Border.all(
          color: themeState.splashLogoColor!.withOpacityValue(0.3),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacityValue(0.3),
            blurRadius: 15.px,
            spreadRadius: 0.px,
            offset: Offset(0, 5.px),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Statistics',
                fontSize: 22.px,
                fontWeight: FontWeight.bold,
                color: themeState.textOnboardingColor!,
              ),
              CustomAssetImage(
                image: Assets.assetsIconsChart,
                height: 24.px,
                width: 24.px,
                fit: BoxFit.cover,
                color: themeState.jigsawPainterBackgroundBorderColor!,
              ),
            ],
          ),
          GapH(20.px),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context: context,
                value: wins.toString(),
                label: 'WINS',
                color: themeState.jigsawPainterBackgroundBorderColor!,
              ),
              _buildStatItem(
                context: context,
                value: losses.toString(),
                label: 'LOSSES',
                color: themeState.jigsawPainterBackgroundBorderColor!,
              ),
              _buildStatItem(
                context: context,
                value: draws.toString(),
                label: 'DRAWS',
                color: themeState.jigsawPainterBackgroundBorderColor!,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required String value,
    required String label,
    required Color color,
  }) {
    final themeState = context.watch<ThemeCubit>().state;
    return Column(
      children: [
        CustomText(
          text: value,
          fontSize: 32.px,
          fontWeight: FontWeight.bold,
          color: color,
        ),
        GapH(8.px),
        CustomText(
          text: label,
          fontSize: 12.px,
          fontWeight: FontWeight.w500,
          color: themeState.textOnboardingSubtitleColor!,
        ),
      ],
    );
  }
}
