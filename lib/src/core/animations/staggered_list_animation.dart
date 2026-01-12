import 'package:flutter/material.dart';

/// A widget that creates a staggered entrance animation for a list of items
/// Each child animates in with a slight delay after the previous one
class StaggeredListAnimation extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration staggerDuration;
  final Curve curve;
  final double slideDistance;
  final bool enableFade;
  final bool enableSlide;

  const StaggeredListAnimation({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 500),
    this.staggerDuration = const Duration(milliseconds: 100),
    this.curve = Curves.easeOut,
    this.slideDistance = 30.0,
    this.enableFade = true,
    this.enableSlide = true,
  });

  @override
  State<StaggeredListAnimation> createState() => _StaggeredListAnimationState();
}

class _StaggeredListAnimationState extends State<StaggeredListAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<double>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(duration: widget.duration, vsync: this),
    );

    _fadeAnimations = _controllers
        .map(
          (controller) => Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: controller, curve: widget.curve)),
        )
        .toList();

    _slideAnimations = _controllers
        .map(
          (controller) => Tween<double>(
            begin: widget.slideDistance,
            end: 0.0,
          ).animate(CurvedAnimation(parent: controller, curve: widget.curve)),
        )
        .toList();

    // Start animations with stagger
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.staggerDuration * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.children.length,
        (index) => AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            Widget animatedChild = Opacity(
              opacity: widget.enableFade ? _fadeAnimations[index].value : 1.0,
              child: Transform.translate(
                offset: Offset(
                  0,
                  widget.enableSlide ? _slideAnimations[index].value : 0,
                ),
                child: widget.children[index],
              ),
            );
            return animatedChild;
          },
        ),
      ),
    );
  }
}
