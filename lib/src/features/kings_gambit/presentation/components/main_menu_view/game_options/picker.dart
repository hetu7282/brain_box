// ignore_for_file: sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/text_variable.dart';

class Picker<T> extends StatelessWidget {
  final String? label;
  final Map<T, Widget>? options;
  final T? selection;
  final Function(T?)? setFunc;

  const Picker({
    super.key,
    this.label,
    this.options,
    this.selection,
    this.setFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextSmall(label ?? ""),
        const SizedBox(height: 10),
        /*      SizedBox(
          child: CupertinoTheme(
            data:  CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                textStyle:   GoogleFonts.merienda(
          color: Colors.white,
          fontSize: 8,
          letterSpacing: 3,
          shadows: [
            const Shadow(
              color: Colors.white,
              blurRadius: 50,
            ),
          ],
        ),
              ),
            ),
            child: CupertinoSlidingSegmentedControl <InvalidType>(
              children: options ?? {},
              groupValue: selection,
              onValueChanged: (T? val) {
                if (setFunc != null) {
                  setFunc!(val);
                }
              },
              thumbColor: Colors.brown.shade100,
              backgroundColor: Colors.brown.withOpacityValue(0.5),

            ),
          ),
          width: double.infinity,
        )
    */
      ],
    );
  }
}
