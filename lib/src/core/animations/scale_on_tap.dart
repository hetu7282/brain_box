import 'package:flutter/material.dart';

class ScaleOnTap extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Duration duration;
  final double scale;
  const ScaleOnTap({
    super.key,
    required this.child,
    required this.onPressed,
    this.duration = const Duration(milliseconds: 120),
    this.scale = 0.97,
  });

  @override
  State<ScaleOnTap> createState() => _ScaleOnTapState();
}

class _ScaleOnTapState extends State<ScaleOnTap> {
  late final ValueNotifier<bool> _pressedNotifier;

  @override
  void initState() {
    super.initState();
    _pressedNotifier = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _pressedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressedNotifier.value = true,
      onTapCancel: () => _pressedNotifier.value = false,
      onTapUp: (_) {
        _pressedNotifier.value = false;
        widget.onPressed();
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: _pressedNotifier,
        builder: (context, pressed, child) {
          return AnimatedScale(
            duration: widget.duration,
            scale: pressed ? widget.scale : 1.0,
            curve: Curves.easeOut,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
