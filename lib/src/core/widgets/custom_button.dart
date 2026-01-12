import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/bloc/haptics/haptics_cubit.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/services/audio_service.dart';
import 'package:brain_box/src/core/utils/get_device_type.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Color? textColor;
  final Color? buttonColor;
  final double? fontSize;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool isLoading;
  final Color? loadingColor;

  final BorderRadiusGeometry? borderRadius;
  final FontWeight? fontWeight;
  final Color? borderColor;
  final double? borderWidth;
  final Gradient? gradient;
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.buttonColor,
    this.textColor,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.fontWeight,
    this.borderColor,
    this.borderWidth,
    this.margin,
    this.isLoading = false,
    this.gradient,
    this.loadingColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              final bool enabled = context.read<HapticsCubit>().state.enabled;
              AudioService.instance.triggerInteractionFeedback(
                hapticsEnabled: enabled,
              );
              onTap?.call();
            },
      child: Container(
        padding:
            padding ?? EdgeInsets.symmetric(vertical: isTablet ? 1.5.h : 1.5.h),
        margin: margin,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: gradient,
          border: Border.all(
            color: borderColor ?? AppColor.transparent,
            width: borderWidth ?? 1.px,
          ),
          color: buttonColor ?? themeState.splashLogoColor,
          borderRadius: borderRadius ?? BorderRadius.circular(5),
        ),
        child: isLoading
            ? SizedBox(
                height: isTablet ? 18 : 20.7,
                width: 20,
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: AppColor.white,
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation(loadingColor),
                ),
              )
            : CustomText(
                text: text,
                fontWeight: fontWeight ?? FontWeight.w700,
                color: textColor ?? themeState.btnColor,
                fontSize: fontSize ?? (isTablet ? 12.sp : 16.sp),
              ),
      ),
    );
  }
}

class CustomIconTextButton extends StatelessWidget {
  final String text;
  final String icon;
  const CustomIconTextButton({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.px),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: themeState.splashLogoColor!.withOpacityValue(0.15),
        borderRadius: BorderRadius.circular(5.px),
        border: Border.all(
          color: themeState.splashLogoColor!.withOpacityValue(0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: themeState.settingCustomContainerShadowColor!
                .withOpacityValue(0.3),
            blurRadius: 15.px,
            offset: Offset(0, 5.px),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomAssetImage(
            image: icon,
            height: 18.px,
            width: 18.px,
            color: themeState.appBarTitleColor!,
          ),
          GapW(8.px),
          CustomText(
            text: text,
            color: themeState.appBarTitleColor!,
            fontWeight: FontWeight.w700,
            fontSize: 14.px,
          ),
        ],
      ),
    );
  }
}
