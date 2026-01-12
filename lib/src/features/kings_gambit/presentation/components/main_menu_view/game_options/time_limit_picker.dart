import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/main_menu_view/game_options/picker.dart';
import 'package:flutter/material.dart';

class TimeLimitPicker extends StatelessWidget {
  final int? selectedTime;
  final Function(int?)? setTime;

  const TimeLimitPicker({super.key, this.selectedTime, this.setTime});

  @override
  Widget build(BuildContext context) {
    Map<int, Widget> timeOptions = <int, Widget>{
      0: CustomText(text: 'None'),
      15: CustomText(text: '15m'),
      30: CustomText(text: '30m'),
      60: CustomText(text: '1h'),
      90: CustomText(text: '1.5h'),
      120: CustomText(text: '2h'),
    };
    return Picker<int>(
      label: 'Time Limit',
      options: timeOptions,
      selection: selectedTime,
      setFunc: setTime,
    );
  }
}
