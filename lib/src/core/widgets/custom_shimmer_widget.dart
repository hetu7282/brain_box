
import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';


class CustomShimmerWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final Color baseColor;
  final Color highlightColor;
  final Widget? child;

  const CustomShimmerWidget({
    super.key,
    this.width,
    this.height,
    this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      enabled: true,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: baseColor, borderRadius: borderRadius),
        child: child,
      ),
    );
  }
}

class CustomCarShimmerWidget extends StatelessWidget {
  const CustomCarShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.primary),
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(
              width: 30.w,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
          ),
          GapH(0.5.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(
              width: 45.w,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
          ),
          GapH(2.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(
              height: 22.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
          ),
          GapH(2.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(
              width: 30.w,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
          ),
          GapH(0.5.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(
              width: 45.w,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
          ),
          GapH(2.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
          ),
          GapH(2.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
