import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import 'picker.dart';

enum Player { player1, player2, random }

class SidePicker extends StatelessWidget {
  final Player playerSide;
  final Function(Player?) setFunc;

  const SidePicker(this.playerSide, this.setFunc, {super.key});

  @override
  Widget build(BuildContext context) {
    Map<Player, Widget> colorOptions = <Player, Widget>{
      Player.player1: CustomText(text: 'White'),
      Player.player2: CustomText(text: 'Black'),
      Player.random: CustomText(text: 'Random'),
    };

    return Picker<Player>(
      label: 'Side',
      options: colorOptions,
      selection: playerSide,
      setFunc: setFunc,
    );
  }
}
