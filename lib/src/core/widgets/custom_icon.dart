import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomIcon extends StatelessWidget {
  final String icon;
  final double size;
  final Color color;
  final Color backgroundColor;
  const CustomIcon({
    super.key,
    required this.icon,
    this.size = 24,
    this.color = AppColor.white,
    this.backgroundColor = AppColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      padding: EdgeInsets.all(10.px),
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: CustomAssetImage(
        image: icon,
        height: size,
        width: size,
        color: color,
      ),
    );
  }
}
