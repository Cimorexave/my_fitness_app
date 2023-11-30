import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_fitness_app/model/record.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[200],
        title: const Text('my fitness app'),
      ),
      body: Center(
        // child: Text("Center"),
        child: RecordsList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen[200],
        focusColor: Colors.lightGreen[100],
        onPressed: () => {
          showDialog(
            context: context,
            builder: (context) => AddRecordStatelessDialog(),
          )
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddRecordStatelessDialog extends StatelessWidget {
  AddRecordStatelessDialog({super.key});

  final formKey = GlobalKey<FormState>();
  final TextEditingController titleFieldController = TextEditingController();
  final TextEditingController caloriesFieldController = TextEditingController();
  final TextEditingController descriptionFieldController =
      TextEditingController();

  void addRecord(Record newRecord) async {
    Box<Record> recordsBox = Hive.box<Record>('recordsBox');
    await recordsBox.add(newRecord);
  }

  // Future<bool> saveRecord(
  //     String title, String calories, String description) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   // date => values
  //   DateTime dateTime = DateTime.now();
  //   print(dateTime.toUtc().toIso8601String());
  //   return await prefs.setString(
  //       dateTime.toUtc().toIso8601String(), '$title;$calories;$description');
  // }

  void submitForm(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // formKey.currentState!.save();
      print(
          'title: ${titleFieldController.text}\ncalories: ${caloriesFieldController.text}\ndescription: ${descriptionFieldController.text}');
      Navigator.of(context).pop();

      // bool saveResult = await saveRecord(titleFieldController.text,
      //     caloriesFieldController.text, descriptionFieldController.text);
      // if (saveResult) {
      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('Successfully Added Record.'),
      //     backgroundColor: Colors.green,
      //   ));
      // }

      addRecord(Record(
          title: titleFieldController.text,
          dateOfEntry: DateTime.now(),
          calories: int.parse(caloriesFieldController.text),
          description: descriptionFieldController.text));

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Successfully Added Record.'),
        backgroundColor: Colors.green,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.green[50],
      title: const Text('Add New Record'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: AddRecordForm(
          formKey: formKey,
          titleFieldController: titleFieldController,
          caloriesFieldController: caloriesFieldController,
          descriptionFieldController: descriptionFieldController,
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () => {Navigator.of(context).pop()},
            child: const Text('Cancel')),
        ElevatedButton(
            onPressed: () {
              submitForm(context);
            },
            child: const Text('Add')),
      ],
    );
  }
}

class AddRecordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleFieldController;
  final TextEditingController caloriesFieldController;
  final TextEditingController descriptionFieldController;

  const AddRecordForm(
      {super.key,
      required this.formKey,
      required this.titleFieldController,
      required this.caloriesFieldController,
      required this.descriptionFieldController});

  void submitField(String key, String value) {
    print('submitted field with key');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
            // onSaved: (value) => submitField('title', value!),
            controller: titleFieldController,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Calories:'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Value can't be empty.";
              }
              if (int.tryParse(value) is! int) {
                return "Value must be a number.";
              }
              return null;
            },
            // onSaved: (value) => submitField('calories', value!),
            controller: caloriesFieldController,
          ),
          TextFormField(
            decoration:
                const InputDecoration(labelText: 'Description (optional):'),
            validator: (value) {
              return null;
            },
            // onSaved: (value) => submitField('description', value!),
            controller: descriptionFieldController,
          ),
        ],
      ),
    );
  }
}

class RecordsList extends StatelessWidget {
  RecordsList({super.key});

  final recordsBox = Hive.box<Record>('recordsBox');

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: recordsBox.listenable(),
        builder: (context, Box<Record> recordsBox, _) {
          return ListView.builder(
              itemCount: recordsBox.length,
              itemBuilder: (context, index) {
                final Record record = recordsBox.getAt(index) as Record;
                return ListTile(
                  title: Text(record.title),
                  subtitle: Text(
                      '${record.description ?? "No Description"} - ${record.calories} calories'),
                  trailing: Text('${record.dateOfEntry.toLocal()}'),
                  tileColor: Colors.green[50],
                );
              });
        });
  }
}
