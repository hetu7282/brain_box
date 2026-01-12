import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/bloc/connectivity/connectivity_cubit.dart';
import 'package:brain_box/src/core/bloc/connectivity/connectivity_state.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class NoInternetScreen extends StatelessWidget {
  final Widget child;

  const NoInternetScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        return state.isConnected
            ? child
            : Scaffold(
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(gradient: themeState.gradient),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.px),
                    child: Column(
                      children: [
                        GapTop(extraHight: 80.px),
                        CustomAssetImage(
                          image:
                              themeState.noInternetImage ??
                              Assets.assetsImageNoInternetNoInternetDefault,
                          height: 200.px,
                          width: 200.px,
                        ),
                        GapH(30.px),
                        CustomText(
                          text: 'No Internet Connection',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: themeState.appBarTitleColor,
                        ),
                        GapH(10.px),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.px),
                          child: CustomText(
                            text:
                                'Please check your connection and try\nagain to continue using BrainBox.',
                            fontSize: 13.px,
                            fontWeight: FontWeight.w400,
                            color: themeState.appBarTitleColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GapH(30.px),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.px),
                          child: CustomButton(
                            text: 'Retry Connection',
                            onTap: () {
                              context
                                  .read<ConnectivityCubit>()
                                  .checkInternetConnection();
                            },
                          ),
                        ),
                        GapH(30.px),
                        CustomText(
                          text: 'BrainBox',
                          fontSize: 24.px,
                          fontWeight: FontWeight.bold,
                          color: themeState.splashLogoColor,
                          textAlign: TextAlign.center,
                        ),
                        GapH(10.px),
                        CustomText(
                          text: 'Smart learning. Anywhere.',
                          fontSize: 14.px,
                          fontWeight: FontWeight.w400,
                          color: themeState.appBarTitleColor,
                          textAlign: TextAlign.center,
                        ),
                        GapBottom(extraHight: 20.px),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
