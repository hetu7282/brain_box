import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:flutter/cupertino.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(color: AppColor.primary),
    );
  }
}
