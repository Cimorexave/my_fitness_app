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
            onPressed: () => {
              showDialog(
                  context: context,
                  builder: (context) => const AddRecordWidget())
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class AddRecordWidget extends StatefulWidget {
  const AddRecordWidget({super.key});

  @override
  State<AddRecordWidget> createState() => _AddRecordWidgetState();
}

class _AddRecordWidgetState extends State<AddRecordWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Center Dialog'),
    );
  }
}
