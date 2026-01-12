import 'package:brain_box/src/config/router/router.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/shared/rounded_button.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../widget/chess_view.dart';

class MainMenuButtons extends StatelessWidget {
  final AppModel appModel;

  const MainMenuButtons(this.appModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          RoundedButton(
            'Start',
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    appModel.newGame(context, notify: false);
                    return ChessView(appModel);
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: RoundedButton(
                  'Settings',
                  onPressed: () {
                    context.pushNamed(Routes.kingsGambitSetting.name);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
