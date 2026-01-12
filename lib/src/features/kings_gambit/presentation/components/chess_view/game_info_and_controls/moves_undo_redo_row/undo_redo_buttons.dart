import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/animations/smooth_scale_animation.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/model/app_model.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UndoRedoButtons extends StatelessWidget {
  final AppModel appModel;

  const UndoRedoButtons(this.appModel, {super.key});

  bool _undoEnabled(AppModel model) {
    if (model.playingWithAI) {
      return (model.game?.board.moveStack.length ?? 0) > 1 && !model.isAIsTurn;
    } else {
      return model.game?.board.moveStack.isNotEmpty ?? false;
    }
  }

  bool _redoEnabled(AppModel model) {
    if (model.playingWithAI) {
      return (model.game?.board.redoStack.length ?? 0) > 1 && !model.isAIsTurn;
    } else {
      return model.game?.board.redoStack.isNotEmpty ?? false;
    }
  }

  void _undo(AppModel model) {
    if (model.playingWithAI) {
      model.game?.undoTwoMoves();
    } else {
      model.game?.undoMove();
    }
  }

  void _redo(AppModel model) {
    if (model.playingWithAI) {
      model.game?.redoTwoMoves();
    } else {
      model.game?.redoMove();
    }
  }

  Widget _buildButton({
    required BuildContext context,
    required ThemeState themeState,
    required bool enabled,
    required VoidCallback? onTap,
    required String icon,
    required String label,
  }) {
    return Expanded(
      child: SmoothScaleAnimation(
        onTap: enabled ? onTap : null,
        child: CustomIconTextButton(text: label, icon: icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, model, child) {
        final themeState = context.watch<ThemeCubit>().state;
        final undoEnabled = _undoEnabled(model);
        final redoEnabled = _redoEnabled(model);

        return Row(
          spacing: 10.px,
          children: [
            _buildButton(
              context: context,
              themeState: themeState,
              enabled: undoEnabled,
              onTap: () => _undo(model),
              icon: Assets.assetsIconsPlayAgain,
              label: 'Undo',
            ),
            _buildButton(
              context: context,
              themeState: themeState,
              enabled: redoEnabled,
              onTap: () => _redo(model),
              icon: Assets.assetsIconsPlayAgain,
              label: 'Redo',
            ),
          ],
        );
      },
    );
  }
}
