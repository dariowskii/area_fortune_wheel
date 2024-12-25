import 'package:arena_fortune_wheel/extensions.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/presentation/add_user_input.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/presentation/arena_fortune_wheel.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/presentation/confetti_dispatcher.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/presentation/partecipants_info.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/presentation/partecipants_list.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/presentation/spin_button.dart';
import 'package:flutter/material.dart';

class FortuneWheelScreen extends StatefulWidget {
  const FortuneWheelScreen({super.key});

  @override
  State<FortuneWheelScreen> createState() => _FortuneWheelScreenState();
}

class _FortuneWheelScreenState extends State<FortuneWheelScreen> {
  var _drawerIsOpen = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arena\'s Fortune Wheel'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Positioned.fill(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Column(
                              spacing: 64,
                              children: [
                                SizedBox(
                                  height: constraints.maxHeight * 0.8,
                                  width: constraints.maxHeight * 0.8,
                                  child: const ArenaFortuneWheel(),
                                ),
                                const SpinButton(),
                              ],
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _drawerIsOpen = !_drawerIsOpen;
                            });
                          },
                          icon: AnimatedRotation(
                            duration: 300.ms,
                            turns: _drawerIsOpen ? 0 : .5,
                            child: const Icon(
                              Icons.keyboard_tab,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: 600.ms,
                  curve: Curves.easeInOut,
                  width: _drawerIsOpen ? size.width * 0.3 : 0,
                  child: OverflowBox(
                    child: AnimatedOpacity(
                      duration: _drawerIsOpen ? 600.ms : 400.ms,
                      opacity: _drawerIsOpen ? 1 : 0,
                      child: const Column(
                        spacing: 16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PartecipantsInfo(),
                          Expanded(
                            child: PartecipantsList(),
                          ),
                          AddUserInput(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const ConfettiDispatcher(),
          ],
        ),
      ),
    );
  }
}
