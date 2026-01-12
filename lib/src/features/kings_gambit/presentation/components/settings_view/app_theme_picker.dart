import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/shared/text_variable.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';

class AppThemePicker extends StatelessWidget {
  const AppThemePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: const TextSmall('App Theme'),
          ),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.brown.withOpacityValue(0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: appModel.themeIndex,
              ),
              selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
                background: Colors.white30,
              ),
              itemExtent: 50,
              onSelectedItemChanged: appModel.setTheme,
              children: AppModel.themeList
                  .map(
                    (theme) => Container(
                      padding: const EdgeInsets.all(10),
                      child: CustomText(
                        text: theme.name,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
