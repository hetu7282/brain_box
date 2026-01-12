import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/config/router/router.dart';
import 'package:brain_box/src/core/services/snackbar_service.dart';
import 'package:brain_box/src/core/widgets/custom_appbar.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_icon.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/bloc/kings_gambit_cubit.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/bloc/kings_gambit_state.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/widget/game_mode_card.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/widget/recent_games_widget.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/widget/statistics_widget.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class KingsGambitScreen extends StatelessWidget {
  const KingsGambitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return BlocProvider(
      create: (context) => KingsGambitCubit(),
      child: CustomBgWidget(
        appBar: CustomAppBar(
          title: 'Kings Gambit',
          actionWidget: GestureDetector(
            onTap: () {
              context.pushNamed(Routes.kingsGambitSetting.name);
            },
            child: CustomIcon(
              icon: Assets.assetsIconsSettings,
              size: 40.px,
              color: themeState.textOnboardingColor!,
              backgroundColor: themeState.appBarIconBackgroundColor!,
            ),
          ),
        ),
        body: BlocBuilder<KingsGambitCubit, KingsGambitState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.px),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Game Mode Cards
                          Row(
                            children: [
                              GameModeCard(
                                title: 'vs AI',
                                icon: Assets.assetsIconsKingGambitAi,
                                isSelected:
                                    state.selectedGameMode == GameMode.vsAI,
                                onTap: () {
                                  context
                                      .read<KingsGambitCubit>()
                                      .selectGameMode(
                                        state.selectedGameMode == GameMode.vsAI
                                            ? null
                                            : GameMode.vsAI,
                                      );
                                },
                              ),
                              GapW(15.px),
                              GameModeCard(
                                title: 'Friend',
                                icon: Assets.assetsIconsKingGambitFriend,
                                isSelected:
                                    state.selectedGameMode == GameMode.friend,
                                onTap: () {
                                  context
                                      .read<KingsGambitCubit>()
                                      .selectGameMode(
                                        state.selectedGameMode ==
                                                GameMode.friend
                                            ? null
                                            : GameMode.friend,
                                      );
                                },
                              ),
                            ],
                          ),
                          GapH(25.px),
                          // Statistics Widget
                          StatisticsWidget(
                            wins: state.wins,
                            losses: state.losses,
                            draws: state.draws,
                          ),
                          GapH(25.px),
                          // Recent Games Widget
                          RecentGamesWidget(games: state.recentGames),
                        ],
                      ),
                    ),
                  ),
                  GapH(25.px),
                  // Start Button
                  CustomButton(
                    text: 'Start',
                    onTap: () {
                      if (state.selectedGameMode != null) {
                        context.pushNamed(
                          Routes.kingsGambitPuzzle.name,
                          extra: {'gameMode': state.selectedGameMode},
                        );
                      } else {
                        SnackBarService.showInfoSnackBar(
                          context,
                          'Please select a game mode',
                        );
                      }
                    },
                  ),
                  GapBottom(extraHight: 20.px),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
