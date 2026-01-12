import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import 'picker.dart';

class GameModePicker extends StatelessWidget {
  final int playerCount;
  final Function(int?) setFunc;

  const GameModePicker(this.playerCount, this.setFunc, {super.key});

  @override
  Widget build(BuildContext context) {
    final Map<int, Widget> playerCountOptions = <int, Widget>{
      1: CustomText(text: 'One Player'),
      2: CustomText(text: 'Two Player'),
    };
    return Picker<int>(
      label: 'Game Mode',
      options: playerCountOptions,
      selection: playerCount,
      setFunc: setFunc,
    );
  }
}
