import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:brain_box/src/features/slide_mastermind/presentation/bloc/slide_mastermind_cubit.dart';
import 'package:brain_box/src/features/slide_mastermind/presentation/widget/puzzle_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class PuzzleBoard extends StatelessWidget {
  final int gridSize;
  final double padding;
  final double spacing;

  const PuzzleBoard({
    super.key,
    required this.gridSize,
    required this.padding,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide;
        // keep computed size if needed later for animations or scaling
        // final tileSize = (size - padding * 2 - spacing * (gridSize - 1)) / gridSize;

        return Center(
          child: Container(
            width: size,
            height: size,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: themeState.settingCustomContainerColor!,
              borderRadius: BorderRadius.circular(16.px),
              border: Border.all(
                color: themeState.settingCustomContainerBorderColor!,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: themeState.settingCustomContainerShadowColor!,
                  blurRadius: 15.px,
                  offset: Offset(0, 5.px),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, innerConstraints) {
                final innerSide = size - padding * 2.5;
                final tileSize =
                    (innerSide - spacing * (gridSize - 1)) / gridSize;

                return BlocBuilder<SlideMastermindCubit, SlideMastermindState>(
                  buildWhen: (p, c) => p.tiles != c.tiles,
                  builder: (context, state) {
                    return Stack(
                      children: [
                        for (int index = 0; index < state.tiles.length; index++)
                          if (state.tiles[index] != 0)
                            _AnimatedTile(
                              key: ValueKey(state.tiles[index]),
                              index: index,
                              gridSize: gridSize,
                              spacing: spacing,
                              tileSize: tileSize,
                              onTap: () => context
                                  .read<SlideMastermindCubit>()
                                  .onTileTap(index),
                              label: state.tiles[index].toString(),
                            ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedTile extends StatelessWidget {
  final int index;
  final int gridSize;
  final double spacing;
  final double tileSize;
  final VoidCallback onTap;
  final String label;

  const _AnimatedTile({
    super.key,
    required this.index,
    required this.gridSize,
    required this.spacing,
    required this.tileSize,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final col = index % gridSize;
    final row = index ~/ gridSize;
    final left = col * (tileSize + spacing);
    final top = row * (tileSize + spacing);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      left: left,
      top: top,
      width: tileSize,
      height: tileSize,
      child: SizedBox(
        width: tileSize,
        height: tileSize,
        child: PuzzleTile(label: label, isEmpty: false, onTap: onTap),
      ),
    );
  }
}
