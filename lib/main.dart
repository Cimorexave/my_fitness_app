import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'my fittness app',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            builder: (context) => const AddRecordStatelessDialog(),
          )
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddRecordStatelessDialog extends StatelessWidget {
  const AddRecordStatelessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.green[50],
      title: const Text('Add New Record'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: const Text('content center child'),
      ),
      actions: [
        ElevatedButton(
            onPressed: () => {Navigator.of(context).pop()},
            child: const Text('Cancel')),
        ElevatedButton(onPressed: () => {}, child: const Text('Add')),
      ],
    );
  }
}
