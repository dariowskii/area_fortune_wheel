import 'package:arena_fortune_wheel/features/fortune_wheel_feature/data/fortune_wheel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PartecipantsList extends ConsumerWidget {
  const PartecipantsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partecipants = ref.watch(
      fortuneWheelProvider.select(
        (state) => state.participants,
      ),
    );

    return ClipRRect(
      child: ListView.builder(
        itemCount: partecipants.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(partecipants[index].name),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.redAccent,
              alignment: Alignment.centerRight,
              child: const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            onDismissed: (_) {
              ref
                  .read(
                    fortuneWheelProvider.notifier,
                  )
                  .removeParticipant(index);
            },
            child: ListTile(
              title: Text(partecipants[index].name),
            ),
          );
        },
      ),
    );
  }
}
