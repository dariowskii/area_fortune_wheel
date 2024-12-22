import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class FortuneWheelScreen extends StatefulWidget {
  const FortuneWheelScreen({super.key});

  @override
  State<FortuneWheelScreen> createState() => _FortuneWheelScreenState();
}

class _FortuneWheelScreenState extends State<FortuneWheelScreen> {
  StreamController<int> selected = StreamController<int>();

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: Row(
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
                          selected: selected.stream,
                          alignment: Alignment.centerRight,
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
                          selected.add(random.nextInt(10));
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
