import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';

/// Low-volume collection feedback that can overlap during rapid taps.
class DropSoundService {
  DropSoundService._();

  static final instance = DropSoundService._();
  static const _maxConcurrentPlayers = 8;
  final Random _random = Random();
  int _activePlayers = 0;

  Future<void> playWhoosh() =>
      _play(volume: .10, minimumRate: .90, maximumRate: 1.10);

  Future<void> playRemove() =>
      _play(volume: .075, minimumRate: .68, maximumRate: .80);

  Future<void> _play({
    required double volume,
    required double minimumRate,
    required double maximumRate,
  }) async {
    if (_activePlayers >= _maxConcurrentPlayers) return;
    _activePlayers++;
    final player = AudioPlayer();
    try {
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setVolume(volume);
      await player.setPlaybackRate(
        minimumRate + _random.nextDouble() * (maximumRate - minimumRate),
      );
      await player.play(
        AssetSource('sound/Whoosh 0${1 + _random.nextInt(4)}.wav'),
      );
      await player.onPlayerComplete.first.timeout(
        const Duration(seconds: 2),
        onTimeout: () {},
      );
    } catch (_) {
      // Sound is optional feedback and must never interrupt collection.
    } finally {
      await player.dispose();
      _activePlayers--;
    }
  }
}
