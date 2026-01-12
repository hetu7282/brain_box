import 'package:flutter/widgets.dart';

class GapH extends StatelessWidget {
  final double height;
  const GapH(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class GapW extends StatelessWidget {
  final double width;
  const GapW(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

class GapTop extends StatelessWidget {
  final double extraHight;
  const GapTop({super.key, this.extraHight = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).padding.top + extraHight);
  }
}

class GapBottom extends StatelessWidget {
  final double extraHight;
  const GapBottom({super.key, this.extraHight = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).padding.bottom + extraHight);
  }
}
