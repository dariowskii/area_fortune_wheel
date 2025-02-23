import 'package:arena_fortune_wheel/features/fortune_wheel_feature/data/audio_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerButton extends ConsumerStatefulWidget {
  const PlayerButton({super.key});

  @override
  ConsumerState<PlayerButton> createState() => _PlayerButtonState();
}

class _PlayerButtonState extends ConsumerState<PlayerButton> {
  bool _isPlaying = false;

  Future<void> _handlePlay() async {
    try {
      setState(() {
        _isPlaying = !_isPlaying;
      });

      final player = await ref.read(audioProvider.future);
      if (player.playing) {
        await player.stop();
      } else {
        await player.play();
      }
    } catch (e) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _handlePlay,
      icon: Icon(
        _isPlaying ? Icons.pause : Icons.play_arrow,
      ),
    );
  }
}
