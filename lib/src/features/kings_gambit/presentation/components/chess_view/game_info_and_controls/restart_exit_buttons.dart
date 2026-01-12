import 'package:flutter/cupertino.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/chess_view/game_info_and_controls/rounded_alert_button.dart';

class RestartExitButtons extends StatelessWidget {
  final AppModel appModel;

  const RestartExitButtons(this.appModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RoundedAlertButton(
            'Restart',
            onConfirm: () {
              appModel.newGame(context);
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RoundedAlertButton(
            'Exit',
            onConfirm: () {
              appModel.exitChessView();
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
