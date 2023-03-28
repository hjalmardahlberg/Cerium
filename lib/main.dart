import 'package:flutter/material.dart';
import 'package:projecttest/logIn.dart';
import 'Homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'Tempus'),
    );
  }
}
