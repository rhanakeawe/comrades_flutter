import 'package:Comrades/views/account.dart';
import 'package:Comrades/views/friends.dart';
import 'package:Comrades/views/home.dart';
import 'package:Comrades/views/settings.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarPage()
    );
  }
}