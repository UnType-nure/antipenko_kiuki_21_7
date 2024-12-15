import 'package:flutter/material.dart';
import 'widgets/students.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Students App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: StudentsScreen(),
    );
  }
}
