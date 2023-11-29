import 'package:flutter/material.dart';

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

  void submitForm() {
    print('Submitting Form');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.green[50],
      title: const Text('Add New Record'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: const AddRecordForm(),
      ),
      actions: [
        ElevatedButton(
            onPressed: () => {Navigator.of(context).pop()},
            child: const Text('Cancel')),
        ElevatedButton(
            onPressed: () {
              submitForm();
            },
            child: const Text('Add')),
      ],
    );
  }
}

class AddRecordForm extends StatefulWidget {
  const AddRecordForm({super.key});

  @override
  State<AddRecordForm> createState() => _AddRecordFormState();
}

class _AddRecordFormState extends State<AddRecordForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Title:'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Title cannot be empty.";
              }
              return null;
            },
            onSaved: (value) => print('title: $value'),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Calories:'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Value can't be empty.";
              }
              if (int.tryParse(value) is int) {
                return "Value must be a number.";
              }
              return null;
            },
            onSaved: (value) => print('calories: $value'),
          ),
          TextFormField(
            decoration:
                const InputDecoration(labelText: 'Description (optional):'),
            validator: (value) {
              return null;
            },
            onSaved: (value) => print('description: $value'),
          ),
        ],
      ),
    );
  }
}
