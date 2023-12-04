import 'package:flutter/material.dart';

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

  if (date.day == today.day) {
    return '${DateFormat('yyyy/MM/dd').format(date)}, Today';
  } else if (date.day == yesterday.day) {
    return '${DateFormat('yyyy/MM/dd').format(date)}, Yesterday';
  } else {
    return formattedDate;
  }
}

Color? evaluateMealCalories(int calories) {
  if (calories < 0) {
    return Colors.blue[100];
  } else if (calories < 200 && calories > 0) {
    return Colors.green[100];
  } else if (calories > 200 && calories < 600) {
    return Colors.yellow[100];
  } else if (calories > 600) {
    return Colors.red[100];
  } else {
    return Colors.black12;
  }
}

Color? evaluateDayCalories(List<Record> dayRecords) {
  int sum = calculateSumOfDayCalories(dayRecords);
  if (sum <= 1500) {
    return Colors.blue[50];
  } else if (sum <= 2000 && sum >= 1500) {
    return Colors.green[50];
  } else if (sum <= 2500 && sum >= 2000) {
    return Colors.yellow[50];
  } else {
    return Colors.red[50];
  }
}

int calculateSumOfDayCalories(List<Record> dayRecords) {
  int sum = 0;
  for (var dayRecord in dayRecords) {
    sum += dayRecord.calories;
  }
  return sum;
}
