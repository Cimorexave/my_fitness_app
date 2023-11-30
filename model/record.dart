class Record {
  String title;
  String? description; // Optional
  DateTime dateOfEntry;
  int calories;

  Record({
    required this.title,
    required this.calories,
    this.description,
    required this.dateOfEntry,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'title': title,
  //     'description': description,
  //     'dateOfEntry': dateOfEntry.toIso8601String(),
  //     'calories': calories,
  //   };
  // }

  // factory Record.fromMap(Map<String, dynamic> map) {
  //   return Record(
  //     title: map['title'],
  //     description: map['description'],
  //     dateOfEntry: DateTime.parse(map['dateOfEntry']),
  //     calories: map['calories'],
  //   );
  // }
}
