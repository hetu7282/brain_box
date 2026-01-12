import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';

class Toggle extends StatelessWidget {
  final String label;
  final bool? toggle;
  final Function(bool)? setFunc;

  const Toggle(this.label, {super.key, this.toggle, this.setFunc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.brown.withOpacityValue(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
      ),

      child: Row(
        children: [
          CustomText(text: label, color: Colors.white, fontSize: 15),
          const Spacer(),
          CupertinoSwitch(value: toggle ?? false, onChanged: setFunc),
        ],
      ),
    );
  }
}
