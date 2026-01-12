import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class DifficultyButtonWidget extends StatelessWidget {
  final String label;
  final int difficulty;
  final bool isSelected;
  final VoidCallback onTap;

  const DifficultyButtonWidget({
    super.key,
    required this.label,
    required this.difficulty,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 80.px,
        height: 50.px,
        decoration: BoxDecoration(
          color: isSelected
              ? themeState.settingCustomContainerBorderColor!
              : themeState
                    .settingCustomContainerColor!, // Dark blue fill for unselected
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? themeState.splashLogoColor!
                : themeState.settingCustomContainerBorderColor!
                      .withOpacityValue(
                        0.3,
                      ), // Light blue border for unselected
            width: 1.5,
          ),
        ),
        child: Center(
          child: CustomText(
            text: label,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? AppColor.white
                : themeState.settingCustomContainerBorderColor!,
          ),
        ),
      ),
    );
  }
}
