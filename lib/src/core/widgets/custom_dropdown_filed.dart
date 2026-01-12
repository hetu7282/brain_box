import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/bloc/haptics/haptics_cubit.dart';
import 'package:brain_box/src/core/services/audio_service.dart';
import 'package:brain_box/src/core/utils/get_device_type.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class CustomDropdownField extends StatefulWidget {
  final TextEditingController controller;
  final MenuController menuController;
  final List<String> options;
  final String? label;
  final String? hintText;
  final String? Function(String?)? validator;
  final double? width;
  final String? displayText;
  final double? menuMaxHeight;
  final EdgeInsets? itemPadding;
  final TextStyle? itemTextStyle;
  final void Function(String)? onChanged;
  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;

  const CustomDropdownField({
    super.key,
    required this.controller,
    required this.menuController,
    required this.options,
    this.label,
    this.hintText,
    this.displayText,
    this.validator,
    this.width,
    this.menuMaxHeight,
    this.itemPadding,
    this.itemTextStyle,
    this.onChanged,
    this.padding,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  late final ValueNotifier<bool> _isOpenNotifier;

  @override
  void initState() {
    super.initState();
    _isOpenNotifier = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _isOpenNotifier.dispose();
    super.dispose();
  }

  void _onItemTap(String value) {
    try {
      final bool enabled = context.read<HapticsCubit>().state.enabled;
      AudioService.instance.triggerInteractionFeedback(hapticsEnabled: enabled);
    } catch (e) {
      // Skip haptics if context not available
    }
    widget.controller.text = value;
    widget.onChanged?.call(value);
    widget.menuController.close();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: widget.menuController,
      onOpen: () => _isOpenNotifier.value = true,
      onClose: () => _isOpenNotifier.value = false,
      style: MenuStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.white),
        maximumSize: WidgetStatePropertyAll(
          Size.fromHeight(widget.menuMaxHeight ?? 180),
        ),
        alignment: Alignment(-1, 1.2),
        padding: widget.padding ?? WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      menuChildren: widget.options.map((e) {
        return InkWell(
          onTap: () => _onItemTap(e),
          child: Container(
            width:
                widget.width ??
                MediaQuery.of(context).size.width - (isTablet ? 140.px : 45.px),
            padding: widget.itemPadding ?? EdgeInsets.all(10.px),
            child: CustomText(
              text: e,
              fontSize: widget.itemTextStyle?.fontSize ?? 14.px,
              fontWeight: widget.itemTextStyle?.fontWeight ?? FontWeight.w500,
            ),
          ),
        );
      }).toList(),
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
            return ValueListenableBuilder<bool>(
              valueListenable: _isOpenNotifier,
              builder: (context, isOpen, _) {
                return CustomFormField(
                  controller: widget.controller,
                  label: widget.label,
                  hintText: widget.hintText,
                  displayText: widget.displayText,
                  readOnly: true,
                  suffixIcon: Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColor.k6A6262,
                    size: 22.px,
                  ),
                  onTap: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  validator: widget.validator,
                );
              },
            );
          },
    );
  }
}
