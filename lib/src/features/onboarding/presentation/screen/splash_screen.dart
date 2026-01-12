import 'package:brain_box/src/config/constants/app_string.dart';
import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/config/router/router.dart';
import 'package:brain_box/src/core/utils/post_frame_callback_mixin.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with PostFrameCallbackMixin {
  @override
  void onPostFrameCallback() {
    if (context.mounted) {
      Future.delayed(const Duration(seconds: 2), () {
        context.goNamed(Routes.onboarding.name);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: themeState.gradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomAssetImage(
              image: Assets.assetsImageLogo,
              height: 150.px,
              width: 150.px,
              fit: BoxFit.cover,
              color: themeState.splashLogoColor,
            ),
            GapH(30.px),
            CustomText(
              text: AppString.appName,
              fontSize: 22.px,
              fontWeight: FontWeight.bold,
              color: themeState.splashLogoColor,
            ),
            GapH(20.px),
            CustomText(
              text: 'Train Your Brain, Expand Your\nPotential',
              fontSize: 14.px,
              fontWeight: FontWeight.normal,
              textAlign: TextAlign.center,
              color: themeState.splashLogoColor,
            ),
          ],
        ),
      ),
    );
  }
}
