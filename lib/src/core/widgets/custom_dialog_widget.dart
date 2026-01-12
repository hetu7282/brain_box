import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/bloc/haptics/haptics_cubit.dart';
import 'package:brain_box/src/core/services/audio_service.dart';
import 'package:brain_box/src/core/utils/get_device_type.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class CustomDialogWidget extends StatelessWidget {
  final String title, btn1Text, btn2Text, icon;
  final void Function() onBtn1Tap, onBtn2Tap;
  final Color? buttonBtn1Color,
      buttonBtn2Color,
      textColor,
      borderColor,
      iconBgColor;

  const CustomDialogWidget({
    super.key,
    required this.onBtn1Tap,
    required this.onBtn2Tap,
    required this.title,
    required this.btn1Text,
    required this.btn2Text,
    required this.icon,
    this.buttonBtn1Color,
    this.buttonBtn2Color,
    this.textColor,
    this.borderColor,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 2,
      insetPadding: EdgeInsets.symmetric(horizontal: isTablet ? 200.px : 20.px),
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.px)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.h),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      final bool enabled = context
                          .read<HapticsCubit>()
                          .state
                          .enabled;
                      AudioService.instance.triggerInteractionFeedback(
                        hapticsEnabled: enabled,
                      );
                      context.pop();
                    },
                    child: CustomAssetImage(
                      image: Assets.assetsIconsClose,
                      height: 24.px,
                      width: 24.px,
                    ),
                  ),
                ),
                GapH(9.px),
                Container(
                  padding: EdgeInsets.all(33.px),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: CustomAssetImage(
                    image: icon,
                    height: 73.px,
                    width: 73.px,
                  ),
                ),
                GapH(17.px),
                CustomText(
                  text: title,
                  fontSize: 16.px,
                  textAlign: TextAlign.center,
                ),
                GapH(30.px),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: btn1Text,
                        borderColor: borderColor,
                        buttonColor: buttonBtn1Color,
                        textColor: textColor,
                        borderWidth: 1.px,
                        onTap: onBtn1Tap,
                      ),
                    ),
                    GapW(10.px),
                    Expanded(
                      child: CustomButton(
                        text: btn2Text,
                        onTap: onBtn2Tap,
                        buttonColor: buttonBtn2Color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
