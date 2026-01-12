import 'package:brain_box/src/config/constants/app_string.dart';
import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/config/router/router.dart';
import 'package:brain_box/src/core/animations/slide_from_bottom_animation.dart';
import 'package:brain_box/src/core/animations/slide_from_left_animation.dart';
import 'package:brain_box/src/core/animations/slide_from_right_animation.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_icon.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return CustomBgWidget(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.px),
        child: Column(
          children: [
            // Logo with animation from left
            SlideFromLeftAnimation(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 0),
              child: CustomAssetImage(
                image: Assets.assetsImageLogo,
                height: 150.px,
                width: 150.px,
                fit: BoxFit.cover,
                color: themeState.splashLogoColor,
              ),
            ),
            GapH(20.px),
            // Title with animation from right
            SlideFromRightAnimation(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 100),
              child: CustomText(
                text: AppString.appName,
                fontSize: 30.px,
                fontWeight: FontWeight.bold,
                color: themeState.splashLogoColor,
              ),
            ),
            GapH(20.px),
            // Subtitle with animation from left
            SlideFromLeftAnimation(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
              child: CustomText(
                text: 'Unlock Your Cognitive Potential',
                fontSize: 14.px,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.center,
                color: themeState.splashLogoColor,
              ),
            ),
            GapH(35.px),
            // Item 1 with animation from left
            SlideFromLeftAnimation(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 300),
              child: _buildOnboardingItem(
                context,
                Assets.assetsIconsBrainTraining,
                'Brain Training',
                'Scientifically designed exercises to enhance neural pathways',
              ),
            ),
            GapH(20.px),
            // Item 2 with animation from right
            SlideFromRightAnimation(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 400),
              child: _buildOnboardingItem(
                context,
                Assets.assetsIconsFocusImprovement,
                'Memory Enhancement',
                'Specialized activities to improve short and long-term memory',
              ),
            ),
            GapH(20.px),
            // Item 3 with animation from left
            SlideFromLeftAnimation(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 500),
              child: _buildOnboardingItem(
                context,
                Assets.assetsIconsMemoryEnhancement,
                'Focus Improvement',
                'Targeted practice to boost attention span and concentration',
              ),
            ),
            Spacer(),
            // Button with animation from bottom
            SlideFromBottomAnimation(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 600),
              child: CustomButton(
                text: 'Get Started',
                onTap: () {
                  context.goNamed(Routes.homeScreen.name);
                },
              ),
            ),
            GapBottom(extraHight: 20.px),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingItem(
    BuildContext context,
    String image,
    String title,
    String description,
  ) {
    final themeState = context.watch<ThemeCubit>().state;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.px, vertical: 10.px),
      decoration: BoxDecoration(
        color: themeState.textOnboardingBackgroundColor!,
        borderRadius: BorderRadius.circular(10.px),
        border: Border.all(
          color: themeState.textOnboardingBorderColor!.withOpacityValue(0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIcon(
            icon: image,
            size: 50.px,
            color: themeState.iconColor!,
            backgroundColor: themeState.iconBackgroundColor!,
          ),
          GapW(15.px),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: 14.px,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  color: themeState.textOnboardingColor!,
                ),
                GapH(5.px),
                CustomText(
                  text: description,
                  fontSize: 12.px,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.start,
                  color: themeState.textOnboardingSubtitleColor!,
                  textOverFlow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
