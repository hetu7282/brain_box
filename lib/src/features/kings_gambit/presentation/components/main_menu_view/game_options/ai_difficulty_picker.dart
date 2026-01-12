import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AIDifficultyPicker extends StatelessWidget {
  final int aiDifficulty;
  final Function(int?) setFunc;

  const AIDifficultyPicker(this.aiDifficulty, this.setFunc, {super.key});

  // Map difficulty value (1-6) to one of our three options (Low: 2, Medium: 3, High: 5)
  int _mapDifficultyToOption(int difficulty) {
    if (difficulty <= 2) {
      return 2; // Low
    } else if (difficulty <= 4) {
      return 3; // Medium
    } else {
      return 5; // High
    }
  }

  @override
  Widget build(BuildContext context) {
    final mappedDifficulty = _mapDifficultyToOption(aiDifficulty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'AI Difficulty',
          fontSize: 14.px,
          fontWeight: FontWeight.bold,
          color: AppColor.white,
        ),
        SizedBox(height: 10.px),
        Row(
          children: [
            _buildDifficultyOption('Low', 2, mappedDifficulty),
            SizedBox(width: 12.px),
            _buildDifficultyOption('Medium', 3, mappedDifficulty),
            SizedBox(width: 12.px),
            _buildDifficultyOption('High', 5, mappedDifficulty),
          ],
        ),
      ],
    );
  }

  Widget _buildDifficultyOption(
    String label,
    int difficulty,
    int selectedDifficulty,
  ) {
    final isSelected = selectedDifficulty == difficulty;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setFunc(difficulty);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.px),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor.k7FC2F4.withOpacityValue(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.px),
            border: Border.all(
              color: isSelected
                  ? AppColor.k7FC2F4
                  : AppColor.k7FC2F4.withOpacityValue(0.2),
              width: isSelected ? 2.px : 1.px,
            ),
          ),
          child: Center(
            child: CustomText(
              text: label,
              fontSize: 14.px,
              fontWeight: FontWeight.w500,
              color: AppColor.white,
            ),
          ),
        ),
      ),
    );
  }
}
