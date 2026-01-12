import 'dart:io';
import 'dart:typed_data';

import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class CustomFileImage extends StatelessWidget {
  final double? height;
  final double? width;
  final File image;
  final BoxFit? fit;
  final Key? imageKey;
  final Color? color;
  @override
  const CustomFileImage({
    super.key,
    this.height,
    this.width,
    required this.image,
    this.fit,
    this.imageKey,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Image.file(image, key: imageKey, fit: fit, color: color),
    );
  }
}

class CustomAssetImage extends StatelessWidget {
  final double? height;
  final double? width;
  final String image;
  final BoxFit? fit;
  final Key? imageKey;
  final Color? color;
  @override
  const CustomAssetImage({
    super.key,
    this.height,
    this.width,
    required this.image,
    this.fit,
    this.imageKey,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Image.asset(
        image,
        key: imageKey,
        fit: fit,
        color: color,
        height: height,
        width: width,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.withOpacityValue(0.3),
            child: const Icon(
              Icons.broken_image_outlined,
              color: Colors.white54,
            ),
          );
        },
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          if (frame != null) return child;
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(color: AppColor.white),
          );
        },
      ),
    );
  }
}

class CustomUint8ListImage extends StatelessWidget {
  final double? height;
  final double? width;
  final Uint8List image;
  final BoxFit? fit;
  final Key? imageKey;
  final Color? color;
  @override
  const CustomUint8ListImage({
    super.key,
    this.height,
    this.width,
    required this.image,
    this.fit,
    this.imageKey,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Image.memory(image, key: imageKey, fit: fit, color: color),
    );
  }
}

class CustomNetworkImage extends StatelessWidget {
  final String image;
  final BoxFit fit;
  final double? radius;
  final double? height;
  final double? width;
  const CustomNetworkImage({
    super.key,
    required this.image,
    this.fit = BoxFit.cover,
    this.radius = 1.5,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius!.px),
      child: CachedNetworkImage(
        imageUrl: image,
        fit: fit,
        width: width ?? double.infinity,
        height: height,
        placeholder: (context, url) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
            ),
          );
        },
        errorWidget: (context, url, error) {
          final themeState = context.watch<ThemeCubit>().state;
          return Image.asset(
            themeState.noInternetImage ??
                Assets.assetsImageNoInternetNoInternetDefault,
            width: width ?? double.infinity,
            height: height,
          );
        },
      ),
    );
  }
}

class CustomNoImage extends StatelessWidget {
  final double? radius;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Key? imageKey;
  final Color? color;
  const CustomNoImage({
    super.key,
    this.radius,
    this.height,
    this.width,
    this.fit,
    this.imageKey,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColor.kF0FFF2,
        borderRadius: BorderRadius.circular(radius ?? 10.sp),
        border: Border.all(color: AppColor.primary),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            themeState.noInternetImage!,
            scale: 5,
            key: imageKey,
            fit: fit,
            color: color,
          ),
          GapH(10.px),
          CustomText(text: 'No Image here', color: AppColor.primary),
        ],
      ),
    );
  }
}
