import "dart:math";
import "package:hive/hive.dart";
import "model/record.dart";

List<Record> getRandomData(int recordsCount) {
  List<Record> records = [];
  for (int i = 0; i < recordsCount; i++) {
    records.add(Record(
        title: getRandomString(5),
        dateOfEntry:
            DateTime.now().subtract(Duration(days: getRandomIntInRange(0, 30))),
        calories: getRandomIntInRange(0, 1000)));
  }
  return records;
}

int getRandomIntInRange(int from, int to) {
  final random = Random();
  return from + random.nextInt(to - from + 1);
}

String getRandomString(int length) {
  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();

  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

List<Record> getFixData() {
  return [
    Record(title: 'Watermelon', dateOfEntry: DateTime.now(), calories: 20),
    Record(
        title: 'Chocolate',
        dateOfEntry: DateTime.now(),
        calories: 80,
        description: 'one small piece'),
    Record(title: 'Tea', dateOfEntry: DateTime.now(), calories: 0),
    Record(
        title: 'Steak',
        dateOfEntry: DateTime.now(),
        calories: 500,
        description: 'medium rare'),
    Record(
        title: 'Tea',
        dateOfEntry: DateTime.now().subtract(const Duration(days: 1)),
        calories: 0),
    Record(
        title: 'Mushroom Stew',
        dateOfEntry: DateTime.now().subtract(const Duration(days: 1)),
        calories: 250),
    Record(
        title: 'Popcorn',
        dateOfEntry: DateTime.now().subtract(const Duration(days: 2)),
        calories: 125),
    Record(
        title: 'Beans',
        dateOfEntry: DateTime.now().subtract(const Duration(days: 3)),
        calories: 305),
    Record(
        title: 'Rice',
        dateOfEntry: DateTime.now().subtract(const Duration(days: 5)),
        calories: 350,
        description: '1 small bowl'),
  ];
}

void injectData(Box<Record> hiveBox, {String dataType = "fixed"}) async {
  switch (dataType) {
    case 'fixed':
      {
        await hiveBox.addAll(getFixData());
      }
    case 'random':
      {
        await hiveBox.addAll(getRandomData(100));
      }
  }
}
