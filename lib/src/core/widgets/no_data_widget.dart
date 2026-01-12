import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    super.key,
    required this.image,
    required this.title,
    this.subtitle,
    this.showBottomPadding = true,
  });
  final String image;
  final String title;
  final String? subtitle;
  final bool showBottomPadding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.px),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAssetImage(
              image: image,
              height: 150.px,
              width: 150.px,
              fit: BoxFit.cover,
            ),
            GapH(20.px),
            CustomText(
              text: title,
              fontSize: 18.px,
              fontWeight: FontWeight.w600,
              color: AppColor.black,
            ),
            if (subtitle != null) ...[
              GapH(10.px),
              CustomText(
                text: subtitle!,
                fontSize: 16.px,
                fontWeight: FontWeight.w400,
                color: AppColor.k6A6262,
                textAlign: TextAlign.center,
              ),
            ],
            if (showBottomPadding) GapBottom(),
          ],
        ),
      ),
    );
  }
}
