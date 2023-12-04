import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:intl/intl.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_fitness_app/model/record.dart';
import 'package:my_fitness_app/utils/utils.dart';

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
        // child: RecordsList(),
        child: CategorizedRecordsList(),
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

  void submitForm(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // formKey.currentState!.save();
      // print(
      //     'title: ${titleFieldController.text}\ncalories: ${caloriesFieldController.text}\ndescription: ${descriptionFieldController.text}');
      Navigator.of(context).pop();

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
    // print('submitted field with key');
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
                // List<Record> allRecords = recordsBox.values.toList();

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

class CategorizedRecordsList extends StatelessWidget {
  CategorizedRecordsList({super.key});

  final recordsBox = Hive.box<Record>('recordsBox');

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: recordsBox.listenable(),
        builder: (context, Box<Record> recordsBox, _) {
          List<Record> allRecords = recordsBox.values.toList();
          Map<DateTime, List<Record>> groupedRecords =
              groupRecordsByDay(allRecords);
          return ListView.builder(
              itemCount: groupedRecords.keys.length,
              itemBuilder: (context, index) {
                DateTime date = groupedRecords.keys.elementAt(index);
                List<Record> dayRecords = groupedRecords[date]!;

                // final Record record = recordsBox.getAt(index) as Record;
                return ExpansionTile(
                  title: Text('''${formatDate(date)} '''
                      '''(${calculateSumOfDayCalories(dayRecords).toString()})'''), // Formatting the date
                  collapsedBackgroundColor: evaluateDayCalories(dayRecords),
                  children: dayRecords
                      .map((record) => Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black, width: 0.0))),
                            child: ListTile(
                              tileColor: evaluateMealCalories(record.calories),
                              contentPadding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              visualDensity: VisualDensity.compact,
                              title: Text(record
                                  .title), // Replace 'title' with the relevant property of Record
                              subtitle: Text(record.description ?? ""),
                              trailing: Text(record.calories.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          14)), // Replace 'description' with the relevant property
                              onTap: () {
                                // print('tapped items list: ${record.title}');
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      EditRecordStatelessDialog(
                                    editingRecord: record,
                                  ),
                                );
                              },
                              // Add any other relevant details or widgets here
                            ),
                          ))
                      .toList(),
                );
              });
        });
  }
}

class EditRecordStatelessDialog extends StatefulWidget {
  const EditRecordStatelessDialog({super.key, required this.editingRecord});

  final Record editingRecord;

  @override
  State<EditRecordStatelessDialog> createState() =>
      _EditRecordStatelessDialogState();
}

class _EditRecordStatelessDialogState extends State<EditRecordStatelessDialog> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController titleFieldController = TextEditingController();

  final TextEditingController caloriesFieldController = TextEditingController();

  final TextEditingController descriptionFieldController =
      TextEditingController();

  void deleteRecord(Record targetRecord) {
    Box<Record> recordsBox = Hive.box<Record>('recordsBox');
    recordsBox.delete(targetRecord);
  }

  @override
  void initState() {
    titleFieldController.text = widget.editingRecord.title;
    caloriesFieldController.text = widget.editingRecord.calories.toString();
    descriptionFieldController.text = widget.editingRecord.description ?? "";
    super.initState();
  }

  // void editRecord(BuildContext context, Record targetRecord) {
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
              // editRecord(context, editingRecord);
            },
            child: const Text('Save')),
        ElevatedButton(
            onPressed: () {
              deleteRecord(widget.editingRecord);
            },
            child: const Text('Delete')),
      ],
    );
  }
}
