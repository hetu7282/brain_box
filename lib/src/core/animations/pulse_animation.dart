import 'package:flutter/material.dart';

/// A pulse animation widget that scales up and down smoothly
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double scaleBegin;
  final double scaleEnd;
  final Curve curve;
  final bool isActive;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.scaleBegin = 0.95,
    this.scaleEnd = 1.0,
    this.curve = Curves.easeInOut,
    this.isActive = false,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _scaleAnimation = Tween<double>(
      begin: widget.scaleBegin,
      end: widget.scaleEnd,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    if (widget.isActive) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(PulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
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
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}
