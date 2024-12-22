import 'dart:async';
import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

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

  @override
  void dispose() {
    _selectedStream.close();
    _confettiController.dispose();
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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * 0.8,
                            width: constraints.maxHeight * 0.8,
                            child: FortuneWheel(
                              selected: _selectedStream.stream,
                              alignment: Alignment.centerRight,
                              animateFirst: false,
                              onAnimationEnd: () {
                                _confettiController.play();
                              },
                              onAnimationStart: () {
                                _confettiController.stop();
                              },
                              indicators: [
                                FortuneIndicator(
                                  alignment: Alignment.centerRight,
                                  child: Transform.rotate(
                                    angle: math.pi / 2,
                                    child: TriangleIndicator(),
                                  ),
                                ),
                              ],
                              items: [
                                FortuneItem(child: Text('Item 1')),
                                FortuneItem(child: Text('Item 2')),
                                FortuneItem(child: Text('Item 3')),
                                FortuneItem(child: Text('Item 4')),
                                FortuneItem(child: Text('Item 5')),
                                FortuneItem(child: Text('Item 6')),
                                FortuneItem(child: Text('Item 7')),
                                FortuneItem(child: Text('Item 8')),
                                FortuneItem(child: Text('Item 9')),
                                FortuneItem(child: Text('Item 10')),
                              ],
                            ),
                          ),
                          SizedBox(height: 64),
                          ElevatedButton(
                            onPressed: () {
                              final random = math.Random();
                              _selectedStream.add(random.nextInt(10));
                            },
                            child: Text('Spin'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: size.width * 0.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Partecipanti',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('Partecipante ${index + 1}'),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: TextField(
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
                          onSubmitted: (value) {
                            print(value);
                          },
                        ),
                      ),
                    ],
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
