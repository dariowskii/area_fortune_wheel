import 'dart:async';

import 'package:arena_fortune_wheel/constants.dart';
import 'package:arena_fortune_wheel/extensions.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/data/fortune_wheel_provider.dart'
    show fortuneWheelProvider;
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class ArenaFortuneWheel extends ConsumerWidget {
  const ArenaFortuneWheel({super.key});

  void _presentWinnerDialog(
    BuildContext context,
    WidgetRef ref,
  ) {
    final winner =
        ref.read(fortuneWheelProvider.notifier).getLatestWinner().name;

    _launchConfetti(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Winner 🎉'),
          content: Text(
            'Il vincitore è $winner!',
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(fortuneWheelProvider.notifier).finish(remove: false);
                Navigator.of(context).pop();
              },
              child: const Text('Chiudi'),
            ),
            FilledButton(
              onPressed: () {
                ref.read(fortuneWheelProvider.notifier).finish();
                Navigator.of(context).pop();
              },
              child: const Text('Rimuovi vincitore'),
            ),
          ],
        );
      },
    );
  }

  void _launchConfetti(BuildContext context) {
    if (context.isSmallScreen) {
      _launchConfettiMobile(context);
      return;
    }

    const colors = [
      Color(0xFFff5e7e),
      Color(0xFFfcff42),
      Color(0xFFffa62d),
    ];
    final frameTime = 1000 ~/ 24;
    final total = 5 * 1000 ~/ frameTime;
    int progress = 0;

    ConfettiController? controller1;
    ConfettiController? controller2;
    bool isDone = false;

    Timer.periodic(frameTime.ms, (timer) {
      progress++;

      if (progress >= total) {
        timer.cancel();
        isDone = true;
        return;
      }
      if (controller1 == null) {
        controller1 = Confetti.launch(
          context,
          options: const ConfettiOptions(
            particleCount: 2,
            angle: 60,
            spread: 55,
            x: 0,
            colors: colors,
          ),
          onFinished: (overlayEntry) {
            if (isDone) {
              overlayEntry.remove();
            }
          },
        );
      } else {
        controller1!.launch();
      }

      if (controller2 == null) {
        controller2 = Confetti.launch(
          context,
          options: const ConfettiOptions(
            particleCount: 2,
            angle: 120,
            spread: 55,
            x: 1,
            colors: colors,
          ),
          onFinished: (overlayEntry) {
            if (isDone) {
              overlayEntry.remove();
            }
          },
        );
      } else {
        controller2!.launch();
      }
    });
  }

  void _launchConfettiMobile(BuildContext context) {
    shoot() {
      Confetti.launch(
        context,
        options: const ConfettiOptions(
          particleCount: 100,
          spread: 70,
          y: -0.5,
          angle: -90,
          ticks: 400,
        ),
      );
    }

    Timer(0.ms, shoot);
    Timer(200.ms, shoot);
    Timer(1.seconds, shoot);
    Timer(2.seconds, shoot);
  }

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
        _presentWinnerDialog(context, ref);
      },
      physics: CircularPanPhysics(
        duration: 3.seconds,
        curve: Curves.decelerate,
      ),
      onFling: () {
        ref.read(fortuneWheelProvider.notifier).spin();
      },
      indicators: [
        FortuneIndicator(
          alignment: Alignment.centerRight,
          child: Transform.rotate(
            angle: math.pi / 2,
            child: TriangleIndicator(
              color: Colors.yellow,
              elevation: 4,
              width: context.isSmallScreen ? 20 : 36,
              height: context.isSmallScreen ? 20 : 36,
            ),
          ),
        ),
      ],
      items: fortuneItems,
    );
  }
}
