import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/animations/smooth_scale_animation.dart';
import 'package:brain_box/src/core/widgets/custom_divider.dart';
import 'package:brain_box/src/core/widgets/custom_icon.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class InformationSettingWidget extends StatelessWidget {
  final VoidCallback? onAboutGameTap;
  final VoidCallback? onTermsConditionsTap;
  final VoidCallback? onPrivacyPolicyTap;

  const InformationSettingWidget({
    super.key,
    this.onAboutGameTap,
    this.onTermsConditionsTap,
    this.onPrivacyPolicyTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Information',
          fontSize: 15.px,
          fontWeight: FontWeight.bold,
          color: themeState.splashLogoColor!,
        ),
        GapH(20.px),
        Container(
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
          child: Column(
            children: [
              _buildMenuItem(
                context: context,
                icon: Assets.assetsIconsAboutGame,
                title: 'About Game',
                onTap: onAboutGameTap,
                showDivider: true,
              ),
              _buildMenuItem(
                context: context,
                icon: Assets.assetsIconsTermsConditions,
                title: 'Terms & Conditions',
                onTap: onTermsConditionsTap,
                showDivider: true,
              ),
              _buildMenuItem(
                context: context,
                icon: Assets.assetsIconsPrivacyPolicy,
                title: 'Privacy & Policy',
                onTap: onPrivacyPolicyTap,
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String icon,
    required String title,
    VoidCallback? onTap,
    required bool showDivider,
  }) {
    final themeState = context.watch<ThemeCubit>().state;
    return Column(
      children: [
        SmoothScaleAnimation(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 16.px),
            child: Row(
              children: [
                CustomIcon(
                  icon: icon,
                  size: 40.px,
                  color: themeState.textOnboardingColor!,
                  backgroundColor: themeState.settingIconBackgroundColor!,
                ),
                GapW(16.px),
                Expanded(
                  child: CustomText(
                    text: title,
                    fontSize: 14.px,
                    fontWeight: FontWeight.w500,
                    color: themeState.appBarTitleColor!,
                  ),
                ),
                CustomAssetImage(
                  image: Assets.assetsIconsNext,
                  height: 20.px,
                  width: 20.px,
                  color: themeState.splashLogoColor!,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          DividerWidget(color: themeState.settingCustomContainerBorderColor!),
      ],
    );
  }
}
