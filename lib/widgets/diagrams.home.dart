import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_fitness_app/model/record.dart';

class WeekBarChart extends StatelessWidget {
  const WeekBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Echarts(
        option: '''
      {
      xAxis: {
        type: 'time',
        data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
      },
      yAxis: {
        type: 'value'
      },
      series: [{
        data: [820, 932, 901, 934, 1290, 1330, 1320],
        type: 'line'
      }]
    }
      ''',
      ),
    );
  }
}

class EvaluateDayPerformance extends StatefulWidget {
  EvaluateDayPerformance({super.key});

  final recordsBox = Hive.box<Record>('recordsBox');

  double calculateTodayCalories(Box<Record> recordsBox) {
    double sum = 0;
    // print(
    //     'today records count: ${recordsBox.values.where((record) => record.dateOfEntry.day == DateTime.now().day).length}');
    recordsBox.values
        .where((record) => record.dateOfEntry.day == DateTime.now().day)
        .forEach((meal) {
      sum += meal.calories;
    });
    return sum;
  }

  @override
  State<EvaluateDayPerformance> createState() => _EvaluateDayPerformanceState();
}

class _EvaluateDayPerformanceState extends State<EvaluateDayPerformance> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.recordsBox.listenable(),
        builder: (context, recordsBox, _) =>
            Text(widget.calculateTodayCalories(recordsBox).toString()));
  }
}
