import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/screens/no_internet_screen.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBgWidget extends StatelessWidget {
  final Widget body;
  final Widget? appBar;
  final Widget? bottomNavigationBar;
  const CustomBgWidget({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return NoInternetScreen(
      child: Scaffold(
        bottomNavigationBar: bottomNavigationBar,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColor.defultGradient,
            image: DecorationImage(
              image: AssetImage(
                themeState.bgImage ?? Assets.assetsImageThemeBgDefult,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              if (appBar != null) ...[appBar!] else ...[GapTop()],
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}
