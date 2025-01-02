import 'package:arena_fortune_wheel/features/fortune_wheel_feature/data/fortune_wheel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LastExtractedPartecipant extends ConsumerWidget {
  const LastExtractedPartecipant({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastExtraced = ref.watch(fortuneWheelProvider).lastSelected;
    if (lastExtraced == null) {
      return const SizedBox.shrink();
    }

    return Text(
      'Ultimo estratto: ${lastExtraced.name}',
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}
