import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:sizer/sizer.dart';

class CustomSwitch extends StatelessWidget {
  final bool initialValue;
  final ValueNotifier<bool>? controller;
  final ValueChanged<dynamic>? onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final BorderRadius borderRadius;
  final double width;
  final double height;
  final bool enabled;
  final double disabledOpacity;

  const CustomSwitch({
    super.key,
    this.initialValue = false, // Default value
    this.controller,
    this.onChanged,
    this.activeColor = AppColor.primary,
    this.inactiveColor = Colors.grey,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    this.width = 51.0,
    this.height = 31.0,
    this.enabled = true,
    this.disabledOpacity = 1,
  });

  @override
  Widget build(BuildContext context) {
    return AdvancedSwitch(
      initialValue: initialValue,
      controller: controller,
      onChanged: onChanged,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      borderRadius: borderRadius,
      width: width.px,
      height: height.px,
      enabled: enabled,
      disabledOpacity: disabledOpacity,
    );
  }
}
