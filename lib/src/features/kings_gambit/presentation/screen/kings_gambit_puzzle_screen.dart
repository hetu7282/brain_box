import 'package:brain_box/src/core/database/storage.dart';
import 'package:brain_box/src/core/widgets/custom_appbar.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/bloc/kings_gambit_puzzle_cubit.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/bloc/kings_gambit_state.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/chess_view/chess_board_widget.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/chess_view/game_info_and_controls/game_status.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/chess_view/game_info_and_controls/losted_player.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/chess_view/game_info_and_controls/moves_undo_redo_row/undo_redo_buttons.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/components/main_menu_view/game_options/side_picker.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/logic/chess_game.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class KingsGambitPuzzleScreen extends StatefulWidget {
  final GameMode? gameMode;

  const KingsGambitPuzzleScreen({super.key, this.gameMode});

  @override
  State<KingsGambitPuzzleScreen> createState() =>
      _KingsGambitPuzzleScreenState();
}

class _KingsGambitPuzzleScreenState extends State<KingsGambitPuzzleScreen>
    with WidgetsBindingObserver {
  final Storage _storage = Storage.instance;
  late final KingsGambitPuzzleCubit _puzzleCubit;
  AppModel? _appModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _puzzleCubit = KingsGambitPuzzleCubit();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final puzzleState = _puzzleCubit.state;
    if (!puzzleState.isInitialized) {
      _puzzleCubit.markInitialized();
      _initializeGame();
    } else {
      // Reload settings when navigating back to this screen
      // This ensures settings changes are applied when returning from settings screen
      _reloadSettingsIfChanged();
    }
  }

  @override
  void dispose() {
    _appModel?.game?.cancelAIMove();
    _puzzleCubit.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      _puzzleCubit.reloadSettings();
      final puzzleState = _puzzleCubit.state;
      _appModel?.setShowHints(puzzleState.showHints);
      _appModel?.setAllowUndoRedo(puzzleState.allowUndoRedo);
    }
  }

  void _reloadSettingsIfChanged() {
    if (!mounted || _appModel == null) return;

    final currentState = _puzzleCubit.state;
    final newAllowUndoRedo = _storage.getKingsGambitAllowUndoRedo();
    final newShowHints = _storage.getKingsGambitShowHints();

    // Check if settings have changed
    if (newAllowUndoRedo != currentState.allowUndoRedo ||
        newShowHints != currentState.showHints) {
      _puzzleCubit.reloadSettings();
      final updatedState = _puzzleCubit.state;
      // Apply changes to the game model
      _appModel?.setShowHints(updatedState.showHints);
      _appModel?.setAllowUndoRedo(updatedState.allowUndoRedo);
    }
  }

  void _initializeGame() {
    if (!mounted) return;

    _appModel = AppModel();

    // Set game mode based on selection (default to vsAI if not provided)
    final gameMode = widget.gameMode ?? GameMode.vsAI;
    if (gameMode == GameMode.friend) {
      // Friend mode: 2 players, no AI
      _appModel!.playingWithAI = false;
      _appModel!.playerCount = 2;
      _appModel!.turn = Player.player1; // White always starts in chess
      _appModel!.isAIsTurn = false;
    } else {
      // vsAI mode: 1 player with AI
      _appModel!.playingWithAI = true;
      _appModel!.playerCount = 1;

      // Load saved player side from settings
      final savedPlayerSideString = _storage.getKingsGambitPlayerSide();
      Player savedPlayerSide = Player.player1;
      if (savedPlayerSideString == 'player2') {
        savedPlayerSide = Player.player2;
      } else if (savedPlayerSideString == 'random') {
        // Random: randomly choose between player1 and player2
        savedPlayerSide = DateTime.now().millisecond % 2 == 0
            ? Player.player1
            : Player.player2;
      }

      _appModel!.playerSide = savedPlayerSide;
      _appModel!.aiTurn = savedPlayerSide == Player.player1
          ? Player.player2
          : Player.player1;
      _appModel!.aiDifficulty = _storage
          .getKingsGambitAIDifficulty(); // Load from settings

      // If player selected Black, AI (White) goes first
      // If player selected White, Player goes first
      if (savedPlayerSide == Player.player2) {
        // Player is Black, AI (White/Player1) goes first
        _appModel!.turn = Player.player1;
        _appModel!.isAIsTurn = true;
      } else {
        // Player is White, Player goes first
        _appModel!.turn = Player.player1;
        _appModel!.isAIsTurn = false;
      }
    }
    final puzzleState = _puzzleCubit.state;
    _appModel!.showHints = puzzleState.showHints;
    _appModel!.allowUndoRedo = puzzleState.allowUndoRedo;
    _appModel!.pieceTheme = _storage
        .getKingsGambitPieceTheme(); // Load from settings

    // Load saved app theme from settings
    final savedAppThemeName = _storage.getKingsGambitAppTheme();
    final savedTheme = AppModel.themeList.firstWhere(
      (theme) => theme.name == savedAppThemeName,
      orElse: () => AppModel.themeList.firstWhere(
        (theme) => theme.name == 'Desert',
        orElse: () => AppModel.themeList[0],
      ),
    );
    _appModel!.setThemeObject(savedTheme);

    // Initialize the chess game
    final game = ChessGame(_appModel!, context);
    _appModel!.setGame(game);
  }

  @override
  Widget build(BuildContext context) {
    // Reload settings on every build to ensure buttons show/hide correctly
    // This ensures settings changes are immediately reflected
    final puzzleState = _puzzleCubit.state;
    if (puzzleState.isInitialized && _appModel != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _reloadSettingsIfChanged();
        }
      });
    }

    if (_appModel == null) {
      return BlocProvider.value(
        value: _puzzleCubit,
        child: CustomBgWidget(
        appBar: CustomAppBar(title: 'Kings Gambit'),
        body: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return BlocProvider.value(
      value: _puzzleCubit,
      child: BlocBuilder<KingsGambitPuzzleCubit, KingsGambitPuzzleState>(
        builder: (context, state) {
    return ChangeNotifierProvider.value(
      value: _appModel!,
      child: CustomBgWidget(
        appBar: CustomAppBar(title: 'Kings Gambit'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.px),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Captured pieces for player 2 (top)
                LostedPlayer(player: Player.player2),

                // Game Status
                GapH(10.px),
                // Chess Board
                Center(child: ChessBoardWidget(_appModel!)),
                GapH(10.px),
                const GameStatus(),

                // Captured pieces for player 1 (bottom)
                LostedPlayer(player: Player.player1),
                // Undo/Redo buttons - only show if setting is enabled
                      if (state.allowUndoRedo) ...[
                  GapH(10.px),
                  UndoRedoButtons(_appModel!),
                ],
                GapBottom(extraHight: 10.px),
              ],
            ),
          ),
        ),
            ),
          );
        },
      ),
    );
  }
}
