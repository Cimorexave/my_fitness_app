import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_fitness_app/model/record.dart';
import 'pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.initFlutter();
  Hive.registerAdapter(RecordAdapter());
  await Hive.openBox<Record>('recordsBox');

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
