import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String title;
  const CustomRadioButton({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      title: CustomText(
        text: title,
        fontSize: 15.px,
        fontWeight: FontWeight.w500,
      ),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      activeColor: AppColor.primary,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}
