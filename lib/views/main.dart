import 'package:firebase_core/firebase_core.dart';
import 'package:Comrades/views/home.dart';
import 'package:flutter/material.dart';
import 'package:Comrades/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors during initialization
          if (snapshot.hasError) {
            return Center(
              child: Text('Error initializing Firebase: ${snapshot.error}'),
            );
          }

          // Show a loading spinner while waiting for initialization to complete
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Once complete, show the main content
          return const CalendarPage();
        },
      ),
    );
  }
}
