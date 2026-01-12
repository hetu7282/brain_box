import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/shared/text_variable.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';

class PieceThemePicker extends StatelessWidget {
  const PieceThemePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: const TextSmall('Piece Theme'),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.brown.withOpacityValue(0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: appModel.pieceThemeIndex,
                      ),
                      selectionOverlay:
                          const CupertinoPickerDefaultSelectionOverlay(
                            background: Colors.white30,
                          ),
                      itemExtent: 50,
                      onSelectedItemChanged: appModel.setPieceTheme,
                      children: AppModel.pieceThemes
                          .map(
                            (theme) => Container(
                              alignment: Alignment.center,
                              child: CustomText(
                                text: theme,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
