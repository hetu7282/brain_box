import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/bloc/haptics/haptics_cubit.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/services/audio_service.dart';
import 'package:brain_box/src/core/widgets/custom_appbar.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:brain_box/src/features/tic_tac_twist/presentation/bloc/tic_tac_twist_cubit.dart';
import 'package:brain_box/src/features/tic_tac_twist/presentation/widget/scoreboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class TicTacTwistScreen extends StatelessWidget {
  const TicTacTwistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return BlocProvider(
      create: (_) => TicTacTwistCubit(),
      child: CustomBgWidget(
        appBar: CustomAppBar(title: "Tic-Tac-Twist"),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.px),
          child: BlocBuilder<TicTacTwistCubit, TicTacTwistState>(
            builder: (context, state) {
              final cubit = context.read<TicTacTwistCubit>();
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ScoreboardWidget(
                      xWins: state.xWins,
                      draws: state.draws,
                      oWins: state.oWins,
                    ),
                    GapH(20.px),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 9,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemBuilder: (context, index) {
                        final mark = state.board[index];
                        return GestureDetector(
                          onTap: () => cubit.onCellTap(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            decoration: BoxDecoration(
                              color: themeState.settingCustomContainerColor!,
                              borderRadius: BorderRadius.circular(12.px),
                              border: Border.all(
                                color: themeState
                                    .settingCustomContainerBorderColor!
                                    .withOpacityValue(0.7),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: themeState
                                      .settingCustomContainerShadowColor!
                                      .withOpacityValue(0.25),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Center(child: _AnimatedMark(mark: mark)),
                          ),
                        );
                      },
                    ),
                    GapH(20.px),
                    if (state.gameOver) _StatusBanner(winner: state.winner),
                    if (state.gameOver) GapH(16.px),
                    // Mode toggle row
                    Row(
                      children: [
                        Expanded(
                          child: _ModeButton(
                            text: 'Play vs AI',
                            selected: state.mode == GameMode.vsAI,
                            onTap: () => cubit.setMode(GameMode.vsAI),
                          ),
                        ),
                        GapW(12.px),
                        Expanded(
                          child: _ModeButton(
                            text: '2 Players',
                            selected: state.mode == GameMode.twoPlayers,
                            onTap: () => cubit.setMode(GameMode.twoPlayers),
                            outlined: true,
                          ),
                        ),
                      ],
                    ),
                    GapH(16.px),
                    _PrimaryButton(
                      text: 'Restart Game',
                      onTap: cubit.restartBoard,
                    ),
                    GapBottom(extraHight: 10.px),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MarkText extends StatelessWidget {
  final String mark;
  const _MarkText({required this.mark});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final bool isX = mark == 'X';
    return Text(
      mark,
      key: ValueKey<String>('mark-$mark'),
      style: TextStyle(
        fontSize: 40.px,
        fontWeight: FontWeight.w800,
        color: isX ? themeState.ticTacTwistColor! : AppColor.white,
      ),
    );
  }
}

class _AnimatedMark extends StatelessWidget {
  final String mark;
  const _AnimatedMark({required this.mark});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.linear,
      switchOutCurve: Curves.linear,
      transitionBuilder: (child, animation) {
        final scaleAnim = animation.drive(Tween<double>(begin: 0.85, end: 1.0));
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: scaleAnim, child: child),
        );
      },
      child: mark.isEmpty
          ? const SizedBox(key: ValueKey('empty'))
          : _MarkText(mark: mark),
    );
  }
}

// Removed old action button (replaced by mode toggle + restart button)

class _ModeButton extends StatelessWidget {
  final String text;
  final bool selected;
  final bool outlined;
  final VoidCallback onTap;
  const _ModeButton({
    required this.text,
    required this.selected,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final Color fill = selected
        ? themeState.splashLogoColor!
        : themeState.settingCustomContainerColor!.withOpacityValue(0.0);
    final Color border = selected
        ? themeState.splashLogoColor!
        : themeState.settingCustomContainerBorderColor!.withOpacityValue(0.7);
    final Color textColor = selected
        ? themeState.btnColor!
        : themeState.appBarTitleColor!;
    return _TapScale(
      onTap: onTap,
      child: CustomButton(
        text: text,
        onTap: onTap,
        buttonColor: fill,
        borderColor: border,
        textColor: textColor,
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _PrimaryButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      onTap: onTap,
      child: CustomButton(text: text, onTap: onTap),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String? winner; // null = draw
  const _StatusBanner({required this.winner});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final String text = winner == null ? 'Draw' : 'Winner: $winner';
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.px),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: themeState.settingCustomContainerColor!.withOpacityValue(0.12),
        borderRadius: BorderRadius.circular(10.px),
        border: Border.all(
          color: themeState.settingCustomContainerBorderColor!,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: themeState.appBarTitleColor!,
          fontWeight: FontWeight.w700,
          fontSize: 14.px,
        ),
      ),
    );
  }
}

class _TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _TapScale({required this.child, this.onTap});

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale> {
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
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _pressedNotifier.value = true,
      onTapCancel: () => _pressedNotifier.value = false,
      onTapUp: (_) => _pressedNotifier.value = false,
      onTap: () {
        final bool enabled = context.read<HapticsCubit>().state.enabled;
        AudioService.instance.triggerInteractionFeedback(
          hapticsEnabled: enabled,
        );
        widget.onTap?.call();
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: _pressedNotifier,
        builder: (context, pressed, child) {
          return AnimatedScale(
            scale: pressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOut,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
