import 'package:flutter/material.dart';

class SlideFromRightAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;

  const SlideFromRightAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = const Duration(milliseconds: 0),
    this.curve = Curves.easeOut,
  });

  @override
  State<SlideFromRightAnimation> createState() =>
      _SlideFromRightAnimationState();
}

class _SlideFromRightAnimationState extends State<SlideFromRightAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _slideAnimation = Tween<double>(
      begin: 200,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: Opacity(opacity: _fadeAnimation.value, child: widget.child),
        );
      },
    );
  }
}
