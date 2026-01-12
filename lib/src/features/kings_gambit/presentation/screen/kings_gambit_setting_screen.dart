import 'dart:async';

import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/animations/smooth_scale_animation.dart';
import 'package:brain_box/src/core/animations/staggered_list_animation.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_appbar.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_divider.dart';
import 'package:brain_box/src/core/widgets/custom_switch_widget.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/bloc/kings_gambit_settings_cubit.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/main_menu_view/game_options/side_picker.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/settings_view/piece_preview.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/constants/kings_gambit_constants.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class KingsGambitSettingScreen extends StatefulWidget {
  const KingsGambitSettingScreen({super.key});

  @override
  State<KingsGambitSettingScreen> createState() =>
      _KingsGambitSettingScreenState();
}

class _KingsGambitSettingScreenState extends State<KingsGambitSettingScreen> {
  late final ValueNotifier<bool> _showHintsController;
  late final ValueNotifier<bool> _allowUndoRedoController;
  late final KingsGambitSettingsCubit _settingsCubit;
  StreamSubscription<KingsGambitSettingsState>? _settingsSubscription;

  @override
  void initState() {
    super.initState();
    _settingsCubit = KingsGambitSettingsCubit();
    _showHintsController = ValueNotifier<bool>(_settingsCubit.state.showHints);
    _allowUndoRedoController = ValueNotifier<bool>(
      _settingsCubit.state.allowUndoRedo,
    );
    _settingsSubscription = _settingsCubit.stream.listen(
      _syncControllersFromState,
    );
  }

  void _syncControllersFromState(KingsGambitSettingsState state) {
    if (_showHintsController.value != state.showHints) {
      _showHintsController.value = state.showHints;
    }
    if (_allowUndoRedoController.value != state.allowUndoRedo) {
      _allowUndoRedoController.value = state.allowUndoRedo;
    }
  }

  String _formatThemeName(String displayName) {
    return displayName.toLowerCase().replaceAll(' ', '').replaceAll('-', '');
  }

  @override
  void dispose() {
    _showHintsController.dispose();
    _allowUndoRedoController.dispose();
    _settingsSubscription?.cancel();
    _settingsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _settingsCubit,
      child: BlocBuilder<KingsGambitSettingsCubit, KingsGambitSettingsState>(
        builder: (context, state) {
          _syncControllersFromState(state);
          final themeState = context.watch<ThemeCubit>().state;
          return CustomBgWidget(
            appBar: CustomAppBar(title: 'Setting'),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(25.px),
              child: StaggeredListAnimation(
                duration: const Duration(milliseconds: 600),
                staggerDuration: const Duration(milliseconds: 150),
                curve: Curves.easeOutCubic,
                slideDistance: 30.0,
                children: [
                  // Settings content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Settings Container
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12.px),
                        decoration: BoxDecoration(
                          color: themeState.settingCustomContainerColor!
                              .withOpacityValue(0.15),
                          borderRadius: BorderRadius.circular(16.px),
                          border: Border.all(
                            color: themeState.textOnboardingBorderColor!
                                .withOpacityValue(0.2),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: themeState
                                  .settingCustomContainerShadowColor!
                                  .withOpacityValue(0.3),
                              blurRadius: 15.px,
                              offset: Offset(0, 5.px),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildSettingRow(
                              title: 'Show Hints',
                              controller: _showHintsController,
                              onChanged: (value) =>
                                  _settingsCubit.toggleShowHints(value),
                            ),
                            GapH(12.px),
                            DividerWidget(
                              color: themeState.textOnboardingBorderColor!
                                  .withOpacityValue(0.2),
                            ),
                            GapH(12.px),
                            _buildSettingRow(
                              title: 'Allow Undo/Redo',
                              controller: _allowUndoRedoController,
                              onChanged: (value) =>
                                  _settingsCubit.toggleAllowUndoRedo(value),
                            ),
                          ],
                        ),
                      ),
                      GapH(30.px),
                      // App Theme Container
                      Container(
                        padding: EdgeInsets.all(16.px),
                        decoration: BoxDecoration(
                          color: themeState.settingCustomContainerColor!
                              .withOpacityValue(0.15),
                          borderRadius: BorderRadius.circular(16.px),
                          border: Border.all(
                            color: themeState.textOnboardingBorderColor!
                                .withOpacityValue(0.2),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: themeState
                                  .settingCustomContainerShadowColor!
                                  .withOpacityValue(0.3),
                              blurRadius: 15.px,
                              offset: Offset(0, 5.px),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'App Theme',
                              fontSize: 15.px,
                              fontWeight: FontWeight.bold,
                              color: themeState.appBarTitleColor!,
                            ),
                            GapH(20.px),
                            // List of all themes
                            SizedBox(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: AppModel.themeList.map((theme) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: 12.px),
                                      child: _buildThemeOptionList(
                                        theme,
                                        state,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GapH(30.px),
                      // Piece Theme Container
                      Container(
                        padding: EdgeInsets.all(16.px),
                        decoration: BoxDecoration(
                          color: themeState.settingCustomContainerColor!
                              .withOpacityValue(0.15),
                          borderRadius: BorderRadius.circular(16.px),
                          border: Border.all(
                            color: themeState.textOnboardingBorderColor!
                                .withOpacityValue(0.2),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: themeState
                                  .settingCustomContainerShadowColor!
                                  .withOpacityValue(0.3),
                              blurRadius: 15.px,
                              offset: Offset(0, 5.px),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Piece Theme',
                              fontSize: 15.px,
                              fontWeight: FontWeight.bold,
                              color: themeState.appBarTitleColor!,
                            ),
                            GapH(20.px),
                            // List of all piece themes
                            SizedBox(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: kKingsGambitPieceThemes.map((
                                    themeName,
                                  ) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: 12.px),
                                      child: _buildPieceThemeOption(
                                        themeName: themeName,
                                        state: state,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GapH(30.px),
                      // AI Difficulty Container
                      Container(
                        padding: EdgeInsets.all(16.px),
                        decoration: BoxDecoration(
                          color: themeState.settingCustomContainerColor!
                              .withOpacityValue(0.15),
                          borderRadius: BorderRadius.circular(16.px),
                          border: Border.all(
                            color: themeState.textOnboardingBorderColor!
                                .withOpacityValue(0.2),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: themeState
                                  .settingCustomContainerShadowColor!
                                  .withOpacityValue(0.3),
                              blurRadius: 15.px,
                              offset: Offset(0, 5.px),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // AI Difficulty Label
                            CustomText(
                              text: 'AI Difficulty',
                              fontSize: 14.px,
                              fontWeight: FontWeight.bold,
                              color: themeState.appBarTitleColor!,
                            ),

                            GapH(10.px),
                            // Difficulty Slider
                            _buildAIDifficultyPicker(state),
                          ],
                        ),
                      ),
                      GapH(30.px),
                      // Player Side Container
                      Container(
                        padding: EdgeInsets.all(16.px),
                        decoration: BoxDecoration(
                          color: themeState.settingCustomContainerColor!
                              .withOpacityValue(0.15),
                          borderRadius: BorderRadius.circular(16.px),
                          border: Border.all(
                            color: themeState.textOnboardingBorderColor!
                                .withOpacityValue(0.2),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: themeState
                                  .settingCustomContainerShadowColor!
                                  .withOpacityValue(0.3),
                              blurRadius: 15.px,
                              offset: Offset(0, 5.px),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Side Label
                            CustomText(
                              text: 'Your Side',
                              fontSize: 14.px,
                              fontWeight: FontWeight.bold,
                              color: themeState.appBarTitleColor!,
                            ),
                            GapH(10.px),
                            // Side Options
                            _buildSidePicker(state),
                          ],
                        ),
                      ),
                    ],
                  ),
                  GapH(30.px),
                  // Back Button
                  SmoothScaleAnimation(
                    onTap: () => context.pop(),
                    child: CustomButton(
                      text: 'Back',
                      buttonColor: AppColor.transparent,
                      textColor: themeState.appBarTitleColor!,
                      fontSize: 15.px,
                      fontWeight: FontWeight.w500,
                      borderRadius: BorderRadius.circular(8.px),
                      borderColor: themeState.splashLogoColor!.withOpacityValue(
                        0.2,
                      ),
                      borderWidth: 1.px,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.px,
                        vertical: 16.px,
                      ),
                      onTap: () => context.pop(),
                    ),
                  ),
                  GapBottom(extraHight: 10.px),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingRow({
    required String title,
    required ValueNotifier<bool> controller,
    required ValueChanged<bool> onChanged,
  }) {
    final themeState = context.watch<ThemeCubit>().state;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.px),
      child: Row(
        children: [
          CustomText(
            text: title,
            fontSize: 14.px,
            fontWeight: FontWeight.w500,
            color: themeState.appBarTitleColor!,
          ),
          Spacer(),
          CustomSwitch(
            controller: controller,
            activeColor: themeState.splashLogoColor!,
            inactiveColor: themeState.textOnboardingBorderColor!
                .withOpacityValue(0.2),
            width: 40.px,
            height: 20.px,
            initialValue: controller.value,
            onChanged: (value) {
              controller.value = value;
              onChanged(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOptionList(
    ChessTheme theme,
    KingsGambitSettingsState state,
  ) {
    final isSelected = state.selectedTheme.name == theme.name;
    final appModel = AppModel();
    appModel.setThemeObject(theme);
    final themeState = context.watch<ThemeCubit>().state;
    return GestureDetector(
      onTap: () => _settingsCubit.selectTheme(theme),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: BoxConstraints(minWidth: 140.px),
        padding: EdgeInsets.all(12.px),
        decoration: BoxDecoration(
          color: themeState.settingCustomContainerColor!.withOpacityValue(
            isSelected ? 0.2 : 0.1,
          ),
          borderRadius: BorderRadius.circular(12.px),
          border: Border.all(
            color: isSelected
                ? themeState.splashLogoColor!
                : AppColor.transparent,
            width: isSelected ? 2.px : 1.px,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Theme preview
            Container(
              width: 50.px,
              height: 50.px,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.px),
                border: Border.all(color: theme.border, width: 2.px),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.px),
                child: GameWidget(
                  game: PiecePreview(appModel, showPieces: false),
                ),
              ),
            ),
            GapH(12.px),
            // Theme name
            Flexible(
              child: CustomText(
                text: theme.name,
                fontSize: 14.px,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: themeState.appBarTitleColor!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieceThemeOption({
    required String themeName,
    required KingsGambitSettingsState state,
  }) {
    final isSelected = state.selectedPieceTheme == themeName;
    final themeString = _formatThemeName(themeName);
    final appModel = AppModel();
    appModel.setPieceThemeString(themeString);
    final themeState = context.watch<ThemeCubit>().state;

    return GestureDetector(
      onTap: () => _settingsCubit.selectPieceTheme(themeName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: BoxConstraints(minWidth: 100.px),
        padding: EdgeInsets.all(8.px),
        decoration: BoxDecoration(
          color: themeState.settingCustomContainerColor!.withOpacityValue(
            isSelected ? 0.2 : 0.1,
          ),
          borderRadius: BorderRadius.circular(12.px),
          border: Border.all(
            color: isSelected
                ? themeState.splashLogoColor!
                : AppColor.transparent,
            width: isSelected ? 2.px : 1.px,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.px,
              height: 55.px,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.px),
                border: Border.all(color: appModel.theme.border, width: 2.px),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.px),
                child: GameWidget(
                  game: PiecePreview(appModel, showPieces: true),
                ),
              ),
            ),
            GapH(8.px),
            CustomText(
              text: themeName,
              fontSize: 12.px,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: themeState.appBarTitleColor!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIDifficultyPicker(KingsGambitSettingsState state) {
    return Row(
      spacing: 12.px,
      children: [
        _buildDifficultyOption('Low', 2, state),
        _buildDifficultyOption('Medium', 3, state),
        _buildDifficultyOption('High', 5, state),
      ],
    );
  }

  Widget _buildDifficultyOption(
    String label,
    int difficulty,
    KingsGambitSettingsState state,
  ) {
    final isSelected = state.selectedAIDifficulty == difficulty;
    final themeState = context.watch<ThemeCubit>().state;
    return Expanded(
      child: GestureDetector(
        onTap: () => _settingsCubit.selectAIDifficulty(difficulty),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.px),
          decoration: BoxDecoration(
            color: isSelected
                ? themeState.textOnboardingBorderColor!.withOpacityValue(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.px),
            border: Border.all(
              color: isSelected
                  ? themeState.splashLogoColor!
                  : themeState.textOnboardingBorderColor!.withOpacityValue(0.2),
              width: isSelected ? 2.px : 1.px,
            ),
          ),
          child: Center(
            child: CustomText(
              text: label,
              fontSize: 14.px,
              fontWeight: FontWeight.w500,
              color: themeState.appBarTitleColor!,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidePicker(KingsGambitSettingsState state) {
    return Row(
      spacing: 12.px,
      children: [
        _buildSideOption('White', Player.player1, state.selectedPlayerSide),
        _buildSideOption('Black', Player.player2, state.selectedPlayerSide),
        _buildSideOption('Random', Player.random, state.selectedPlayerSide),
      ],
    );
  }

  Widget _buildSideOption(
    String label,
    Player player,
    Player selectedPlayerSide,
  ) {
    final isSelected = selectedPlayerSide == player;
    final themeState = context.watch<ThemeCubit>().state;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _settingsCubit.selectPlayerSide(player);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.px),
          decoration: BoxDecoration(
            color: isSelected
                ? themeState.textOnboardingBorderColor!.withOpacityValue(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.px),
            border: Border.all(
              color: isSelected
                  ? themeState.splashLogoColor!
                  : themeState.textOnboardingBorderColor!.withOpacityValue(0.2),
              width: isSelected ? 2.px : 1.px,
            ),
          ),
          child: Center(
            child: CustomText(
              text: label,
              fontSize: 14.px,
              fontWeight: FontWeight.w500,
              color:
                  themeState.appBarTitleColor!, // White text when not selected
            ),
          ),
        ),
      ),
    );
  }
}
