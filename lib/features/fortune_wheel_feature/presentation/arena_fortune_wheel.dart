import 'package:arena_fortune_wheel/constants.dart';
import 'package:arena_fortune_wheel/extensions.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/data/fortune_wheel_provider.dart'
    show fortuneWheelProvider;
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class ArenaFortuneWheel extends ConsumerWidget {
  const ArenaFortuneWheel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fortuneState = ref.watch(fortuneWheelProvider);

    List<FortuneItem> fortuneItems = [];
    var partecipants = fortuneState.participants;
    var colors = fortuneState.associatedColors;

    if (partecipants.isEmpty || partecipants.length < 2) {
      partecipants = kDefaultItems;
      colors = kDefaultItemsColors;
    }

    for (var i = 0; i < partecipants.length; i++) {
      final color = colors[i];
      final textColor =
          color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
      fortuneItems.add(
        FortuneItem(
          child: FittedBox(
            child: Text(partecipants[i].name),
          ),
          style: FortuneItemStyle(
            color: color,
            textStyle: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return FortuneWheel(
      selected: ref.read(fortuneWheelProvider.notifier).streamController.stream,
      alignment: Alignment.centerRight,
      animateFirst: false,
      onAnimationEnd: () {
        ref
            .read(
              fortuneWheelProvider.notifier,
            )
            .finish();
      },
      physics: CircularPanPhysics(
        duration: 2.seconds,
        curve: Curves.decelerate,
      ),
      indicators: [
        FortuneIndicator(
          alignment: Alignment.centerRight,
          child: Transform.rotate(
            angle: math.pi / 2,
            child: const TriangleIndicator(
              color: Colors.yellow,
              elevation: 4,
            ),
          ),
        ),
      ],
      items: fortuneItems,
    );
  }
}
