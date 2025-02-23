import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_player_provider.g.dart';

@riverpod
Future<AudioPlayer> audio(Ref ref) async {
  final player = AudioPlayer();

  await player.setAsset('assets/songs/theme.mp3');
  await player.setLoopMode(LoopMode.all);
  await player.setVolume(0.5);
  await player.setSpeed(1.0);
  await player.play();

  ref.onDispose(player.dispose);
  return player;
}
