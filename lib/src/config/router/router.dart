import 'package:brain_box/src/features/home/presentation/screen/home_screen.dart';
import 'package:brain_box/src/features/jurassic_journey/presentation/screen/jurassic_journey_screen.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/bloc/kings_gambit_state.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/screen/kings_gambit_puzzle_screen.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/screen/kings_gambit_screen.dart';
import 'package:brain_box/src/features/kings_gambit/presentation/screen/kings_gambit_setting_screen.dart';
import 'package:brain_box/src/features/onboarding/presentation/screen/onboarding_screen.dart';
import 'package:brain_box/src/features/onboarding/presentation/screen/splash_screen.dart';
import 'package:brain_box/src/features/piece_by_piece/domain/entity/piece_by_piece_entity.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/bloc/piece_by_piece_cubit.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/screen/choose_your_puzzle_screen.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/screen/piece_by_piece_screen.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/screen/puzzle_completed_screen.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/screen/select_difficulty_screen.dart';
import 'package:brain_box/src/features/setting/presentation/screen/about_game_screen.dart';
import 'package:brain_box/src/features/setting/presentation/screen/privacy_policy_screen.dart';
import 'package:brain_box/src/features/setting/presentation/screen/setting_screen.dart';
import 'package:brain_box/src/features/setting/presentation/screen/terms_conditions_screen.dart';
import 'package:brain_box/src/features/slide_mastermind/presentation/screen/slide_mastermind_screen.dart';
import 'package:brain_box/src/features/tic_tac_twist/presentation/screen/tic_tac_twist_screen.dart';
import 'package:brain_box/src/features/quick_type_quest/presentation/screen/quick_type_quest_screen.dart';
import 'package:brain_box/src/features/quick_type_quest/presentation/screen/quick_type_quest_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'routes.dart';

class AppRouterNavigationKey {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: AppRouterNavigationKey.navigatorKey,
    debugLogDiagnostics: true,
    initialLocation: Routes.splash.path,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.splash.path,
        name: Routes.splash.name,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(state: state, child: const SplashScreen()),
      ),
      GoRoute(
        path: Routes.onboarding.path,
        name: Routes.onboarding.name,
        pageBuilder: (context, state) => _buildPageWithTransition(
          state: state,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: Routes.homeScreen.path,
        name: Routes.homeScreen.name,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(state: state, child: const HomeScreen()),
      ),
      GoRoute(
        path: Routes.settings.path,
        name: Routes.settings.name,
        pageBuilder: (context, state) => _buildPageWithTransition(
          state: state,
          child: const SettingScreen(),
        ),
      ),
      GoRoute(
        path: Routes.aboutGame.path,
        name: Routes.aboutGame.name,
        pageBuilder: (context, state) => _buildPageWithTransition(
          state: state,
          child: const AboutGameScreen(),
        ),
      ),
      GoRoute(
        path: Routes.termsConditions.path,
        name: Routes.termsConditions.name,
        pageBuilder: (context, state) => _buildPageWithTransition(
          state: state,
          child: const TermsConditionsScreen(),
        ),
      ),
      GoRoute(
        path: Routes.privacyPolicy.path,
        name: Routes.privacyPolicy.name,
        pageBuilder: (context, state) => _buildPageWithTransition(
          state: state,
          child: const PrivacyPolicyScreen(),
        ),
      ),
      GoRoute(
        path: Routes.ticTacTwist.path,
        name: Routes.ticTacTwist.name,
        pageBuilder: (context, state) => _buildPageWithTransition(
          state: state,
          child: const TicTacTwistScreen(),
        ),
      ),
      GoRoute(
        path: Routes.slideMastermind.path,
        name: Routes.slideMastermind.name,
        pageBuilder: (context, state) => _buildPageWithTransition(
          state: state,
          child: const SlideMastermindScreen(),
        ),
      ),
      GoRoute(
        path: Routes.jurassicJourney.path,
        name: Routes.jurassicJourney.name,
        pageBuilder: (context, state) => _buildPageWithTransition(
          state: state,
          child: const JurassicJourneyScreen(),
        ),
      ),
      GoRoute(
        path: Routes.pieceByPiece.path,
        name: Routes.pieceByPiece.name,
        pageBuilder: (context, state) {
          final params = state.extra as PuzzleGameParams?;
          return _buildPageWithTransition(
            state: state,
            child: BlocProvider(
              create: (context) => PieceByPieceCubit(),
              child: PieceByPieceScreen(params: params),
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.chooseYourPuzzle.path,
        name: Routes.chooseYourPuzzle.name,
        pageBuilder: (context, state) => _buildPageWithTransition(
          state: state,
          child: const ChooseYourPuzzleScreen(),
        ),
      ),
      GoRoute(
        path: Routes.selectDifficulty.path,
        name: Routes.selectDifficulty.name,
        pageBuilder: (context, state) {
          final selectedItem = state.extra as PieceByPieceEntity?;
          return _buildPageWithTransition(
            state: state,
            child: SelectDifficultyScreen(selectedItem: selectedItem),
          );
        },
      ),
      GoRoute(
        path: Routes.puzzleCompleted.path,
        name: Routes.puzzleCompleted.name,
        pageBuilder: (context, state) {
          // Handle both old format (String) and new format (Map)
          String? imagePath;
          dynamic statistics;

          final extra = state.extra;
          if (extra != null) {
            try {
              // Try to handle as Map first
              if (extra is Map) {
                final data = extra;
                imagePath = data['imagePath'] as String?;
                statistics = data['statistics'];
              } else if (extra is String) {
                // Old format - just image path
                imagePath = extra;
              }
            } catch (e) {
              // Fallback: try to use as String
              if (extra is String) {
                imagePath = extra;
              }
            }
          }

          return _buildPageWithTransition(
            state: state,
            child: PuzzleCompletedScreen(
              imagePath: imagePath,
              statistics: statistics,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.kingsGambit.path,
        name: Routes.kingsGambit.name,
        pageBuilder: (context, state) => _buildPageWithTransition(
          state: state,
          child: const KingsGambitScreen(),
        ),
      ),
      GoRoute(
        path: Routes.kingsGambitSetting.path,
        name: Routes.kingsGambitSetting.name,
        pageBuilder: (context, state) => _buildPageWithTransition(
          state: state,
          child: const KingsGambitSettingScreen(),
        ),
      ),
      GoRoute(
        path: Routes.kingsGambitPuzzle.path,
        name: Routes.kingsGambitPuzzle.name,
        pageBuilder: (context, state) {
          GameMode? gameMode;
          final extra = state.extra;
          if (extra != null && extra is Map) {
            gameMode = extra['gameMode'] as GameMode?;
          }
          return _buildPageWithTransition(
            state: state,
            child: KingsGambitPuzzleScreen(gameMode: gameMode),
          );
        },
      ),
      GoRoute(
        path: Routes.quickTypeQuest.path,
        name: Routes.quickTypeQuest.name,
        pageBuilder: (context, state) => _buildPageWithTransition(
          state: state,
          child: const QuickTypeQuestScreen(),
        ),
      ),
      GoRoute(
        path: Routes.quickTypeQuestResult.path,
        name: Routes.quickTypeQuestResult.name,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return _buildPageWithTransition(
            state: state,
            child: QuickTypeQuestResultScreen(
              wpm: extra?['wpm'] as int? ?? 0,
              accuracy: extra?['accuracy'] as int? ?? 0,
              totalCharacters: extra?['totalCharacters'] as int? ?? 0,
              correctCharacters: extra?['correctCharacters'] as int? ?? 0,
              timeElapsed: extra?['timeElapsed'] as int? ?? 0,
              difficulty: extra?['difficulty'] as String? ?? 'Easy',
            ),
          );
        },
      ),
      // GoRoute(
      //   path: Routes.login.path,
      //   name: Routes.login.name,
      //   builder: (context, state) => const LoginScreen(),
      // ),

      // GoRoute(
      //   path: Routes.register.path,
      //   name: Routes.register.name,
      //   builder: (context, state) => const RegisterScreen(),
      // ),
      // GoRoute(
      //   path: Routes.forgotPassword.path,
      //   name: Routes.forgotPassword.name,
      //   builder: (context, state) => const ForgotPasswordScreen(),
      // ),
      // GoRoute(
      //   path: Routes.verifyOtp.path,
      //   name: Routes.verifyOtp.name,
      //   builder: (context, state) {
      //     String otpStatusString =
      //         state.uri.queryParameters['otpStatus'] ?? OtpStatus.register.name;
      //     OtpStatus otpStatus = OtpStatus.values.firstWhere(
      //       (e) => e.name == otpStatusString,
      //       orElse: () => OtpStatus.register,
      //     );

      //     return OtpVerifyScreen(
      //       email: state.uri.queryParameters['email'] ?? '',
      //       phno: state.uri.queryParameters['phno'] ?? '',
      //       otpStatus: otpStatus,
      //     );
      //   },
      // ),

      // GoRoute(
      //   path: Routes.newPassword.path,
      //   name: Routes.newPassword.name,
      //   builder: (context, state) =>
      //       NewPasswordScreen(email: state.uri.queryParameters['email'] ?? ''),
      // ),
    ],
    // errorBuilder: (context, state) => const NoPageFoundScreen(),
    redirect: (context, state) async {
      return null;
    },
  );
}

CustomTransitionPage<dynamic> _buildPageWithTransition({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<dynamic>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      final fade = FadeTransition(opacity: curved, child: child);
      final slide = SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.06, 0),
          end: Offset.zero,
        ).animate(curved),
        child: fade,
      );
      return slide;
    },
  );
}
