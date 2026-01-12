import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/bloc/haptics/haptics_cubit.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class PuzzleTile extends StatelessWidget {
  final String label;
  final bool isEmpty;
  final VoidCallback onTap;

  const PuzzleTile({
    super.key,
    required this.label,
    required this.isEmpty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return GestureDetector(
      onTap: isEmpty
          ? null
          : () {
              final bool enabled = context.read<HapticsCubit>().state.enabled;
              if (enabled) {
                // HapticsService.instance.tap();
              }
              onTap();
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: isEmpty
              ? themeState.appBarIconBackgroundColor!
              : themeState.settingCustomContainerColor!,
          borderRadius: BorderRadius.circular(12.px),
          border: Border.all(
            color: isEmpty
                ? AppColor.transparent
                : themeState.appBarIconBackgroundColor!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isEmpty
                  ? AppColor.transparent
                  : themeState.settingCustomContainerShadowColor!,
              blurRadius: 12,
            ),
          ],
        ),

        alignment: Alignment.center,
        child: isEmpty
            ? const SizedBox.shrink()
            : CustomText(
                text: label,
                color: themeState.splashLogoColor!,
                fontWeight: FontWeight.w800,
                fontSize: 20.px,
              ),
      ),
    );
  }
}
