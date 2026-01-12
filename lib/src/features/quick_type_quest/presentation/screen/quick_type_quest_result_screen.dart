import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/config/router/router.dart';
import 'package:brain_box/src/core/animations/smooth_scale_animation.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_appbar.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class QuickTypeQuestResultScreen extends StatelessWidget {
  final int wpm;
  final int accuracy;
  final int totalCharacters;
  final int correctCharacters;
  final int timeElapsed;
  final String difficulty;

  const QuickTypeQuestResultScreen({
    super.key,
    required this.wpm,
    required this.accuracy,
    required this.totalCharacters,
    required this.correctCharacters,
    required this.timeElapsed,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return CustomBgWidget(
      appBar: CustomAppBar(
        title: 'Results',
        leadingOnTap: () {
          context.goNamed(Routes.quickTypeQuest.name);
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.px),
        child: Column(
          children: [
            GapH(20.px),
            // Success Message
            CustomText(
              text: 'Great Job!',
              fontSize: 24.px,
              fontWeight: FontWeight.bold,
              color: themeState.splashLogoColor!,
              textAlign: TextAlign.center,
            ),
            GapH(10.px),
            CustomText(
              text: 'You completed the typing challenge!',
              fontSize: 16.px,
              fontWeight: FontWeight.w500,
              color: themeState.appBarTitleColor!,
              textAlign: TextAlign.center,
            ),
            GapH(30.px),
            // Main Stats Card
            Container(
              padding: EdgeInsets.all(20.px),
              decoration: BoxDecoration(
                color: themeState.settingCustomContainerColor!.withOpacityValue(
                  0.15,
                ),
                borderRadius: BorderRadius.circular(16.px),
                border: Border.all(
                  color: themeState.settingCustomContainerBorderColor!
                      .withOpacityValue(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: themeState.settingCustomContainerShadowColor!
                        .withOpacityValue(0.3),
                    blurRadius: 15.px,
                    offset: Offset(0, 5.px),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // WPM
                  _buildStatCard(
                    context,
                    'WPM',
                    '$wpm',
                    Assets.assetsIconsWPM,
                    themeState,
                  ),
                  GapH(15.px),
                  // Accuracy
                  _buildStatCard(
                    context,
                    'Accuracy',
                    '$accuracy%',
                    Assets.assetsIconsAccuracy,
                    themeState,
                  ),
                  GapH(15.px),
                  // Time
                  _buildStatCard(
                    context,
                    'Time',
                    _formatTime(timeElapsed),
                    Assets.assetsIconsTimer,
                    themeState,
                  ),
                ],
              ),
            ),
            GapH(25.px),
            // Detailed Stats
            Container(
              padding: EdgeInsets.all(20.px),
              decoration: BoxDecoration(
                color: themeState.settingCustomContainerColor!.withOpacityValue(
                  0.15,
                ),
                borderRadius: BorderRadius.circular(16.px),
                border: Border.all(
                  color: themeState.settingCustomContainerBorderColor!
                      .withOpacityValue(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: themeState.settingCustomContainerShadowColor!
                        .withOpacityValue(0.3),
                    blurRadius: 15.px,
                    offset: Offset(0, 5.px),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Detailed Statistics',
                    fontSize: 18.px,
                    fontWeight: FontWeight.bold,
                    color: themeState.appBarTitleColor!,
                  ),
                  GapH(15.px),
                  _buildDetailRow(
                    context,
                    'Total Characters',
                    '$totalCharacters',
                    themeState,
                  ),
                  GapH(12.px),
                  _buildDetailRow(
                    context,
                    'Correct Characters',
                    '$correctCharacters',
                    themeState,
                  ),
                  GapH(12.px),
                  _buildDetailRow(
                    context,
                    'Incorrect Characters',
                    '${totalCharacters - correctCharacters}',
                    themeState,
                  ),
                  GapH(12.px),
                  _buildDetailRow(
                    context,
                    'Difficulty',
                    difficulty,
                    themeState,
                  ),
                ],
              ),
            ),
            GapH(30.px),
            // Action Buttons
            SmoothScaleAnimation(
              onTap: () {
                // Navigate to fresh game screen to reset all initialization
                context.goNamed(Routes.quickTypeQuest.name);
              },
              child: CustomButton(
                text: 'Play Again',
                onTap: () {
                  // Navigate to fresh game screen to reset all initialization
                  context.goNamed(Routes.quickTypeQuest.name);
                },
              ),
            ),
            GapH(15.px),
            CustomButton(
              text: 'Back to Home',
              buttonColor: themeState.settingCustomContainerColor!,
              textColor: themeState.splashLogoColor!,
              borderColor: themeState.settingCustomContainerBorderColor!,
              onTap: () => context.goNamed(Routes.homeScreen.name),
            ),
            GapBottom(extraHight: 20.px),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    String icon,
    ThemeState themeState,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.px, horizontal: 15.px),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeState.settingCustomContainerColor!,
            themeState.settingCustomContainerColor!,
          ],
        ),
        borderRadius: BorderRadius.circular(12.px),
        border: Border.all(
          color: themeState.settingCustomContainerBorderColor!.withOpacityValue(
            0.3,
          ),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: themeState.settingCustomContainerShadowColor!
                .withOpacityValue(0.3),
            blurRadius: 10.px,
            offset: Offset(0, 4.px),
          ),
        ],
      ),
      child: Row(
        children: [
          CustomAssetImage(
            image: icon,
            height: 30.px,
            width: 30.px,
            color: themeState.splashLogoColor!,
          ),
          GapW(15.px),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: label,
                  fontSize: 14.px,
                  color: themeState.appBarTitleColor!,
                ),
                GapH(6.px),
                CustomText(
                  text: value,
                  fontSize: 28.px,
                  fontWeight: FontWeight.bold,
                  color: themeState.appBarTitleColor!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    ThemeState themeState,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          fontSize: 15.px,
          color: themeState.appBarTitleColor!.withOpacityValue(0.7),
        ),
        CustomText(
          text: value,
          fontSize: 15.px,
          fontWeight: FontWeight.w600,
          color: themeState.appBarTitleColor!,
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${secs}s';
    }
    return '${secs}s';
  }
}
