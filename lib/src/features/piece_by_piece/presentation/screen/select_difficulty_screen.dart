import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/router/router.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_appbar.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/piece_by_piece/domain/entity/piece_by_piece_entity.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/screen/piece_by_piece_screen.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/difficulty_button_widget.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class SelectDifficultyScreen extends StatefulWidget {
  final PieceByPieceEntity? selectedItem;

  const SelectDifficultyScreen({super.key, this.selectedItem});

  @override
  State<SelectDifficultyScreen> createState() => _SelectDifficultyScreenState();
}

class _SelectDifficultyScreenState extends State<SelectDifficultyScreen> {
  int _selectedDifficulty = 5; // Default to X 5 (middle button)

  @override
  Widget build(BuildContext context) {
    final selectedItem = widget.selectedItem;
    final themeState = context.watch<ThemeCubit>().state;
    return CustomBgWidget(
      appBar: CustomAppBar(title: 'Select Difficulty'),
      body: selectedItem == null
          ? Center(
              child: CustomText(
                text: 'No puzzle selected',
                color: AppColor.white,
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.px),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GapH(20.px),
                          Container(
                            width: double.infinity,
                            height: 250.px,
                            constraints: BoxConstraints(maxHeight: 50.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: themeState
                                    .settingCustomContainerBorderColor!,
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: themeState
                                      .settingCustomContainerShadowColor!,
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CustomAssetImage(
                                image: selectedItem.path ?? '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          GapH(20.px),
                          // Choose Difficulty text
                          CustomText(
                            text: 'Choose Difficulty:',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: themeState.splashLogoColor!,
                          ),
                          GapH(20.px),
                          // Difficulty buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 10.px,
                            children: [
                              Expanded(
                                child: DifficultyButtonWidget(
                                  label: 'X 2',
                                  difficulty: 2,
                                  isSelected: _selectedDifficulty == 2,
                                  onTap: () {
                                    setState(() => _selectedDifficulty = 2);
                                  },
                                ),
                              ),
                              Expanded(
                                child: DifficultyButtonWidget(
                                  label: 'X 5',
                                  difficulty: 5,
                                  isSelected: _selectedDifficulty == 5,
                                  onTap: () {
                                    setState(() => _selectedDifficulty = 5);
                                  },
                                ),
                              ),
                              Expanded(
                                child: DifficultyButtonWidget(
                                  label: 'X 10',
                                  difficulty: 10,
                                  isSelected: _selectedDifficulty == 10,
                                  onTap: () {
                                    setState(() => _selectedDifficulty = 10);
                                  },
                                ),
                              ),
                            ],
                          ),
                          GapH(20.px),
                          // Selected Difficulty Display
                          _SelectedDifficultyDisplay(
                            difficulty: _selectedDifficulty,
                          ),
                          GapH(20.px),
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    text: 'Continue',
                    onTap: () {
                      final params = PuzzleGameParams(
                        imagePath: selectedItem.path ?? '',
                        difficulty: _selectedDifficulty,
                      );
                      context.pushReplacementNamed(
                        Routes.pieceByPiece.name,
                        extra: params,
                      );
                    },
                  ),
                  GapBottom(extraHight: 10.px),
                ],
              ),
            ),
    );
  }
}

class _SelectedDifficultyDisplay extends StatelessWidget {
  final int difficulty;

  const _SelectedDifficultyDisplay({required this.difficulty});

  String _getDifficultyName(int multiplier) {
    switch (multiplier) {
      case 2:
        return 'Easy';
      case 5:
        return 'Medium';
      case 10:
        return 'Hard';
      default:
        return 'Medium';
    }
  }

  int _getPieceCount(int multiplier) {
    // Assuming base is 5 pieces, multiply by difficulty
    return multiplier * multiplier;
  }

  @override
  Widget build(BuildContext context) {
    final difficultyName = _getDifficultyName(difficulty);
    final pieceCount = _getPieceCount(difficulty);
    final themeState = context.watch<ThemeCubit>().state;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 18.px),
      decoration: BoxDecoration(
        color: themeState.settingCustomContainerColor!, // Dark blue background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeState.settingCustomContainerBorderColor!.withOpacityValue(
            0.5,
          ), // Light blue border
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Selected Difficulty:',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: themeState.splashLogoColor!, // Light blue
          ),
          GapH(8.px),
          CustomText(
            text: '$difficultyName (*$difficulty) - $pieceCount pieces',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: themeState.appBarTitleColor!,
          ),
        ],
      ),
    );
  }
}
