import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class PermissionDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget>? children;
  final EdgeInsets? contentPadding;
  final double? height;
  final bool isShowClosebutton;

  const PermissionDialog({
    super.key,
    this.children,
    required this.title,
    required this.message,
    this.contentPadding,
    this.height,
    this.isShowClosebutton = true,
  });

  @override
  Widget build(BuildContext context) {
    double borderRadius = 20;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GapH(2.h),
          CustomText(
            text: title,
            textAlign: TextAlign.center,
            color: Colors.black,
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
          GapH(1.2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: CustomText(
              text: message,
              textAlign: TextAlign.center,
              fontSize: 15.sp,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          GapH(2.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    fontSize: 15.sp,
                    text: 'Cancel',
                    buttonColor: AppColor.transparent,
                    textColor: AppColor.primary,
                    borderColor: AppColor.primary,
                    onTap: () => context.pop(),
                  ),
                ),
                GapW(2.w),
                Expanded(
                  child: CustomButton(
                    text: 'Go to Settings',
                    fontSize: 15.sp,
                    onTap: () => _goSetting(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goSetting(BuildContext context) {
    Navigator.pop(context);
    openAppSettings();
  }
}
