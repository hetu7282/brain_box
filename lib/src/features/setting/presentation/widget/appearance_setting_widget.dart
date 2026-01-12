import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/animations/smooth_scale_animation.dart';
import 'package:brain_box/src/core/widgets/custom_icon.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:brain_box/src/features/setting/presentation/widget/change_theme_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class AppearanceSettingWidget extends StatelessWidget {
  final VoidCallback? onThemeChanged;

  const AppearanceSettingWidget({super.key, this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Appearance',
          fontSize: 15.px,
          fontWeight: FontWeight.bold,
          color: themeState.splashLogoColor!,
        ),
        GapH(20.px),
        SmoothScaleAnimation(
          onTap: () {
            if (onThemeChanged != null) {
              onThemeChanged?.call();
            } else {
              ChangeThemeDialog.show(context);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 16.px),
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
            child: Row(
              children: [
                // Left icon - landscape/mountain scene
                CustomIcon(
                  icon: Assets.assetsIconsChangeTheme,
                  size: 40.px,
                  color: themeState.textOnboardingColor!,
                  backgroundColor: themeState.settingIconBackgroundColor!,
                ),
                GapW(16.px),
                // Text label
                Expanded(
                  child: CustomText(
                    text: 'Change Theme',
                    fontSize: 14.px,
                    fontWeight: FontWeight.w500,
                    color: themeState.appBarTitleColor!,
                  ),
                ),
                // Right icon - web page/document
                Container(
                  padding: EdgeInsets.all(8.px),
                  decoration: BoxDecoration(
                    color: themeState.settingCustomContainerColor!,
                    borderRadius: BorderRadius.circular(8.px),
                    border: Border.all(
                      color: themeState.settingCustomContainerBorderColor!,
                      width: 1.0,
                    ),
                  ),
                  child: Icon(
                    Icons.web,
                    color: themeState.splashLogoColor!,
                    size: 20.px,
                  ),
                ),
                GapW(8.px),
                // Navigation arrow
                CustomAssetImage(
                  image: Assets.assetsIconsNext,
                  height: 20.px,
                  width: 20.px,
                  color: themeState.splashLogoColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
