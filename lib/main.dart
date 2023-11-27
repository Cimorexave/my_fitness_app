import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightGreen[200],
            title: const Text('my fitness app'),
          ),
          body: const Center(
            child: Text("Center"),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.lightGreen[200],
            focusColor: Colors.lightGreen[100],
            onPressed: () => print('pressed fab.'),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
