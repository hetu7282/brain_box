import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/app_string.dart';
import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/config/router/router.dart';
import 'package:brain_box/src/core/animations/pulse_animation.dart';
import 'package:brain_box/src/core/animations/slide_from_bottom_animation.dart';
import 'package:brain_box/src/core/animations/slide_from_left_animation.dart';
import 'package:brain_box/src/core/animations/slide_from_right_animation.dart';
import 'package:brain_box/src/core/bloc/haptics/haptics_cubit.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/services/audio_service.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_icon.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/home/presentation/bloc/home_selection_cubit.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeSelectionCubit _selectionCubit;

  @override
  void initState() {
    super.initState();
    _selectionCubit = HomeSelectionCubit();
  }

  @override
  void dispose() {
    _selectionCubit.close();
    super.dispose();
  }

  void _toggleSelection(String itemKey) {
    _selectionCubit.toggleSelection(itemKey);
  }

  Future<void> _navigateWithSelection(String itemKey, String routeName) async {
    _toggleSelection(itemKey);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    context.pushNamed(routeName);
    _toggleSelection(itemKey);
  }

  void _onSettingsTap() {
    _toggleSelection('settings');
    context.pushNamed(Routes.settings.name);
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return BlocProvider.value(
      value: _selectionCubit,
      child: BlocBuilder<HomeSelectionCubit, HomeSelectionState>(
        builder: (context, selectionState) {
          bool isSelected(String key) => selectionState.isSelected(key);

          return CustomBgWidget(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.px),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Logo with animation from left
                    SlideFromLeftAnimation(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 0),
                      child: CustomAssetImage(
                        image: Assets.assetsImageLogo,
                        height: 150.px,
                        width: 150.px,
                        fit: BoxFit.cover,
                        color: themeState.splashLogoColor,
                      ),
                    ),
                    GapH(5.px),
                    // Title with animation from right
                    SlideFromRightAnimation(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 100),
                      child: CustomText(
                        text: AppString.appName,
                        fontSize: 30.px,
                        fontWeight: FontWeight.bold,
                        color: themeState.splashLogoColor,
                      ),
                    ),
                    GapH(10.px),
                    // Subtitle with animation from left
                    SlideFromLeftAnimation(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 200),
                      child: CustomText(
                        text: 'Unlock Your Cognitive Potential',
                        fontSize: 14.px,
                        fontWeight: FontWeight.normal,
                        textAlign: TextAlign.center,
                        color: themeState.appBarTitleColor,
                      ),
                    ),
                    GapH(20.px),
                    _buildHomeItem(
                      title: 'Tic-Tac-Twist',
                      image: Assets.assetsIconsTicTacTwist,
                      title2: 'Slide Mastermind',
                      image2: Assets.assetsIconsSlideMastermind,
                      item1Key: 'brain_training',
                      item2Key: 'slide_mastermind',
                      onTap: () async {
                        await _navigateWithSelection(
                          'brain_training',
                          Routes.ticTacTwist.name,
                        );
                      },
                      onTap2: () async {
                        await _navigateWithSelection(
                          'slide_mastermind',
                          Routes.slideMastermind.name,
                        );
                      },
                      isSelected: isSelected,
                    ),
                    GapH(20.px),
                    _buildHomeItem(
                      title: 'Piece by Piece',
                      image: Assets.assetsIconsPieceByPiece,
                      title2: "King's Gambit",
                      image2: Assets.assetsIconsKingGambit,
                      item1Key: 'piece_by_piece',
                      item2Key: 'kings_gambit',
                      onTap: () async {
                        await _navigateWithSelection(
                          'piece_by_piece',
                          Routes.chooseYourPuzzle.name,
                        );
                      },
                      onTap2: () async {
                        await _navigateWithSelection(
                          'kings_gambit',
                          Routes.kingsGambit.name,
                        );
                      },
                      isSelected: isSelected,
                    ),
                    GapH(20.px),
                    _buildHomeItem(
                      title: 'Jurassic Journey',
                      image: Assets.assetsIconsJurassicJourney,
                      title2: 'QuickType Quest',
                      image2: Assets.assetsIconsQuickTypeQuest,
                      item1Key: 'jurassic_journey',
                      item2Key: 'quicktype_quest',
                      onTap: () async {
                        await _navigateWithSelection(
                          'jurassic_journey',
                          Routes.jurassicJourney.name,
                        );
                      },
                      onTap2: () async {
                        await _navigateWithSelection(
                          'quicktype_quest',
                          Routes.quickTypeQuest.name,
                        );
                      },
                      isSelected: isSelected,
                    ),
                    GapH(20.px),
                    SlideFromBottomAnimation(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 0),
                      child: PulseAnimation(
                        isActive: isSelected('settings'),
                        duration: const Duration(milliseconds: 300),
                        scaleBegin: 0.95,
                        scaleEnd: 1.0,
                        child: CustomButton(
                          text: 'Settings',
                          onTap: _onSettingsTap,
                        ),
                      ),
                    ),
                    GapBottom(extraHight: 20.px),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomeItem({
    required String title,
    required String image,
    required String title2,
    required String image2,
    required String item1Key,
    required String item2Key,
    required VoidCallback onTap,
    required VoidCallback onTap2,
    required bool Function(String key) isSelected,
  }) {
    final themeState = context.watch<ThemeCubit>().state;
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              final bool enabled = context.read<HapticsCubit>().state.enabled;
              AudioService.instance.triggerInteractionFeedback(
                hapticsEnabled: enabled,
              );
              onTap();
            },
            child: PulseAnimation(
              isActive: isSelected(item1Key),
              duration: const Duration(milliseconds: 300),
              scaleBegin: 0.98,
              scaleEnd: 1.0,
              child: SlideFromLeftAnimation(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.px,
                    vertical: 18.px,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isSelected(item1Key)
                          ? themeState.gradientColors2
                          : themeState.gradientColors,
                    ),
                    borderRadius: BorderRadius.circular(12.px),
                    border: Border.all(color: AppColor.transparent, width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.black.withOpacityValue(0.3),
                        blurRadius: isSelected(item1Key) ? 20.px : 10.px,
                        spreadRadius: isSelected(item1Key) ? 2.px : 0.px,
                        offset: Offset(6, 6.px),
                      ),
                      BoxShadow(
                        color: AppColor.black.withOpacityValue(0.2),
                        blurRadius: 4.px,
                        offset: Offset(2, 2.px),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.px),
                        decoration: BoxDecoration(
                          color: AppColor.white.withOpacityValue(0.15),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: themeState.iconColor!.withOpacityValue(
                                0.2,
                              ),
                              blurRadius: 8.px,
                              spreadRadius: 0.px,
                            ),
                          ],
                        ),
                        child: CustomIcon(
                          icon: image,
                          size: 50.px,
                          color: themeState.iconColor!,
                          backgroundColor: themeState.iconBackgroundColor!,
                        ),
                      ),
                      GapH(12.px),
                      CustomText(
                        text: title,
                        fontSize: 13.px,
                        fontWeight: FontWeight.bold,
                        color: AppColor.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        GapW(15.px),
        Expanded(
          child: GestureDetector(
            onTap: () {
              final bool enabled = context.read<HapticsCubit>().state.enabled;
              AudioService.instance.triggerInteractionFeedback(
                hapticsEnabled: enabled,
              );
              onTap2();
            },
            child: PulseAnimation(
              isActive: isSelected(item2Key),
              duration: const Duration(milliseconds: 300),
              scaleBegin: 0.98,
              scaleEnd: 1.0,
              child: SlideFromRightAnimation(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.px,
                    vertical: 18.px,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: isSelected(item2Key)
                          ? themeState.gradientColors2
                          : themeState.gradientColors,
                    ),
                    borderRadius: BorderRadius.circular(12.px),
                    border: Border.all(color: AppColor.transparent, width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.black.withOpacityValue(0.3),
                        blurRadius: isSelected(item2Key) ? 20.px : 10.px,
                        spreadRadius: isSelected(item2Key) ? 2.px : 0.px,
                        offset: Offset(-6, 6.px),
                      ),
                      BoxShadow(
                        color: AppColor.black.withOpacityValue(0.2),
                        blurRadius: 4.px,
                        offset: Offset(-2, 2.px),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.px),
                        decoration: BoxDecoration(
                          color: AppColor.white.withOpacityValue(0.15),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: themeState.iconColor!.withOpacityValue(
                                0.2,
                              ),
                              blurRadius: 8.px,
                              spreadRadius: 0.px,
                            ),
                          ],
                        ),
                        child: CustomIcon(
                          icon: image2,
                          size: 50.px,
                          color: themeState.iconColor!,
                          backgroundColor: themeState.iconBackgroundColor!,
                        ),
                      ),
                      GapH(12.px),
                      CustomText(
                        text: title2,
                        fontSize: 13.px,
                        fontWeight: FontWeight.bold,
                        color: AppColor.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
