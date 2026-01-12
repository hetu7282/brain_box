import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/quick_type_quest/presentation/bloc/quick_type_quest_cubit.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class QuickTypeQuestSettingsDialog extends StatelessWidget {
  final Difficulty initialDifficulty;
  final int initialTime;

  const QuickTypeQuestSettingsDialog({
    super.key,
    required this.initialDifficulty,
    required this.initialTime,
  });

  static void show(
    BuildContext context, {
    required Difficulty initialDifficulty,
    required int initialTime,
  }) {
    final quickTypeCubit = context.read<QuickTypeQuestCubit>();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: quickTypeCubit,
          child: QuickTypeQuestSettingsDialog(
            initialDifficulty: initialDifficulty,
            initialTime: initialTime,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return _QuickTypeQuestSettingsDialogContent(
          initialDifficulty: initialDifficulty,
          initialTime: initialTime,
          themeState: themeState,
        );
      },
    );
  }
}

class _QuickTypeQuestSettingsDialogContent extends StatefulWidget {
  final Difficulty initialDifficulty;
  final int initialTime;
  final ThemeState themeState;

  const _QuickTypeQuestSettingsDialogContent({
    required this.initialDifficulty,
    required this.initialTime,
    required this.themeState,
  });

  @override
  State<_QuickTypeQuestSettingsDialogContent> createState() =>
      _QuickTypeQuestSettingsDialogContentState();
}

class _QuickTypeQuestSettingsDialogContentState
    extends State<_QuickTypeQuestSettingsDialogContent> {
  late Difficulty selectedDifficulty;
  late int selectedTime;

  @override
  void initState() {
    super.initState();
    selectedDifficulty = widget.initialDifficulty;
    selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.px)),
      child: Container(
        padding: EdgeInsets.all(20.px),
        decoration: BoxDecoration(
          color: widget.themeState.settingCustomContainerColor,
          borderRadius: BorderRadius.circular(20.px),
          border: Border.all(
            color: widget.themeState.settingCustomContainerBorderColor!,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Settings',
                  fontSize: 20.px,
                  fontWeight: FontWeight.bold,
                  color: widget.themeState.appBarTitleColor!,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: CustomAssetImage(
                    image: Assets.assetsIconsClose,
                    height: 24.px,
                    width: 24.px,
                    color: widget.themeState.appBarTitleColor!,
                  ),
                ),
              ],
            ),
            GapH(25.px),
            // Difficulty Selection
            CustomText(
              text: 'Difficulty',
              fontSize: 16.px,
              fontWeight: FontWeight.w600,
              color: widget.themeState.appBarTitleColor!,
            ),
            GapH(12.px),
            Row(
              children: [
                Expanded(
                  child: _buildDifficultyOption('Easy', Difficulty.easy, () {
                    setState(() {
                      selectedDifficulty = Difficulty.easy;
                    });
                  }),
                ),
                GapW(10.px),
                Expanded(
                  child: _buildDifficultyOption(
                    'Medium',
                    Difficulty.medium,
                    () {
                      setState(() {
                        selectedDifficulty = Difficulty.medium;
                      });
                    },
                  ),
                ),
                GapW(10.px),
                Expanded(
                  child: _buildDifficultyOption('Hard', Difficulty.hard, () {
                    setState(() {
                      selectedDifficulty = Difficulty.hard;
                    });
                  }),
                ),
              ],
            ),
            GapH(25.px),
            // Time Selection
            CustomText(
              text: 'Time',
              fontSize: 16.px,
              fontWeight: FontWeight.w600,
              color: widget.themeState.appBarTitleColor!,
            ),
            GapH(12.px),
            Row(
              children: [
                Expanded(
                  child: _buildTimeOption('30s', 30, () {
                    setState(() {
                      selectedTime = 30;
                    });
                  }),
                ),
                GapW(10.px),
                Expanded(
                  child: _buildTimeOption('1 min', 60, () {
                    setState(() {
                      selectedTime = 60;
                    });
                  }),
                ),
                GapW(10.px),
                Expanded(
                  child: _buildTimeOption('2 min', 120, () {
                    setState(() {
                      selectedTime = 120;
                    });
                  }),
                ),
              ],
            ),
            GapH(25.px),
            // Apply Button
            CustomButton(
              text: 'Apply',
              onTap: () {
                context.read<QuickTypeQuestCubit>().setDifficultyAndTime(
                  selectedDifficulty,
                  selectedTime,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyOption(
    String label,
    Difficulty difficulty,
    VoidCallback onTap,
  ) {
    final isSelected = difficulty == selectedDifficulty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.px),
        decoration: BoxDecoration(
          color: isSelected
              ? widget.themeState.splashLogoColor!.withOpacityValue(0.2)
              : widget.themeState.settingCustomContainerColor!,
          borderRadius: BorderRadius.circular(10.px),
          border: Border.all(
            color: isSelected
                ? widget.themeState.splashLogoColor!
                : widget.themeState.settingCustomContainerBorderColor!
                      .withOpacityValue(0.3),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Center(
          child: CustomText(
            text: label,
            fontSize: 14.px,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? widget.themeState.splashLogoColor!
                : widget.themeState.appBarTitleColor!.withOpacityValue(0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeOption(String label, int timeInSeconds, VoidCallback onTap) {
    final isSelected = timeInSeconds == selectedTime;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.px),
        decoration: BoxDecoration(
          color: isSelected
              ? widget.themeState.splashLogoColor!.withOpacityValue(0.2)
              : widget.themeState.settingCustomContainerColor!,
          borderRadius: BorderRadius.circular(10.px),
          border: Border.all(
            color: isSelected
                ? widget.themeState.splashLogoColor!
                : widget.themeState.settingCustomContainerBorderColor!
                      .withOpacityValue(0.3),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Center(
          child: CustomText(
            text: label,
            fontSize: 14.px,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? widget.themeState.splashLogoColor!
                : widget.themeState.appBarTitleColor!.withOpacityValue(0.7),
          ),
        ),
      ),
    );
  }
}
