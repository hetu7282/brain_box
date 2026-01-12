// ignore_for_file: must_be_immutable

import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';

class TextDefault extends StatelessWidget {
  final String text;
  final Color color;

  const TextDefault(this.text, {super.key, this.color = CupertinoColors.white});

  @override
  Widget build(BuildContext context) {
    return CustomText(text: text, color: color, fontSize: 16);
  }
}

class TextSmall extends StatelessWidget {
  final String text;

  const TextSmall(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.brown.withOpacityValue(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: CustomText(text: text, color: Colors.white, fontSize: 20),
    );
  }
}
