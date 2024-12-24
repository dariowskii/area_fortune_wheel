import 'dart:async';
import 'dart:math' as math;

import 'package:arena_fortune_wheel/constants.dart';
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/data/fortune_wheel_provider.dart'
    show fortuneWheelProvider;
import 'package:arena_fortune_wheel/features/fortune_wheel_feature/domain/participant.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FortuneWheelScreen extends StatefulWidget {
  const FortuneWheelScreen({super.key});

  @override
  State<FortuneWheelScreen> createState() => _FortuneWheelScreenState();
}

class _FortuneWheelScreenState extends State<FortuneWheelScreen> {
  late final _selectedStream = StreamController<int>();
  late final _confettiController = ConfettiController(
    duration: const Duration(seconds: 5),
  );
  late final _textController = TextEditingController();

  var _drawerIsOpen = true;

  @override
  void dispose() {
    _selectedStream.close();
    _confettiController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Arena\'s Fortune Wheel'),
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
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      final fortuneState =
                                          ref.watch(fortuneWheelProvider);

                                      List<FortuneItem> fortuneItems = [];
                                      var partecipants =
                                          fortuneState.participants;
                                      var colors =
                                          fortuneState.associatedColors;

                                      if (partecipants.isEmpty ||
                                          partecipants.length < 2) {
                                        partecipants = kDefaultItems
                                            .map((e) => Partecipant(name: e))
                                            .toList();
                                        colors = kDefaultItemsColors;
                                      }

                                      for (var i = 0;
                                          i < partecipants.length;
                                          i++) {
                                        final color = colors[i];
                                        final textColor =
                                            color.computeLuminance() > 0.5
                                                ? Colors.black
                                                : Colors.white;
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
                                        selected: _selectedStream.stream,
                                        alignment: Alignment.centerRight,
                                        animateFirst: false,
                                        onAnimationEnd: () {
                                          _confettiController.play();
                                        },
                                        onAnimationStart: () {
                                          _confettiController.stop();
                                        },
                                        physics: CircularPanPhysics(
                                          duration: const Duration(seconds: 2),
                                          curve: Curves.decelerate,
                                        ),
                                        indicators: [
                                          FortuneIndicator(
                                            alignment: Alignment.centerRight,
                                            child: Transform.rotate(
                                              angle: math.pi / 2,
                                              child: TriangleIndicator(
                                                color: Colors.yellow,
                                                elevation: 4,
                                              ),
                                            ),
                                          ),
                                        ],
                                        items: fortuneItems,
                                      );
                                    },
                                  ),
                                ),
                                Consumer(
                                  builder: (context, ref, child) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        final itemsLength = ref.read(
                                          fortuneWheelProvider.select(
                                            (state) =>
                                                state.participants.length,
                                          ),
                                        );

                                        if (itemsLength < 2) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Aggiungi almeno due partecipanti!',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        final random = math.Random.secure();
                                        _selectedStream.add(random.nextInt(
                                          ref.read(
                                            fortuneWheelProvider.select(
                                              (state) =>
                                                  state.participants.length,
                                            ),
                                          ),
                                        ));
                                      },
                                      child: Text('Spin'),
                                    );
                                  },
                                ),
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
                            duration: const Duration(milliseconds: 300),
                            turns: _drawerIsOpen ? 0 : .5,
                            child: Icon(
                              Icons.keyboard_tab,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 600,
                  ),
                  curve: Curves.easeInOut,
                  width: _drawerIsOpen ? size.width * 0.3 : 0,
                  child: OverflowBox(
                    child: AnimatedOpacity(
                      duration:
                          Duration(milliseconds: _drawerIsOpen ? 600 : 400),
                      opacity: _drawerIsOpen ? 1 : 0,
                      child: Column(
                        spacing: 16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              final partecipants = ref.watch(
                                fortuneWheelProvider.select(
                                  (state) => state.participants.length,
                                ),
                              );
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Partecipanti ($partecipants)',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      ref
                                          .read(fortuneWheelProvider.notifier)
                                          .reset();
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              );
                            },
                          ),
                          Expanded(
                            child: Consumer(
                              builder: (context, ref, child) {
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
                                          child: Row(
                                            spacing: 8,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Elimina',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                        onDismissed: (_) {
                                          ref
                                              .read(
                                                  fortuneWheelProvider.notifier)
                                              .removeParticipant(index);
                                        },
                                        child: ListTile(
                                          title: Text(partecipants[index].name),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          Row(
                            spacing: 8,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _textController,
                                  decoration: InputDecoration(
                                    hintText: 'Aggiungi partecipanti',
                                    border: OutlineInputBorder(),
                                  ),
                                  onTapOutside: (_) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  maxLength: 1000,
                                  minLines: 1,
                                  maxLines: 10,
                                ),
                              ),
                              Consumer(
                                builder: (context, ref, child) {
                                  return IconButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      final text = _textController.text.trim();
                                      if (text.isEmpty) {
                                        return;
                                      }
                                      ref
                                          .read(fortuneWheelProvider.notifier)
                                          .handleUserInput(
                                              _textController.text);
                                      _textController.clear();
                                    },
                                    icon: Icon(Icons.add),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                blastDirection: math.pi,
                numberOfParticles: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
