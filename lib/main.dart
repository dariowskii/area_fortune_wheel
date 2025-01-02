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
    return MaterialApp(
      title: 'Arena\'s Fortune Wheel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const FortuneWheelScreen(),
    );
  }
}
