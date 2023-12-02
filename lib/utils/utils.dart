import "../model/record.dart";
import 'package:intl/intl.dart';

Map<DateTime, List<Record>> groupRecordsByDay(List<Record> records) {
  var groupedRecords = <DateTime, List<Record>>{};

  for (Record record in records) {
    // Check if the group (date) already exists, and add the record to it
    bool found = false;
    for (var key in groupedRecords.keys) {
      if (isSameDay(key, record.dateOfEntry)) {
        groupedRecords[key]?.add(record);
        found = true;
        break;
      }
    }

    // If the group (date) does not exist, create a new one
    if (!found) {
      groupedRecords[record.dateOfEntry] = [record];
    }
  }

  return groupedRecords;
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String formatDate(DateTime date) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

  String formattedDate = DateFormat('yyyy/MM/dd, EEEE').format(date);

  if (date.isAtSameMomentAs(today)) {
    return 'Today, $formattedDate';
  } else if (date.isAtSameMomentAs(yesterday)) {
    return 'Yesterday, $formattedDate';
  } else {
    return formattedDate;
  }
}
