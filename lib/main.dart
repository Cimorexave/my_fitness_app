import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_fitness_app/model/record.dart';
import 'package:my_fitness_app/utils/mock.data.dart';
import 'pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.initFlutter();
  Hive.registerAdapter(RecordAdapter());
  Box<Record> box = await Hive.openBox<Record>('recordsBox');

  if (box.isEmpty) injectData(box);

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'my fittness app',
      home: HomePage(),
    );
  }
}
