import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_player_provider.g.dart';

@riverpod
AudioPlayer audio(Ref ref) {
  final player = AudioPlayer();
  ref.onDispose(player.dispose);
  return player;
}
