import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class CustomLoderWidget extends StatelessWidget {
  const CustomLoderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: LoadingAnimationWidget.threeArchedCircle(
            color: AppColor.primary,
            size: 30,
          ),
        ),
      ),
    );
  }
}
