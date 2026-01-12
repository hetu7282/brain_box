import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final dynamic value;
  final Color checkColor;
  final Color borderColor;
  final ValueChanged<bool?>? onChanged;

  const CustomCheckbox({
    super.key,
    required this.value,
    this.checkColor = AppColor.white, // Default to a blue color
    this.borderColor = AppColor.primary, // Default to a gray border
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Checkbox(
        checkColor: checkColor,
        activeColor: AppColor.primary,
        side: WidgetStateBorderSide.resolveWith((states) {
          return BorderSide(width: 1.5, color: borderColor);
        }),
        value: value,
        onChanged: (value) {
          if (onChanged != null) {
            onChanged!(value);
          }
          value = value ?? false;
        },
      ),
    );
  }
}
