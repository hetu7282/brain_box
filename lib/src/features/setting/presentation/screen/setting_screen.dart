import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/router/router.dart';
import 'package:brain_box/src/core/animations/smooth_scale_animation.dart';
import 'package:brain_box/src/core/animations/staggered_list_animation.dart';
import 'package:brain_box/src/core/widgets/custom_appbar.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:brain_box/src/features/setting/presentation/widget/appearance_setting_widget.dart';
import 'package:brain_box/src/features/setting/presentation/widget/game_setting_widget.dart';
import 'package:brain_box/src/features/setting/presentation/widget/information_setting_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return CustomBgWidget(
      appBar: CustomAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.px),
        child: StaggeredListAnimation(
          duration: const Duration(milliseconds: 600),
          staggerDuration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          slideDistance: 30.0,
          children: [
            // Game Settings Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Game Settings',
                  fontSize: 15.px,
                  fontWeight: FontWeight.bold,
                  color: themeState.splashLogoColor!,
                ),
                GapH(20.px),
                const GameSettingWidget(),
              ],
            ),
            GapH(30.px),
            // Appearance Section
            const AppearanceSettingWidget(),
            GapH(30.px),
            // Information Section
            InformationSettingWidget(
              onAboutGameTap: () => context.pushNamed(Routes.aboutGame.name),
              onTermsConditionsTap: () =>
                  context.pushNamed(Routes.termsConditions.name),
              onPrivacyPolicyTap: () =>
                  context.pushNamed(Routes.privacyPolicy.name),
            ),
            GapH(30.px),
            // Back Button
            SmoothScaleAnimation(
              onTap: () => context.pop(),
              child: CustomButton(
                text: 'Back to Home',
                buttonColor: AppColor.transparent,
                textColor: themeState.appBarTitleColor!,
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
    );
  }
}
