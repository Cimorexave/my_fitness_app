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
          appBar: AppBar(),
          body: const Center(
            child: Text("Center"),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => {print('pressed fab.')},
          ),
        ),
      ),
    );
  }
}
