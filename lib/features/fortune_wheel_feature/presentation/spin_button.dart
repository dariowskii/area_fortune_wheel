import 'package:arena_fortune_wheel/features/fortune_wheel_feature/data/fortune_wheel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpinButton extends ConsumerWidget {
  const SpinButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(
      fortuneWheelProvider.select(
        (state) => state.viewState,
      ),
    );
    return FilledButton(
      onPressed: viewState == ViewState.spinning
          ? null
          : () {
              final itemsLength = ref.read(
                fortuneWheelProvider.select(
                  (state) => state.participants.length,
                ),
              );

              if (itemsLength < 2) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Aggiungi almeno due partecipanti!',
                    ),
                  ),
                );
                return;
              }

              ref
                  .read(
                    fortuneWheelProvider.notifier,
                  )
                  .spin();
            },
      child: const Text('Gira la ruota!'),
    );
  }
}
