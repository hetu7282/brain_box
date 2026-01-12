import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/app_string.dart';
import 'package:brain_box/src/core/utils/get_device_type.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String? value)? validator;
  final void Function()? onTap;
  final double borderRadius;
  final String? displayText;
  final String? label;
  final String? fontFamily;
  final String? hintText;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final int? minLines;
  final int maxLines;
  final bool readOnly;
  final bool? enabled;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final BoxConstraints? suffixIconConstraints;
  final void Function(String value)? onSubmitted;
  final void Function(String value)? onChange;
  final Color? fillColor;
  final Color? hintColor;
  final Color? boarderColor;
  final double? fontSize;
  final Color? textColor;
  final int? maxLength;
  final bool showPadding;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  final bool isUnderLineBorder;





  final EdgeInsetsGeometry? contentPadding;
  final bool isOnOutsideTapClose;

  const CustomFormField({
    super.key,
    this.controller,
    this.keyboardType,
    this.validator,
    this.onTap,
    this.borderRadius = 12,
    this.displayText,
    this.label,
    this.fontFamily,
    this.hintText,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.minLines,
    this.maxLines = 1,
    this.readOnly = false,
    this.enabled,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.done,
    this.suffixIconConstraints,
    this.onSubmitted,
    this.onChange,
    this.fillColor,
    this.hintColor,
    this.fontSize,
    this.textColor,
    this.boarderColor,
    this.maxLength,
    this.showPadding = true,
    this.isUnderLineBorder = false,
    this.inputFormatters,

    this.contentPadding,
    this.isOnOutsideTapClose = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (displayText != null) ...[
          CustomText(
            text: displayText!,
            color: AppColor.black,
            fontSize: 14.px,
            fontWeight: FontWeight.w500,
          ),
          GapH(8.px),
        ],
        TextFormField(
          onTapOutside: _onTapOutSide,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          initialValue: initialValue,
          enabled: enabled,
          readOnly: readOnly,
          onTap: onTap,
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          onFieldSubmitted: onSubmitted,
          textCapitalization: textCapitalization,
          keyboardAppearance: Brightness.dark,
          onChanged: onChange,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: fontFamily ?? AppString.fontFamily,
            color: textColor,
          ),
          decoration: InputDecoration(
            label: label != null
                ? Text(
                    label!,
                    style: TextStyle(
                      fontFamily: AppString.fontFamily,
                      color: hintColor ?? AppColor.k6A6262,
                      fontWeight: FontWeight.w400,
                      fontSize: fontSize ?? (isTablet ? 12.sp : 15.sp),
                    ),
                  )
                : null,
            hintText: hintText,
            hintStyle: TextStyle(
              color: hintColor ?? AppColor.k6A6262,
              fontSize: fontSize ?? 14.px,
            ),
            contentPadding: !showPadding
                ? EdgeInsets.zero
                : contentPadding ??
                      EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            enabledBorder: getInputBorder(
              borderColor: boarderColor,
              isUnderLineBorder: isUnderLineBorder,
              borderRadius: borderRadius,
            ),
            disabledBorder: getInputBorder(
              borderColor: boarderColor,
              isUnderLineBorder: isUnderLineBorder,
              borderRadius: borderRadius,
            ),
            focusedBorder: getInputBorder(
              borderColor: AppColor.primary,
              isUnderLineBorder: isUnderLineBorder,
              borderRadius: borderRadius,
            ),
            errorBorder: getInputBorder(
              borderColor: boarderColor ?? AppColor.kFF3B30.withAlpha(200),
              isUnderLineBorder: isUnderLineBorder,
              borderRadius: borderRadius,
            ),
            suffixIconConstraints: suffixIconConstraints,
            errorMaxLines: 3,
            errorStyle: TextStyle(
              color: AppColor.kFF3B30.withAlpha(200),
              fontSize: 13.px,
            ),
            focusedErrorBorder: getInputBorder(
              borderColor: boarderColor ?? AppColor.kFF3B30.withAlpha(178),
              isUnderLineBorder: isUnderLineBorder,
              borderRadius: borderRadius,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: fillColor ?? AppColor.white.withAlpha(5),
          ),
        ),
      ],
    );
  }

  void _onTapOutSide(PointerDownEvent event) {
    if (isOnOutsideTapClose) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

InputBorder getInputBorder({
  Color? borderColor,
  bool isUnderLineBorder = false,
  double borderRadius = 10,
}) {
  return (isUnderLineBorder)
      ? UnderlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? AppColor.kE2E2E2,
            width: 1,
          ),
        )
      : OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? AppColor.kE2E2E2,
            width: 1,
          ),
        );
}
