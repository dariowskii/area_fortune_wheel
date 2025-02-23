import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import 'package:arena_fortune_wheel/extensions.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/presentation/arena_fortune_wheel.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/presentation/last_extracted_partecipant.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/presentation/partecipants_column.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/presentation/spin_button.dart';
import 'package:flutter/material.dart';

class FortuneWheelScreen extends ConsumerStatefulWidget {
  const FortuneWheelScreen({super.key});

  @override
  ConsumerState<FortuneWheelScreen> createState() => _FortuneWheelScreenState();
}

class _FortuneWheelScreenState extends ConsumerState<FortuneWheelScreen> {
  var _drawerIsOpen = true;

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = context.isSmallScreen;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arena\'s Fortune Wheel'),
      ),
      endDrawer: isSmallScreen
          ? const Drawer(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  bottom: 16,
                ),
                child: PartecipantsColumn(),
              ),
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final smallest = min(
                          constraints.maxWidth,
                          constraints.maxHeight,
                        );
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: smallest * 0.8,
                              width: smallest * 0.8,
                              child: const ArenaFortuneWheel(),
                            ),
                            SizedBox(
                              height: smallest * 0.2,
                              child: const Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                spacing: 8,
                                children: [
                                  LastExtractedPartecipant(),
                                  SpinButton(),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  if (!isSmallScreen) ...[
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
                ],
              ),
            ),
            if (!isSmallScreen) ...[
              AnimatedContainer(
                duration: 600.ms,
                curve: Curves.easeInOut,
                width: _drawerIsOpen ? context.width * 0.3 : 0,
                child: OverflowBox(
                  child: AnimatedOpacity(
                    duration: _drawerIsOpen ? 600.ms : 400.ms,
                    opacity: _drawerIsOpen ? 1 : 0,
                    curve: Curves.easeInOut,
                    child: const PartecipantsColumn(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
