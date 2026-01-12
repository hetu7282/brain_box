import 'dart:ui';

import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/animations/dialog_entrance_animation.dart';
import 'package:brain_box/src/core/bloc/haptics/haptics_cubit.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/services/audio_service.dart';
import 'package:brain_box/src/core/services/theme_service.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_divider.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ChangeThemeDialog extends StatefulWidget {
  const ChangeThemeDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacityValue(0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: const ChangeThemeDialog(),
      ),
    );
  }

  @override
  State<ChangeThemeDialog> createState() => _ChangeThemeDialogState();
}

class _ChangeThemeDialogState extends State<ChangeThemeDialog> {
  late final ThemeCubit _themeCubit;
  late final ValueNotifier<AppThemeMode> _selectedThemeNotifier;

  @override
  void initState() {
    super.initState();
    // Get ThemeCubit from context
    _themeCubit = context.read<ThemeCubit>();
    // Initialize with current saved theme
    _selectedThemeNotifier = ValueNotifier<AppThemeMode>(
      _themeCubit.state.mode,
    );
  }

  @override
  void dispose() {
    _selectedThemeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.px),
      child: DialogEntranceAnimation(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            color: themeState.settingCustomContainerColor!,
            borderRadius: BorderRadius.circular(20.px),
            border: Border.all(
              color: themeState.splashLogoColor!.withOpacityValue(0.5),
              width: 1.px,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withOpacityValue(0.5),
                blurRadius: 30.px,
                offset: Offset(0, 10.px),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GapH(20.px),
              // Title with close button
              Row(
                children: [
                  GapW(10.px),
                  Spacer(),
                  CustomText(
                    text: 'Change Theme',
                    fontSize: 18.px,
                    fontWeight: FontWeight.bold,
                    color: themeState.textOnboardingColor!,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(6.px),
                      decoration: BoxDecoration(
                        color: AppColor.white.withOpacityValue(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColor.white,
                        size: 18.px,
                      ),
                    ),
                  ),
                  GapW(10.px),
                ],
              ),
              GapH(20.px),
              DividerWidget(
                color: themeState.splashLogoColor!.withOpacityValue(0.5),
              ),

              GapH(20.px),

              // 2x2 Grid of Theme Options
              ValueListenableBuilder<AppThemeMode>(
                valueListenable: _selectedThemeNotifier,
                builder: (context, selectedTheme, _) {
                  return GridView.count(
                padding: EdgeInsets.symmetric(horizontal: 15.px),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16.px,
                mainAxisSpacing: 16.px,
                childAspectRatio: 0.9,
                children: [
                  _buildThemeCard(
                    context,
                    theme: AppThemeMode.defult,
                    title: 'Default',
                    primaryColor: AppColor.k7FC2F4,
                    secondaryColor: const Color(0xFF16213E),
                        isSelected: selectedTheme == AppThemeMode.defult,
                  ),
                  _buildThemeCard(
                    context,
                    theme: AppThemeMode.dark,
                    title: 'Dark',
                    primaryColor: AppColor.darkTheme,
                    secondaryColor: const Color(0xFF0F0C29),
                        isSelected: selectedTheme == AppThemeMode.dark,
                  ),
                  _buildThemeCard(
                    context,
                    theme: AppThemeMode.light,
                    title: 'Light',
                    primaryColor: AppColor.lightTheme,
                    secondaryColor: const Color(0xFFF5F5F5),
                        isSelected: selectedTheme == AppThemeMode.light,
                  ),
                  _buildThemeCard(
                    context,
                    theme: AppThemeMode.cosmic,
                    title: 'Cosmic',
                    primaryColor: AppColor.cosmicTheme1,
                    secondaryColor: const Color(0xFF16213E),
                        isSelected: selectedTheme == AppThemeMode.cosmic,
                  ),
                ],
                  );
                },
              ),

              GapH(24.px),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.px),
                child: CustomButton(
                  text: 'Apply',
                  borderRadius: BorderRadius.circular(10.px),
                  onTap: () async {
                    // Save the selected theme when Apply is clicked
                    await _themeCubit.setTheme(_selectedThemeNotifier.value);
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              GapH(10.px),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.px),
                child: CustomButton(
                  text: 'Cancel',
                  buttonColor: Colors.transparent,
                  textColor: AppColor.white,
                  borderRadius: BorderRadius.circular(10.px),
                  borderColor: themeState.splashLogoColor!,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              GapH(20.px),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context, {
    required AppThemeMode theme,
    required String title,
    required Color primaryColor,
    required Color secondaryColor,
    required bool isSelected,
  }) {
    final themeState = context.watch<ThemeCubit>().state;
    return GestureDetector(
      onTap: () {
        final bool enabled = context.read<HapticsCubit>().state.enabled;
        AudioService.instance.triggerInteractionFeedback(
          hapticsEnabled: enabled,
        );
        _selectedThemeNotifier.value = theme;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: themeState.settingCustomContainerColor!,
          borderRadius: BorderRadius.circular(16.px),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : themeState.splashLogoColor!.withOpacityValue(0.2),
            width: isSelected ? 2.px : 1.px,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Miniature UI Preview
            Expanded(
              child: Container(
                margin: EdgeInsets.all(8.px),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(8.px),
                  border: Border.all(
                    color: primaryColor.withOpacityValue(0.3),
                    width: 1.px,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.px),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 10.px,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacityValue(0.5),
                          borderRadius: BorderRadius.circular(6.px),
                        ),
                      ),
                      GapH(4.px),
                      Container(
                        height: 9.px,
                        width: 70.px,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacityValue(0.3),
                          borderRadius: BorderRadius.circular(6.px),
                        ),
                      ),
                      GapH(4.px),
                      Container(
                        height: 8.px,
                        width: 50.px,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacityValue(0.3),
                          borderRadius: BorderRadius.circular(3.px),
                        ),
                      ),
                      GapH(4.px),
                      Row(
                        children: [
                          Container(
                            width: 16.px,
                            height: 16.px,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(3.px),
                            ),
                          ),
                          GapW(6.px),
                          Expanded(
                            child: Container(
                              height: 16.px,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacityValue(0.6),
                                borderRadius: BorderRadius.circular(3.px),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Theme Name with Checkmark
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.px),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 14.px,
                    fontWeight: FontWeight.w600,
                    color: AppColor.white,
                  ),
                  if (isSelected)
                    Container(
                      padding: EdgeInsets.all(4.px),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: AppColor.white,
                        size: 14.px,
                      ),
                    ),
                ],
              ),
            ),
            GapH(8.px),
            // Color Swatches
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.px),
              child: Row(
                children: [
                  Container(
                    width: 12.px,
                    height: 12.px,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.white.withOpacityValue(0.2),
                        width: 1.px,
                      ),
                    ),
                  ),
                  GapW(6.px),
                  Container(
                    width: 12.px,
                    height: 12.px,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.white.withOpacityValue(0.2),
                        width: 1.px,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GapH(12.px),
          ],
        ),
      ),
    );
  }
}
