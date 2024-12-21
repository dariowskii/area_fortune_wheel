import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamController<int> selected = StreamController<int>();

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: width * 0.8,
              height: width * 0.8,
              child: FortuneWheel(
                selected: selected.stream,
                alignment: Alignment.centerRight,
                indicators: [
                  FortuneIndicator(
                    alignment: Alignment.centerRight,
                    child: Transform.rotate(
                      angle: pi / 2,
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
                final random = Random();
                selected.add(random.nextInt(10));
              },
              child: Text('Spin'),
            ),
          ],
        ),
      ),
    );
  }
}
