import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;

  const RoundedIconButton(this.icon, {super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.brown.withOpacityValue(.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: const Color(0x20000000),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        onPressed: onPressed,
        child: Icon(icon, color: const Color(0xffffffff)),
      ),
    );
  }
}
