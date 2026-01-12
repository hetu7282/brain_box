import 'package:brain_box/src/core/bloc/audio/audio_state.dart';
import 'package:brain_box/src/core/database/storage.dart';
import 'package:brain_box/src/core/services/audio_service.dart';
import 'package:brain_box/src/core/utils/log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing audio settings and playback
class AudioCubit extends Cubit<AudioState> {
  final AudioService _audioService = AudioService.instance;
  final Storage _storage = Storage.instance;

  AudioCubit() : super(AudioState.initial()) {
    _initialize();
  }

  /// Initialize audio with saved settings
  Future<void> _initialize() async {
    try {
      // Load saved settings from storage
      final musicEnabled = _storage.getMusicEnabled();
      final soundEnabled = _storage.getSoundEnabled();
      final stopMusicOnBackground = _storage.getStopMusicOnBackground();

      // Emit initial state
      emit(state.copyWith(isMusicEnabled: musicEnabled));

      // Set stop music on background setting BEFORE initializing
      // This ensures the player mode is set correctly during initialization
      await _audioService.setStopMusicOnBackground(stopMusicOnBackground);

      // Initialize audio service FIRST (music should start if enabled)
      await _audioService.initialize(musicEnabled: musicEnabled);

      // Set sound enabled state AFTER music initialization
      // This ensures sound setting doesn't interfere with music playback
      await _audioService.setSoundEnabled(soundEnabled);

      Log.d(
        'Audio initialized: music=$musicEnabled, sound=$soundEnabled, stopOnBackground=$stopMusicOnBackground',
      );
    } catch (e) {
      Log.e('Error initializing audio: $e');
    }
  }

  /// Toggle music enabled state
  Future<void> toggleMusic(bool enabled) async {
    try {
      // Update state
      emit(state.copyWith(isMusicEnabled: enabled));

      // Save to storage only if enabled (as per requirement)
      if (enabled) {
        await _storage.setMusicEnabled(true);
      } else {
        // Don't store when disabled - remove from storage
        await _storage.setMusicEnabled(false);
      }

      // Update audio service
      await _audioService.setMusicEnabled(enabled);

      Log.d('Music toggled: $enabled');
    } catch (e) {
      Log.e('Error toggling music: $e');
    }
  }

  @override
  Future<void> close() {
    // Note: We don't dispose audio service here as it's a singleton
    // and should live for the app lifetime
    return super.close();
  }
}
