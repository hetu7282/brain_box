import 'package:brain_box/src/core/bloc/audio/audio_cubit.dart';
import 'package:brain_box/src/core/bloc/connectivity/connectivity_cubit.dart';
import 'package:brain_box/src/core/bloc/haptics/haptics_cubit.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocProvider extends StatelessWidget {
  final Widget child;

  const AppBlocProvider({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    // Define your providers list
    final List<BlocProvider> providers = [
      BlocProvider<ConnectivityCubit>(create: (context) => ConnectivityCubit()),
      BlocProvider<AudioCubit>(create: (context) => AudioCubit()),
      BlocProvider<HapticsCubit>(create: (context) => HapticsCubit()),
      BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
    ];

    return MultiBlocProvider(providers: providers, child: child);
  }
}
