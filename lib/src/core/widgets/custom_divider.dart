import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key, this.height, this.width, this.color});
  final double? height;
  final double? width;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (height ?? 1).px,
      width: width?.px,
      color: color ?? AppColor.kE2E2E2,
    );
  }
}
