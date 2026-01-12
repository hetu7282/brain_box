import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/bloc/haptics/haptics_cubit.dart';
import 'package:brain_box/src/core/services/audio_service.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class CustomClipWidget extends StatelessWidget {
  const CustomClipWidget({
    super.key,
    required this.text,
    this.clipColor = AppColor.primary,
    this.clipBorderColor = AppColor.primary,
    this.textColor = AppColor.white,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.onTap,
  });
  final String text;
  final Color clipColor;
  final Color clipBorderColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final bool enabled = context.read<HapticsCubit>().state.enabled;
        AudioService.instance.triggerInteractionFeedback(
          hapticsEnabled: enabled,
        );
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.px, vertical: 5.px),
        decoration: BoxDecoration(
          color: clipColor,
          border: Border.all(color: clipBorderColor),
          borderRadius: BorderRadius.circular(50),
        ),
        child: CustomText(
          text: text,
          fontSize: fontSize.px,
          fontWeight: fontWeight,
          color: textColor,
        ),
      ),
    );
  }
}
