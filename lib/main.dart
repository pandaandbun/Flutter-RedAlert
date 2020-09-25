import 'package:flutter/material.dart';
import 'missing_person_screen.dart';
import 'map_screen.dart';
import 'saved_person_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MissingPerson(),
        '/map': (context) => MapView(),
        '/saved': (context) => SavedPerson(),
      },
    );
  }
}
