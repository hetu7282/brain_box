import 'package:brain_box/src/core/bloc/haptics/haptics_cubit.dart';
import 'package:brain_box/src/core/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that provides smooth scale animation on tap/press
/// Better than the standard InkWell for modern UI interactions
class SmoothScaleAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double minScale;
  final Duration duration;
  final Curve curve;
  final double pressScale;
  final bool enableHapticFeedback;

  const SmoothScaleAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.minScale = 0.95,
    this.duration = const Duration(milliseconds: 150),
    this.curve = Curves.easeInOut,
    this.pressScale = 0.97,
    this.enableHapticFeedback = true,
  });

  @override
  State<SmoothScaleAnimation> createState() => _SmoothScaleAnimationState();
}

class _SmoothScaleAnimationState extends State<SmoothScaleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressScale,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details, BuildContext context) {
    _controller.reverse().then((_) {
      if (widget.enableHapticFeedback && widget.onTap != null) {
        try {
          final bool enabled = context.read<HapticsCubit>().state.enabled;
          AudioService.instance.triggerInteractionFeedback(
            hapticsEnabled: enabled,
          );
        } catch (e) {
          // Context not available, skip haptics
        }
      }
      if (widget.onTap != null) {
        Future.microtask(() => widget.onTap?.call());
      }
    });
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: (details) => _handleTapUp(details, context),
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
