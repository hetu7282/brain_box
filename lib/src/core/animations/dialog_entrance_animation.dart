import 'package:flutter/material.dart';

/// A widget that provides smooth entrance animation for dialogs
/// Combines fade, scale, and slide animations for a polished effect
class DialogEntranceAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool enableSlide;
  final double scaleBegin;
  final double scaleEnd;

  const DialogEntranceAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
    this.enableSlide = true,
    this.scaleBegin = 0.8,
    this.scaleEnd = 1.0,
  });

  @override
  State<DialogEntranceAnimation> createState() =>
      _DialogEntranceAnimationState();
}

class _DialogEntranceAnimationState extends State<DialogEntranceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _scaleAnimation = Tween<double>(
      begin: widget.scaleBegin,
      end: widget.scaleEnd,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.6, curve: widget.curve),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.05), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 0.6, curve: widget.curve),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: widget.enableSlide
            ? _slideAnimation
            : AlwaysStoppedAnimation(Offset.zero),
        child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
      ),
    );
  }
}
