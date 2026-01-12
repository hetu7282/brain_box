import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/animations/smooth_scale_animation.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_appbar.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:brain_box/src/features/slide_mastermind/presentation/bloc/slide_mastermind_cubit.dart';
import 'package:brain_box/src/features/slide_mastermind/presentation/widget/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class SlideMastermindScreen extends StatelessWidget {
  const SlideMastermindScreen({super.key});

  static const int gridSize = 4; // 4x4 grid

  String _formatTimer(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return BlocProvider(
      create: (_) => SlideMastermindCubit()..initialize(shuffle: true),
      child: CustomBgWidget(
        appBar: CustomAppBar(
          title: 'Slide Mastermind',
          actionWidget: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 5.px),
            decoration: BoxDecoration(
              color: themeState.appBarIconBackgroundColor!,
              borderRadius: BorderRadius.circular(10.px),
            ),
            child: Row(
              children: [
                CustomAssetImage(
                  image: Assets.assetsIconsTimer,
                  height: 20.px,
                  width: 20.px,
                  color: themeState.textOnboardingColor!,
                  // backgroundColor: themeState.appBarIconBackgroundColor!,
                ),
                GapW(10.px),
                BlocBuilder<SlideMastermindCubit, SlideMastermindState>(
                  buildWhen: (p, c) => p.elapsedSeconds != c.elapsedSeconds,
                  builder: (context, state) {
                    return CustomText(
                      text: _formatTimer(state.elapsedSeconds),
                      color: themeState.textOnboardingColor!,
                      fontSize: 14.px,
                      fontWeight: FontWeight.w700,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Builder(
            builder: (context) => Column(
              children: [
                PuzzleBoard(gridSize: gridSize, padding: 16.px, spacing: 10.px),

                GapH(20.px),
                _buildTopStats(),
                GapH(20.px),
                _buildControls(context),
                // Back Button
                GapH(20.px),
                SmoothScaleAnimation(
                  onTap: () => context.pop(),
                  child: CustomButton(
                    text: 'Back to Home',
                    buttonColor: AppColor.transparent,
                    textColor: themeState.splashLogoColor!,
                    fontSize: 15.px,
                    fontWeight: FontWeight.w500,
                    borderRadius: BorderRadius.circular(8.px),
                    borderColor: themeState.splashLogoColor!,
                    borderWidth: 1.px,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.px,
                      vertical: 16.px,
                    ),
                    onTap: () => context.pop(),
                  ),
                ),
                GapBottom(extraHight: 10.px),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopStats() {
    return BlocBuilder<SlideMastermindCubit, SlideMastermindState>(
      buildWhen: (p, c) => p.moves != c.moves || p.won != c.won,
      builder: (context, state) {
        final themeState = context.watch<ThemeCubit>().state;
        return Container(
          decoration: BoxDecoration(
            color: themeState.settingCustomContainerColor!.withOpacityValue(
              0.15,
            ),
            borderRadius: BorderRadius.circular(5.px),
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

          padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 14.px),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _statChip(context, 'Moves', state.moves.toString()),
              GapW(10.px),
              if (state.won) _wonChip(context) else const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }

  Widget _statChip(BuildContext context, String label, String value) {
    final themeState = context.watch<ThemeCubit>().state;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: '$label: ',
          color: themeState.appBarTitleColor!,
          fontSize: 15.px,
          fontWeight: FontWeight.w600,
        ),
        CustomText(
          text: value,
          color: themeState.splashLogoColor!,
          fontSize: 15.px,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget _wonChip(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 8.px),
      decoration: BoxDecoration(
        color: themeState.settingCustomContainerColor!,
        borderRadius: BorderRadius.circular(10.px),
      ),
      child: CustomText(
        text: 'Completed! 🎉',
        color: themeState.splashLogoColor!,
        fontSize: 13.px,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // Board moved to PuzzleBoard widget

  Widget _buildControls(BuildContext context) {
    return SmoothScaleAnimation(
      onTap: () =>
          BlocProvider.of<SlideMastermindCubit>(context).shuffleSolvable(),
      child: _primaryButton(
        context,
        'Play Again',
        () => BlocProvider.of<SlideMastermindCubit>(context).shuffleSolvable(),
      ),
    );
  }

  Widget _primaryButton(BuildContext context, String text, VoidCallback onTap) {
    final themeState = context.watch<ThemeCubit>().state;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.px),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: themeState.settingCustomContainerColor!,

        borderRadius: BorderRadius.circular(5.px),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.refresh, color: themeState.splashLogoColor!, size: 18.px),
          GapW(8.px),
          CustomText(
            text: text,
            color: themeState.splashLogoColor!,
            fontWeight: FontWeight.w700,
            fontSize: 14.px,
          ),
        ],
      ),
    );
  }
}
