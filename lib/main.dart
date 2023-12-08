import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_fitness_app/model/profile.dart';
import 'package:my_fitness_app/model/record.dart';
import 'package:my_fitness_app/utils/mock.data.dart';
import 'package:path_provider/path_provider.dart';
import 'pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (Platform.isAndroid || Platform.isIOS) {
  //   final Directory appDocumentDir = await getApplicationDocumentsDirectory();
  //   Hive.init(appDocumentDir.path);
  // } else {
  //   Hive.initFlutter();
  // }
  Hive.initFlutter();

  Hive.registerAdapter(RecordAdapter());
  Hive.registerAdapter(ProfileAdapter());
  Hive.registerAdapter(ActivityLevelAdapter());

  Box<Record> recordsBox = await Hive.openBox<Record>('recordsBox');
  await Hive.openBox<Profile>('profileBox');

  if (recordsBox.isEmpty) injectData(recordsBox);

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
      debugShowCheckedModeBanner: false,
      title: 'my fittness app',
      home: HomePage(),
    );
  }
}
