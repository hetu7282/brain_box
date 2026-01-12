import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:brain_box/src/core/services/haptics_service.dart';
import 'package:brain_box/src/core/utils/log.dart';

/// Service for managing audio playback (background music and sound effects)
class AudioService {
  AudioService._() {
    _sfxPlayer.setReleaseMode(ReleaseMode.stop);
  }
  static AudioService? _instance;
  static AudioService get instance {
    _instance ??= AudioService._();
    return _instance!;
  }

  // Background music player - completely separate from sound effects
  // Music and sound can play simultaneously without interfering with each other
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  // Sound effects player - completely separate from background music
  // Sound effects and music can play simultaneously without interfering with each other
  final AudioPlayer _sfxPlayer = AudioPlayer();

  int _currentMusicIndex = 0;
  bool _isMusicEnabled = true;
  bool _isSoundEnabled = true;
  bool _stopMusicOnBackground = false;
  final bool _wasPlayingBeforeBackground = false;

  bool _isPlaying = false;
  StreamSubscription<void>? _playerCompleteSubscription;

  /// Initialize audio service with settings
  Future<void> initialize({required bool musicEnabled}) async {
    _isMusicEnabled = musicEnabled;

    // Configure player mode based on stopMusicOnBackground setting
    // If stopMusicOnBackground is true, use lowLatency mode (stops in background)
    // If false, use mediaPlayer mode (continues in background)
    final playerMode = _stopMusicOnBackground
        ? PlayerMode.lowLatency
        : PlayerMode.mediaPlayer;
    await _backgroundPlayer.setPlayerMode(playerMode);

    // Set player mode to stop when finished (we'll manually play next track)
    await _backgroundPlayer.setReleaseMode(ReleaseMode.stop);

    // Listen for music completion to play next track
    _playerCompleteSubscription = _backgroundPlayer.onPlayerComplete.listen((
      _,
    ) {
      _playNextBackgroundMusic();
    });

    if (_isMusicEnabled) {
      await playBackgroundMusic();
    }
  }

  /// Play background music (replays bgSound1.mp3)
  /// Note: This is independent of the sound enabled setting - music plays regardless of sound state.
  /// This uses _backgroundPlayer which is completely separate from _sfxPlayer (sound effects).
  /// Music and sound effects can play simultaneously without interfering with each other.
  Future<void> playBackgroundMusic() async {
    if (!_isMusicEnabled) return;

    try {
      // Check player state to decide if we should resume or play fresh
      final playerState = _backgroundPlayer.state;
      if (playerState == PlayerState.playing) {
        // Already playing, no need to restart
        _isPlaying = true;
        return;
      }

      // If paused, resume instead of playing fresh
      if (playerState == PlayerState.paused) {
        await _backgroundPlayer.resume();
        _isPlaying = true;
        Log.d('Resumed background music');
        return;
      }

      // Player is stopped or not initialized, play fresh
      _isPlaying = true;
      // Always play bgSound1.mp3 (index 0)
      _currentMusicIndex = 0;
      await _backgroundPlayer.play(AssetSource('audio/bgSound1.mp3'));
      Log.d('Playing background music: bgSound1.mp3');
    } catch (e) {
      Log.e('Error playing background music: $e');
      _isPlaying = false;
    }
  }

  /// Play next background music track (replays bgSound1.mp3)
  Future<void> _playNextBackgroundMusic() async {
    if (!_isMusicEnabled) return;

    // Keep playing bgSound1.mp3 (index 0) in loop
    _currentMusicIndex = 0;
    try {
      _isPlaying = true;
      await _backgroundPlayer.play(AssetSource('audio/bgSound1.mp3'));
      Log.d('Replaying background music: bgSound1.mp3');
    } catch (e) {
      Log.e('Error replaying background music: $e');
      _isPlaying = false;
    }
  }

  /// Stop background music
  Future<void> stopBackgroundMusic() async {
    try {
      await _backgroundPlayer.stop();
      _isPlaying = false;
      Log.d('Background music stopped');
    } catch (e) {
      Log.e('Error stopping background music: $e');
    }
  }

  /// Pause background music
  Future<void> pauseBackgroundMusic() async {
    try {
      final playerState = _backgroundPlayer.state;
      if (playerState == PlayerState.playing) {
        await _backgroundPlayer.pause();
        _isPlaying = false;
        Log.d('Background music paused');
      }
    } catch (e) {
      Log.e('Error pausing background music: $e');
    }
  }

  /// Resume background music
  Future<void> resumeBackgroundMusic() async {
    if (!_isMusicEnabled) return;
    try {
      final playerState = _backgroundPlayer.state;
      if (playerState == PlayerState.paused) {
        await _backgroundPlayer.resume();
        _isPlaying = true;
        Log.d('Background music resumed');
      } else if (playerState == PlayerState.stopped ||
          playerState == PlayerState.completed) {
        // If stopped, play fresh instead of resume
        _isPlaying = false;
        await playBackgroundMusic();
      }
    } catch (e) {
      Log.e('Error resuming background music: $e');
    }
  }

  /// Update music enabled state
  Future<void> setMusicEnabled(bool enabled) async {
    _isMusicEnabled = enabled;
    if (enabled) {
      // Check if player was paused before muting - if so, resume; otherwise play fresh
      final playerState = _backgroundPlayer.state;
      if (playerState == PlayerState.paused) {
        await resumeBackgroundMusic();
      } else {
        // Reset _isPlaying flag to allow new playback
        _isPlaying = false;
        await playBackgroundMusic();
      }
    } else {
      // Mute: pause instead of stop so we can resume later
      await pauseBackgroundMusic();
      _isPlaying = false;
    }
  }

  /// Get current music enabled state
  bool get isMusicEnabled => _isMusicEnabled;

  /// Enable or disable tap sound feedback.
  /// Note: This setting only affects sound effects (tap sounds), not background music.
  /// Music playback is controlled independently by the music enabled setting.
  /// This method will NOT stop, pause, or interfere with background music in any way.
  Future<void> setSoundEnabled(bool enabled) async {
    // Store current music player state before changing sound
    final musicPlayerState = _backgroundPlayer.state;
    final wasMusicPlaying =
        _isMusicEnabled &&
        (musicPlayerState == PlayerState.playing || _isPlaying);

    _isSoundEnabled = enabled;

    // Only play tap sound if enabled, but don't let this affect music playback
    // Use a separate player (_sfxPlayer) for sound effects, won't affect background music player
    if (enabled) {
      // await playTapSound();
    } else {
      await HapticsService.instance.tap();
    }

    // Explicitly ensure music continues playing if it was playing before
    // This prevents sound toggle from accidentally stopping music
    if (_isMusicEnabled && wasMusicPlaying) {
      final currentState = _backgroundPlayer.state;
      // If music was playing but stopped/paused, resume it
      if (currentState == PlayerState.paused ||
          currentState == PlayerState.stopped ||
          currentState == PlayerState.completed) {
        await playBackgroundMusic();
      }
    }
  }

  bool get isSoundEnabled => _isSoundEnabled;

  /// Play a short tap sound if sound is enabled.
  /// Note: This uses _sfxPlayer which is completely separate from _backgroundPlayer.
  /// Music and sound effects can play simultaneously without interfering with each other.
  /// This function will NOT affect background music playback in any way.
  Future<void> playTapSound() async {
    if (!_isSoundEnabled) return;
    try {
      // Stop any previous sound effect and play new one
      // This only affects _sfxPlayer, not _backgroundPlayer (music)
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('audio/toush.mp3'));
      // Background music continues playing independently
    } catch (e) {
      Log.e('Error playing tap sound: $e');
    }
  }

  /// Provide interaction feedback depending on the sound toggle.
  Future<void> triggerInteractionFeedback({bool hapticsEnabled = true}) async {
    if (_isSoundEnabled) {
      await playTapSound();
    } else if (hapticsEnabled) {
      await HapticsService.instance.tap();
    }
  }

  /// Set stop music on background setting
  Future<void> setStopMusicOnBackground(bool enabled) async {
    _stopMusicOnBackground = enabled;

    // Update player mode based on setting
    // If enabled, use lowLatency mode (stops in background)
    // If disabled, use mediaPlayer mode (continues in background)
    final playerMode = enabled ? PlayerMode.lowLatency : PlayerMode.mediaPlayer;
    await _backgroundPlayer.setPlayerMode(playerMode);

    Log.d('Stop music on background: $enabled, PlayerMode: $playerMode');
  }

  /*
  /// Handle app going to background - pause music if setting is enabled
  Future<void> handleAppLifecyclePaused() async {
    if (!_stopMusicOnBackground) {
      // Setting is disabled, music continues playing in background
      return;
    }

    try {
      final playerState = _backgroundPlayer.state;
      if (playerState == PlayerState.playing) {
        _wasPlayingBeforeBackground = true;
        await pauseBackgroundMusic();
        Log.d('Background music paused on app background');
      } else {
        _wasPlayingBeforeBackground = false;
      }
    } catch (e) {
      Log.e('Error handling app lifecycle paused: $e');
    }
  }

  /// Handle app coming to foreground - resume music if it was playing
  Future<void> handleAppLifecycleResumed() async {
    if (!_stopMusicOnBackground) {
      Log.d('Music should continue playing on app foreground');
      // Setting is disabled, music should continue playing
      return;
    }

    if (!_isMusicEnabled) return;

    try {
      // If music was playing before background and setting is enabled, resume it
      if (_wasPlayingBeforeBackground) {
        await resumeBackgroundMusic();
        Log.d('Background music resumed on app foreground');
        _wasPlayingBeforeBackground = false;
      }
    } catch (e) {
      Log.e('Error handling app lifecycle resumed: $e');
    }
  }
 */
  /// Dispose resources
  Future<void> dispose() async {
    _playerCompleteSubscription?.cancel();
    await _backgroundPlayer.dispose();
  }
}
