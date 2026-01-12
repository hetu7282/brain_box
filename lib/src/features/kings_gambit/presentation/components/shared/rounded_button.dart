import 'dart:io';

import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const RoundedButton(this.label, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: Platform.isMacOS ? 60 : 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Platform.isMacOS
              ? Colors.brown.withOpacityValue(0.5)
              : Colors.white30,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Colors.white),
        ),

        child: CustomText(
          text: label,
          color: Platform.isMacOS ? Colors.white : Colors.brown,
          fontSize: 24,
        ),
      ),
    );
  }
}
