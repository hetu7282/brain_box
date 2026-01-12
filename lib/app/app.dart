import 'package:brain_box/app/app_bloc_provider.dart';
import 'package:brain_box/main.dart';
import 'package:brain_box/src/config/constants/app_string.dart';
import 'package:brain_box/src/config/router/router.dart';
import 'package:brain_box/src/core/bloc/audio/audio_cubit.dart';
import 'package:brain_box/src/core/bloc/audio/audio_state.dart';
import 'package:brain_box/src/core/bloc/haptics/haptics_cubit.dart';
import 'package:brain_box/src/core/bloc/haptics/haptics_state.dart';
import 'package:brain_box/src/core/database/storage.dart';
import 'package:brain_box/src/core/services/audio_service.dart';
import 'package:brain_box/src/core/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sizer/sizer.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final ThemeService _themeService = ThemeService();
  bool _musicInitialized = false;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();

    // Add observer for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    // Initialize NotificationService after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _initNotificationService();
      // Ensure audio is initialized and music starts if enabled
      _initializeAudio();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!mounted) return;

    if (state == AppLifecycleState.paused) {
      AudioService.instance.stopBackgroundMusic();
    } else if (state == AppLifecycleState.resumed) {
      final storage = Storage.instance;
      final musicEnabled = storage.getMusicEnabled();
      if (musicEnabled) {
        AudioService.instance.playBackgroundMusic();
      }
    }
  }

  Future<void> _initializeAudio() async {
    if (_musicInitialized) return;

    // Wait a bit for AudioCubit to complete initialization
    await Future.delayed(const Duration(milliseconds: 100));

    final audioService = AudioService.instance;
    final storage = Storage.instance;

    // Check if music is enabled in storage
    final musicEnabled = storage.getMusicEnabled();

    if (musicEnabled && mounted) {
      // Ensure music starts if it's not already playing
      await audioService.playBackgroundMusic();
      _musicInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return AppBlocProvider(
          child: BlocListener<AudioCubit, AudioState>(
            listenWhen: (previous, current) {
              // Only trigger on initial state change or when music becomes enabled
              return !_musicInitialized && current.isMusicEnabled;
            },
            listener: (context, audioState) {
              // Ensure music starts when AudioCubit is initialized and music is enabled
              if (audioState.isMusicEnabled && !_musicInitialized) {
                AudioService.instance.playBackgroundMusic();
                _musicInitialized = true;
              }
            },
            child: ListenableBuilder(
              listenable: _themeService,
              builder: (context, _) {
                final currentTheme = _themeService.currentTheme;
                final isDefultMode = currentTheme == AppThemeMode.defult;
                final isCosmicMode = currentTheme == AppThemeMode.cosmic;

                // Set overlay style based on theme: light theme uses darkSystemOverlayStyle, otherwise use lightSystemOverlayStyle
                final overlayStyle = currentTheme == AppThemeMode.light
                    ? lightSystemOverlayStyle
                    : darkSystemOverlayStyle;

                // For cosmic mode, use cosmic theme for both light and dark
                // For system mode, use standard light/dark themes
                final lightTheme = isCosmicMode
                    ? _themeService.getCosmicTheme()
                    : _themeService.getLightTheme();
                final darkTheme = isCosmicMode
                    ? _themeService.getCosmicTheme()
                    : _themeService.getDarkTheme();

                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: overlayStyle,
                  child: MaterialApp.router(
                    routerConfig: AppRouter.router,
                    title: AppString.appName,
                    localizationsDelegates: const [
                      // S.delegate,
                      // GlobalMaterialLocalizations.delegate,
                      // GlobalWidgetsLocalizations.delegate,
                      // GlobalCupertinoLocalizations.delegate,
                    ],
                    // locale: languageService.currentLocale,
                    // supportedLocales: languageService.supportedLocales,
                    debugShowCheckedModeBanner: false,
                    scrollBehavior: ScrollConfiguration.of(context).copyWith(
                      overscroll: false,
                      physics: const ClampingScrollPhysics(),
                    ),
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    themeMode: isDefultMode
                        ? ThemeMode.system
                        : currentTheme == AppThemeMode.dark || isCosmicMode
                        ? ThemeMode.dark
                        : ThemeMode.light,
                    builder: (context, child) {
                      final Widget mediaQueryWrapped = MediaQuery(
                        data: MediaQuery.of(
                          context,
                        ).copyWith(textScaler: const TextScaler.linear(1.0)),
                        child: child!,
                      );

                      return BlocBuilder<HapticsCubit, HapticsState>(
                        builder: (context, state) {
                          if (!state.enabled) return mediaQueryWrapped;
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              // HapticsService.instance.tap();
                            },
                            child: mediaQueryWrapped,
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
