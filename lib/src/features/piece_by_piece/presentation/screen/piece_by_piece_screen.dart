import 'dart:async';

import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/router/router.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_appbar.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/piece_by_piece/domain/entity/puzzle_statistics.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/bloc/piece_by_piece_cubit.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/jigsaw_puzzle_widget.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/widget/jigsaw_widget.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class PuzzleGameParams {
  final String imagePath;
  final int difficulty;

  PuzzleGameParams({required this.imagePath, required this.difficulty});
}

class PieceByPieceScreen extends StatefulWidget {
  final PuzzleGameParams? params;

  const PieceByPieceScreen({super.key, this.params});

  @override
  State<PieceByPieceScreen> createState() => _PieceByPieceScreenState();
}

class _PieceByPieceScreenState extends State<PieceByPieceScreen> {
  final puzzleKey = GlobalKey<JigsawWidgetState>();
  bool _hasGenerated = false;
  bool _generationScheduled = false;
  Timer? _timer;
  late final ValueNotifier<_PuzzleUiState> _uiState;

  @override
  void initState() {
    super.initState();
    _uiState = ValueNotifier<_PuzzleUiState>(_PuzzleUiState.initial());
    // Initialize puzzle when screen loads
    if (widget.params != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          final cubit = context.read<PieceByPieceCubit>();
          cubit.initializePuzzle(
            widget.params!.imagePath,
            widget.params!.difficulty,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _uiState.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_uiState.value.isGameStarted) return;
    _uiState.value = _uiState.value.copyWith(isGameStarted: true);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        final current = _uiState.value;
        _uiState.value = current.copyWith(
          elapsedSeconds: current.elapsedSeconds + 1,
        );
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _scheduleGenerate() {
    if (_hasGenerated || _generationScheduled) return;

    _generationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && puzzleKey.currentState != null && !_hasGenerated) {
        _hasGenerated = true;
        puzzleKey.currentState!.generate();
      }
      _generationScheduled = false;
    });
  }

  String _getDifficultyName(int difficulty) {
    switch (difficulty) {
      case 2:
        return 'Easy';
      case 5:
        return 'Medium';
      case 10:
        return 'Hard';
      default:
        return 'Medium';
    }
  }

  void _restartPuzzle(BuildContext context, PieceByPieceState state) {
    final cubit = context.read<PieceByPieceCubit>();
    cubit.resetGrid();
    _hasGenerated = false;
    _generationScheduled = false;
    _uiState.value = _PuzzleUiState.initial();
    _stopTimer(); // Stop and reset timer
    puzzleKey.currentState?.reset();
    if (state.puzzleImagePath != null && state.difficulty != null) {
      _scheduleGenerate();
    }
  }

  void _onBlockSuccess() {
    // Count each successful piece placement as a move
    final current = _uiState.value;
    _uiState.value = current.copyWith(moves: current.moves + 1);
  }

  void _onProgressUpdate(int placedCount, int totalCount) {
    // Start timer on first piece placement
    if (placedCount > 0 && !_uiState.value.isGameStarted) {
      _startTimer();
    }

    _uiState.value = _uiState.value.copyWith(
      placedPieces: placedCount,
      totalPieces: totalCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PieceByPieceCubit, PieceByPieceState>(
      listener: (context, state) {
        // Schedule generation when state is ready
        if (state.puzzleImagePath != null &&
            state.difficulty != null &&
            !_hasGenerated) {
          _scheduleGenerate();
        }
      },
      child: CustomBgWidget(
        appBar: CustomAppBar(title: 'Piece by Piece'),
        body: BlocBuilder<PieceByPieceCubit, PieceByPieceState>(
          builder: (context, state) {
            if (state.puzzleImagePath == null || state.difficulty == null) {
              return Center(
                child: CustomText(
                  text: 'No puzzle loaded',
                  color: AppColor.white,
                ),
              );
            }

            // Also schedule generation after widget builds (in case listener fires before build)
            if (!_hasGenerated && !_generationScheduled) {
              _scheduleGenerate();
            }

            final difficulty = state.difficulty!;
            return ValueListenableBuilder<_PuzzleUiState>(
              valueListenable: _uiState,
              builder: (context, uiState, _) {
                final totalPieces = uiState.totalPieces > 0
                    ? uiState.totalPieces
                    : difficulty * difficulty;
                final placedPieces = uiState.placedPieces;
                final difficultyName = _getDifficultyName(difficulty);

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // Top Section: Difficulty, Progress, Restart
                      _buildTopSection(
                        context,
                        difficultyName,
                        difficulty,
                        placedPieces,
                        totalPieces,
                        uiState,
                        state,
                      ),
                      GapH(16.px),
                      _buildBottomSection(context, uiState, state),
                      GapH(16.px),

                      JigsawPuzzle(
                        gridSize: difficulty,
                        puzzleKey: puzzleKey,
                        jigImage: state.puzzleImagePath!,
                        image: AssetImage(state.puzzleImagePath!),
                        snapSensitivity: .5,
                        onBlockSuccess: _onBlockSuccess,
                        onFinished: () {
                          _stopTimer();
                          final statistics = PuzzleStatistics(
                            elapsedSeconds: uiState.elapsedSeconds,
                            moves: uiState.moves,
                            difficulty: state.difficulty!,
                          );
                          context.pushReplacementNamed(
                            Routes.puzzleCompleted.name,
                            extra: <String, dynamic>{
                              'imagePath': state.puzzleImagePath,
                              'statistics': statistics,
                            },
                          );
                        },
                        onProgressUpdate: _onProgressUpdate,
                        showBackgroundImage: uiState.isHintSelected,
                      ),

                      GapBottom(extraHight: 10.px),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopSection(
    BuildContext context,
    String difficultyName,
    int difficulty,
    int placedPieces,
    int totalPieces,
    _PuzzleUiState uiState,
    PieceByPieceState state,
  ) {
    final themeState = context.watch<ThemeCubit>().state;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.px),
      padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 16.px),
      decoration: BoxDecoration(
        color: themeState.settingCustomContainerColor!, // Dark blue background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeState.settingCustomContainerBorderColor!.withOpacityValue(
            0.5,
          ), // Light blue border
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Difficulty
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Difficulty',
                  fontSize: 12.px,
                  color: themeState.splashLogoColor!, // Light blue
                  fontWeight: FontWeight.w400,
                ),
                GapH(4.px),
                CustomText(
                  text: '$difficultyName (${difficulty}x$difficulty)',
                  fontSize: 16.px,
                  color: themeState.appBarTitleColor!,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          // Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                CustomText(
                  text: 'Progress',
                  fontSize: 12.px,
                  color: themeState.splashLogoColor!, // Light blue
                  fontWeight: FontWeight.w400,
                ),
                GapH(4.px),
                CustomText(
                  text: '$placedPieces/$totalPieces pieces',
                  fontSize: 16.px,
                  color: themeState.appBarTitleColor!,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(
    BuildContext context,
    _PuzzleUiState uiState,
    PieceByPieceState state,
  ) {
    final themeState = context.watch<ThemeCubit>().state;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      child: Row(
        spacing: 12.px,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Home Button
          Expanded(
            child: GestureDetector(
              onTap: () => context.goNamed(Routes.homeScreen.name),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.px),
                decoration: BoxDecoration(
                  color: themeState
                      .settingCustomContainerColor!, // Dark blue background
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: themeState.settingCustomContainerBorderColor!
                        .withOpacityValue(0.5), // Light blue border
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.house_fill,
                      color: themeState.splashLogoColor!,
                      size: 20.px,
                    ),
                    GapW(8.px),
                    CustomText(
                      text: 'Home',
                      fontSize: 14.px,
                      color: themeState.appBarTitleColor!,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () => _restartPuzzle(context, state),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.px),
                decoration: BoxDecoration(
                  color: themeState
                      .settingCustomContainerColor!, // Dark blue background
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: themeState.settingCustomContainerBorderColor!
                        .withOpacityValue(0.5), // Light blue border
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.arrow_clockwise,
                      color: themeState.splashLogoColor!,
                      size: 20.px,
                    ),
                    GapW(8.px),
                    CustomText(
                      text: 'Restart',
                      fontSize: 14.px,
                      color: themeState.splashLogoColor!,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () {
                _uiState.value = uiState.copyWith(
                  isHintSelected: !uiState.isHintSelected,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.px),
                decoration: BoxDecoration(
                  color: uiState.isHintSelected
                      ? themeState.appBarIconBackgroundColor!
                      : themeState
                            .settingCustomContainerColor!, // Light blue when unselected
                  borderRadius: BorderRadius.circular(12),
                  border: !uiState.isHintSelected
                      ? Border.all(
                          color: themeState.settingCustomContainerBorderColor!
                              .withOpacityValue(0.5),
                          width: 1,
                        )
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20.px,
                      height: 20.px,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: uiState.isHintSelected
                              ? AppColor.white
                              : themeState.splashLogoColor!,
                          width: 2.px,
                        ),
                        color: uiState.isHintSelected
                            ? themeState.settingCustomContainerBorderColor!
                                  .withOpacityValue(0.2)
                            : null,
                      ),
                      child: Center(
                        child: CustomText(
                          text: '?',
                          fontSize: 14.px,
                          color: uiState.isHintSelected
                              ? AppColor.white
                              : themeState.splashLogoColor!,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GapW(8.px),
                    CustomText(
                      text: 'Hint',
                      fontSize: 14.px,
                      color: uiState.isHintSelected
                          ? AppColor.white
                          : themeState.splashLogoColor!,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PuzzleUiState {
  final bool isHintSelected;
  final int placedPieces;
  final int totalPieces;
  final int elapsedSeconds;
  final int moves;
  final bool isGameStarted;

  const _PuzzleUiState({
    required this.isHintSelected,
    required this.placedPieces,
    required this.totalPieces,
    required this.elapsedSeconds,
    required this.moves,
    required this.isGameStarted,
  });

  factory _PuzzleUiState.initial() => const _PuzzleUiState(
    isHintSelected: false,
    placedPieces: 0,
    totalPieces: 0,
    elapsedSeconds: 0,
    moves: 0,
    isGameStarted: false,
  );

  _PuzzleUiState copyWith({
    bool? isHintSelected,
    int? placedPieces,
    int? totalPieces,
    int? elapsedSeconds,
    int? moves,
    bool? isGameStarted,
  }) {
    return _PuzzleUiState(
      isHintSelected: isHintSelected ?? this.isHintSelected,
      placedPieces: placedPieces ?? this.placedPieces,
      totalPieces: totalPieces ?? this.totalPieces,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      moves: moves ?? this.moves,
      isGameStarted: isGameStarted ?? this.isGameStarted,
    );
  }
}
