import 'package:arena_fortune_wheel/features/fortune_wheel_feature/data/fortune_wheel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PartecipantsInfo extends ConsumerWidget {
  const PartecipantsInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partecipants = ref.watch(
      fortuneWheelProvider.select(
        (state) => state.participants.length,
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            'Partecipanti ($partecipants)',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () {
              ref.read(fortuneWheelProvider.notifier).reset();
            },
            icon: const Icon(Icons.delete),
          ),
        ),
      ],
    );
  }
}
