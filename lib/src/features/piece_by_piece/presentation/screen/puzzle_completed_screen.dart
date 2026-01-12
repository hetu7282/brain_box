import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/config/router/router.dart';
import 'package:brain_box/src/core/animations/smooth_scale_animation.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_appbar.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_divider.dart';
import 'package:brain_box/src/core/widgets/custom_icon.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/piece_by_piece/domain/entity/piece_by_piece_entity.dart';
import 'package:brain_box/src/features/piece_by_piece/domain/entity/puzzle_statistics.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class PuzzleCompletedScreen extends StatefulWidget {
  final String? imagePath;
  final PieceByPieceEntity? selectedItem;
  final PuzzleStatistics? statistics;

  const PuzzleCompletedScreen({
    super.key,
    this.imagePath,
    this.selectedItem,
    this.statistics,
  });

  @override
  State<PuzzleCompletedScreen> createState() => _PuzzleCompletedScreenState();
}

class _PuzzleCompletedScreenState extends State<PuzzleCompletedScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return CustomBgWidget(
      appBar: CustomAppBar(
        leadingOnTap: () {
          final entity =
              widget.selectedItem ??
              (widget.imagePath != null
                  ? PieceByPieceEntity(path: widget.imagePath)
                  : null);
          if (entity != null) {
            context.pushReplacementNamed(
              Routes.selectDifficulty.name,
              extra: entity,
            );
          }
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.px),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomText(
                text: 'Great job! You finished the puzzle.',
                fontSize: 18.px,
                fontWeight: FontWeight.w600,
                color: themeState.splashLogoColor!,
                textAlign: TextAlign.center,
              ),
              GapH(20.px),
              // Puzzle Image Frame
              if (widget.imagePath != null)
                Center(
                  child: Container(
                    width: 280.px,
                    height: 280.px,
                    padding: EdgeInsets.all(10.px),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.px),
                      border: Border.all(
                        color: themeState.jigsawPainterBackgroundBorderColor!,
                        width: 1.px,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: themeState.settingCustomContainerShadowColor!
                              .withOpacityValue(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18.px),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CustomAssetImage(
                          image: widget.imagePath!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              GapH(20.px),

              // Statistics Section
              if (widget.statistics != null)
                _StatisticsWidget(statistics: widget.statistics!),
              GapH(10.px),
              SmoothScaleAnimation(
                onTap: () {
                  // Navigate to select difficulty screen
                  final entity =
                      widget.selectedItem ??
                      (widget.imagePath != null
                          ? PieceByPieceEntity(path: widget.imagePath)
                          : null);
                  if (entity != null) {
                    // Replace current screen to prevent returning to puzzle completed
                    context.pushReplacementNamed(
                      Routes.selectDifficulty.name,
                      extra: entity,
                    );
                  }
                },
                child: CustomIconTextButton(
                  text: 'Play Again',
                  icon: Assets.assetsIconsPlayAgain,
                ),
              ),

              GapH(10.px),
              SmoothScaleAnimation(
                child: CustomButton(
                  text: 'Back to Home',
                  buttonColor: AppColor.transparent,
                  textColor: themeState.appBarTitleColor!,
                  fontSize: 15.px,
                  fontWeight: FontWeight.w500,
                  borderRadius: BorderRadius.circular(8.px),
                  borderColor: themeState.splashLogoColor!,
                  borderWidth: 1.px,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.px,
                    vertical: 16.px,
                  ),
                  onTap: () => context.goNamed(Routes.homeScreen.name),
                ),
              ),
              GapBottom(extraHight: 20.px),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatisticsWidget extends StatelessWidget {
  final PuzzleStatistics statistics;

  const _StatisticsWidget({required this.statistics});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;

    return Container(
      width: double.infinity,
      // padding: EdgeInsets.all(20.px),
      decoration: BoxDecoration(
        color: themeState.settingCustomContainerColor!.withOpacityValue(
          0.1,
        ), // Dark blue background
        borderRadius: BorderRadius.circular(16.px),
        border: Border.all(
          color: themeState.settingCustomContainerBorderColor!.withOpacityValue(
            0.5,
          ),
          width: 1.px,
        ),
        boxShadow: [
          // BoxShadow(color: Colors.white.withOpacityValue(0.3), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.px),
            child: CustomText(
              text: 'Your Statistics',
              fontSize: 18.px,
              fontWeight: FontWeight.bold,
              color: themeState.appBarTitleColor!,
            ),
          ),
          DividerWidget(
            color: themeState.settingCustomContainerBorderColor!
                .withOpacityValue(0.5),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.px),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatItem(
                  icon: Assets.assetsIconsTimeTaken,
                  label: 'Time Taken',
                  value: statistics.formattedTime,
                ),

                _StatItem(
                  icon: Assets.assetsIconsMenu,
                  label: 'Difficulty',
                  value: statistics.difficultyName,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return Expanded(
      child: Column(
        children: [
          CustomIcon(
            icon: icon,
            size: 40.px,
            color: themeState.iconColor!,
            backgroundColor: themeState.iconBackgroundColor!,
          ),
          GapH(8.px),
          CustomText(
            text: label,
            fontSize: 12.px,
            color: themeState.appBarTitleColor!,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
          GapH(4.px),
          CustomText(
            text: value,
            fontSize: 16.px,
            color: themeState.splashLogoColor!,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
