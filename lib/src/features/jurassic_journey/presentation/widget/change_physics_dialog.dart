import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/animations/animations.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_divider.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ChangePhysicsDialog extends StatefulWidget {
  final int gravity;
  final double acceleration;
  final double initialVelocity;
  final double jumpVelocity;
  final int dayNightOffset;
  final Function(
    int gravity,
    double acceleration,
    double initialVelocity,
    double jumpVelocity,
    int dayNightOffset,
  )?
  onSave;

  const ChangePhysicsDialog({
    super.key,
    required this.gravity,
    required this.acceleration,
    required this.initialVelocity,
    required this.jumpVelocity,
    required this.dayNightOffset,
    this.onSave,
  });

  @override
  State<ChangePhysicsDialog> createState() => _ChangePhysicsDialogState();
}

class _ChangePhysicsDialogState extends State<ChangePhysicsDialog> {
  late TextEditingController gravityController;
  late TextEditingController accelerationController;
  late TextEditingController runVelocityController;
  late TextEditingController jumpVelocityController;
  late TextEditingController dayNightOffsetController;

  @override
  void initState() {
    super.initState();
    gravityController = TextEditingController(text: widget.gravity.toString());
    accelerationController = TextEditingController(
      text: widget.acceleration.toString(),
    );
    runVelocityController = TextEditingController(
      text: widget.initialVelocity.toString(),
    );
    jumpVelocityController = TextEditingController(
      text: widget.jumpVelocity.toString(),
    );
    dayNightOffsetController = TextEditingController(
      text: widget.dayNightOffset.toString(),
    );
  }

  @override
  void dispose() {
    gravityController.dispose();
    accelerationController.dispose();
    runVelocityController.dispose();
    jumpVelocityController.dispose();
    dayNightOffsetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.px)),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GapH(20.px),
                Row(
                  children: [
                    GapW(10.px),
                    Spacer(),
                    CustomText(
                      text: 'Setting',
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
                // Input Fields
                _buildInputField('Gravity', gravityController),
                GapH(15.px),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.px),
                  child: DividerWidget(
                    color: themeState.splashLogoColor!.withOpacityValue(0.5),
                  ),
                ),
                GapH(15.px),
                _buildInputField('Acceleration', accelerationController),
                GapH(15.px),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.px),
                  child: DividerWidget(
                    color: themeState.splashLogoColor!.withOpacityValue(0.5),
                  ),
                ),
                GapH(15.px),
                _buildInputField('Initial Velocity', runVelocityController),
                GapH(15.px),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.px),
                  child: DividerWidget(
                    color: themeState.splashLogoColor!.withOpacityValue(0.5),
                  ),
                ),
                GapH(15.px),
                _buildInputField('Jump Velocity', jumpVelocityController),
                // GapH(15.px),
                // _buildInputField('Day - Night Offset', dayNightOffsetController),
                GapH(25.px),
                // Action Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.px),
                  child: CustomButton(
                    text: 'Apply',
                    onTap: () {
                      final newGravity = int.parse(gravityController.text);
                      final newAcceleration = double.parse(
                        accelerationController.text,
                      );
                      final newInitialVelocity = double.parse(
                        runVelocityController.text,
                      );
                      final newJumpVelocity = double.parse(
                        jumpVelocityController.text,
                      );
                      final newDayNightOffset = int.parse(
                        dayNightOffsetController.text,
                      );

                      if (widget.onSave != null) {
                        widget.onSave!(
                          newGravity,
                          newAcceleration,
                          newInitialVelocity,
                          newJumpVelocity,
                          newDayNightOffset,
                        );
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                GapH(10.px),
                // Cancel Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.px),
                  child: CustomButton(
                    text: 'Cancel',
                    buttonColor: themeState.settingCustomContainerColor!,
                    textColor: themeState.textOnboardingColor!,
                    borderRadius: BorderRadius.circular(10.px),
                    borderColor: themeState.settingCustomContainerBorderColor!,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                GapH(20.px),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    final themeState = context.watch<ThemeCubit>().state;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: label,
            fontSize: 14.px,
            fontWeight: FontWeight.w500,
            color: themeState.textOnboardingColor!,
          ),
          SizedBox(
            width: 100.px,
            height: 40.px,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: themeState.textOnboardingColor!,
                fontSize: 14.px,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: themeState.settingCustomContainerColor!,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: themeState.settingCustomContainerBorderColor!,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: themeState.settingCustomContainerBorderColor!,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: themeState.settingCustomContainerBorderColor!,
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.px,
                  vertical: 10.px,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
