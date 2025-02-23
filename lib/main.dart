import 'package:arena_fortune_wheel/features/fortune_wheel_feature/data/audio_player_provider.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/presentation/fortune_wheel_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ArenaFortuneApp(),
    ),
  );
}

class ArenaFortuneApp extends StatelessWidget {
  const ArenaFortuneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _EagerInit(
      child: MaterialApp(
        title: 'Arena\'s Fortune Wheel',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const FortuneWheelScreen(),
      ),
    );
  }
}

class _EagerInit extends ConsumerWidget {
  const _EagerInit({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(audioProvider);
    return child;
  }
}
