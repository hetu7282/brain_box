import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/utils/get_device_type.dart';
import 'package:brain_box/src/core/widgets/custom_icon.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class CustomAppBar extends StatefulWidget {
  final String? title;
  final bool isBack;
  final Widget? actionWidget;
  final Widget? leadingWidget;
  final Widget? titleWidget;
  final void Function()? leadingOnTap;

  const CustomAppBar({
    super.key,
    this.title,
    this.isBack = true,
    this.actionWidget,
    this.leadingWidget,
    this.titleWidget,
    this.leadingOnTap,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return Padding(
      padding: EdgeInsets.only(
        right: 5.w,
        top: MediaQuery.of(context).padding.top,
        // bottom: 1.h,
      ),
      child: Row(
        children: [
          widget.leadingWidget ??
              (widget.isBack
                  ? GestureDetector(
                      onTap: widget.leadingOnTap ?? () => context.pop(),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 20.px,
                          right: 10.px,
                          top: 15.px,
                          bottom: 15.px,
                        ),
                        color: AppColor.transparent,
                        child: CustomIcon(
                          icon: Assets.assetsIconsBack,

                          size: 40.px,
                          color: themeState.textOnboardingColor!,
                          backgroundColor:
                              themeState.appBarIconBackgroundColor!,
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.only(
                        left: 10.px,
                        right: 10.px,
                        top: 15.px,
                        bottom: 15.px,
                      ),
                    )),

          GapW(1.w),
          widget.titleWidget ??
              CustomText(
                text: widget.title ?? '',
                color: themeState.appBarTitleColor!,
                fontWeight: FontWeight.w700,
                fontSize: isTablet ? 20.px : 18.px,
              ),
          if (widget.actionWidget != null) ...[
            Spacer(),
            widget.actionWidget!,
          ] else ...[
            Spacer(),
            // GestureDetector(
            //   onTap: () {
            //     ChangeThemeDialog.show(context);
            //   },
            //   child: CustomIcon(
            //     icon: Assets.assetsIconsSettings,
            //     size: 40.px,
            //     color: themeState.textOnboardingColor!,
            //     backgroundColor: themeState.appBarIconBackgroundColor!,
            //   ),
            // ),
          ],
        ],
      ),
    );
  }
}
