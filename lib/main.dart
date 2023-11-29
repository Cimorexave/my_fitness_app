import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => SharedState(),
    child: const MainApp(),
  ));
}

class SharedState with ChangeNotifier {
  final Map<String, String?> _formState = {
    'title': null,
    'calories': null,
    'description': null,
  };

  Map<String, String?> get formState => _formState;
  void setForm(Map<String, String> newFormState) {
    _formState["title"] = newFormState["title"];
    _formState["calories"] = newFormState["calories"];
    _formState["description"] = newFormState["description"];

    notifyListeners();
  }
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
