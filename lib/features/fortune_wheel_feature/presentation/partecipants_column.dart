import 'package:arena_fortune_wheel/features/fortune_wheel_feature/presentation/add_user_input.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/presentation/partecipants_info.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/presentation/partecipants_list.dart';
import 'package:flutter/material.dart';

class PartecipantsColumn extends StatelessWidget {
  const PartecipantsColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PartecipantsInfo(),
        Expanded(
          child: PartecipantsList(),
        ),
        AddUserInput(),
      ],
    );
  }
}
