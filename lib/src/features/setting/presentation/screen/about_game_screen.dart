import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/animations/fade_in_animation.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_appbar.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class AboutGameScreen extends StatelessWidget {
  const AboutGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return CustomBgWidget(
      appBar: CustomAppBar(title: 'About Game'),
      body: FadeInAnimation(
        duration: const Duration(milliseconds: 400),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25.px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Game Logo/Icon (placeholder)
              Center(
                child: CustomAssetImage(
                  image: Assets.assetsImageLogo,
                  height: 150.px,
                  width: 150.px,
                  fit: BoxFit.cover,
                  color: themeState.splashLogoColor!,
                ),
              ),
              GapH(30.px),

              // Game Title
              Center(
                child: CustomText(
                  text: 'Brain Box',
                  fontSize: 24.px,
                  fontWeight: FontWeight.bold,
                  color: themeState.appBarTitleColor!,
                ),
              ),
              GapH(8.px),
              Center(
                child: CustomText(
                  text: 'Version 1.0.0',
                  fontSize: 12.px,
                  fontWeight: FontWeight.w400,
                  color: themeState.appBarTitleColor!.withOpacityValue(0.7),
                ),
              ),
              GapH(30.px),

              // Divider
              Container(
                height: 1.px,
                color: themeState.settingCustomContainerBorderColor!
                    .withOpacityValue(0.2),
              ),
              GapH(30.px),

              // About Content
              CustomText(
                text: 'Game Description',
                fontSize: 18.px,
                fontWeight: FontWeight.bold,
                color: themeState.splashLogoColor!,
              ),
              GapH(15.px),
              CustomText(
                text:
                    'Brain Box is an engaging and challenging trivia game designed to test your knowledge across various topics. Challenge yourself with hundreds of questions spanning science, history, geography, entertainment, and more.',
                fontSize: 14.px,
                fontWeight: FontWeight.w400,
                color: themeState.appBarTitleColor!.withOpacityValue(0.9),
                height: 1.6,
              ),
              GapH(25.px),

              CustomText(
                text: 'Features',
                fontSize: 18.px,
                fontWeight: FontWeight.bold,
                color: themeState.splashLogoColor!,
              ),
              GapH(15.px),
              _buildFeatureItem(
                context: context,
                icon: Icons.quiz,
                title: 'Multiple Categories',
                description:
                    'Explore questions from various categories including science, history, sports, and more.',
              ),
              GapH(15.px),
              _buildFeatureItem(
                context: context,
                icon: Icons.trending_up,
                title: 'Track Progress',
                description:
                    'Monitor your performance and improve your knowledge over time.',
              ),
              GapH(15.px),
              _buildFeatureItem(
                context: context,
                icon: Icons.emoji_events,
                title: 'Challenges',
                description:
                    'Compete with yourself and unlock achievements as you progress.',
              ),
              GapH(30.px),

              // Divider
              Container(
                height: 1.px,
                color: themeState.settingCustomContainerBorderColor!
                    .withOpacityValue(0.2),
              ),
              GapH(30.px),

              CustomText(
                text: 'Copyright',
                fontSize: 18.px,
                fontWeight: FontWeight.bold,
                color: themeState.splashLogoColor!,
              ),
              GapH(15.px),
              CustomText(
                text:
                    '© 2024 Brain Box. All rights reserved.\nThis app is created for educational and entertainment purposes.',
                fontSize: 12.px,
                fontWeight: FontWeight.w400,
                color: themeState.appBarTitleColor!.withOpacityValue(0.7),
              ),
              GapBottom(extraHight: 10.px),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final themeState = context.watch<ThemeCubit>().state;
    return Container(
      padding: EdgeInsets.all(16.px),
      decoration: BoxDecoration(
        color: themeState.settingCustomContainerColor!,
        borderRadius: BorderRadius.circular(12.px),
        border: Border.all(
          color: themeState.settingCustomContainerBorderColor!,
          width: 1.px,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.px),
            decoration: BoxDecoration(
              color: themeState.settingCustomContainerColor!,
              borderRadius: BorderRadius.circular(10.px),
            ),
            child: Icon(icon, color: themeState.splashLogoColor!, size: 24.px),
          ),
          GapW(15.px),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: 16.px,
                  fontWeight: FontWeight.w600,
                  color: themeState.appBarTitleColor!,
                ),
                GapH(6.px),
                CustomText(
                  text: description,
                  fontSize: 12.px,
                  fontWeight: FontWeight.w400,
                  color: themeState.appBarTitleColor!.withOpacityValue(0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
