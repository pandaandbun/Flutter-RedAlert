import 'package:flutter/material.dart';
import 'Missing Person/missing_person_screen.dart';
import 'Map/map_screen.dart';
import 'Saved/saved_person_screen.dart';
import 'Charts/charts_screen.dart';

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
        '/charts':(context) => Charts(),
      },
    );
  }
}