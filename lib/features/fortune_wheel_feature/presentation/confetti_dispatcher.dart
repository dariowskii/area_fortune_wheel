import 'package:arena_fortune_wheel/features/fortune_wheel_feature/data/fortune_wheel_provider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class ConfettiDispatcher extends ConsumerWidget {
  const ConfettiDispatcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confettiController =
        ref.read(fortuneWheelProvider.notifier).confettiController;
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        blastDirection: math.pi,
        numberOfParticles: 200,
      ),
    );
  }
}
