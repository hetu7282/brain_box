import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/bloc/haptics/haptics_cubit.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/services/audio_service.dart';
import 'package:brain_box/src/core/widgets/custom_icon.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class GameModeCard extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;
  final bool isSelected;

  const GameModeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          final bool enabled = context.read<HapticsCubit>().state.enabled;
          AudioService.instance.triggerInteractionFeedback(
            hapticsEnabled: enabled,
          );
          onTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 25.px),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isSelected
                  ? themeState.gradientColors2
                  : themeState.gradientColors,
            ),
            borderRadius: BorderRadius.circular(16.px),
            border: Border.all(
              color: isSelected
                  ? themeState.splashLogoColor!.withOpacityValue(0.5)
                  : themeState.splashLogoColor!.withOpacityValue(0.3),
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: themeState.settingCustomContainerShadowColor!
                    .withOpacityValue(0.3),
                blurRadius: isSelected ? 20.px : 15.px,
                spreadRadius: isSelected ? 2.px : 0.px,
                offset: Offset(0, 5.px),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.px),
                decoration: BoxDecoration(
                  color: AppColor.white.withOpacityValue(0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: themeState.iconColor!.withOpacityValue(0.2),
                      blurRadius: 8.px,
                      spreadRadius: 0.px,
                    ),
                  ],
                ),
                child: CustomIcon(
                  icon: icon,
                  size: 50.px,
                  color: themeState.iconColor!,
                  backgroundColor: themeState.iconBackgroundColor!,
                ),
              ),
              GapH(16.px),
              CustomText(
                text: title,
                fontSize: 16.px,
                fontWeight: FontWeight.bold,
                color: themeState.textOnboardingColor!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
