import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'Missing Person/missing_person_screen.dart';
import 'Map/map_screen.dart';
import 'Saved/saved_person_screen.dart';
import 'Charts/charts_screen.dart';

import 'Settings/settings.dart';
import 'Settings/profile.dart';
import 'Settings/password.dart';
import 'Settings/theme.dart';

import 'Database/saved_people_database.dart';
import 'Database/filter_by_date_model.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SavedPeopleModel()),
      ChangeNotifierProvider(create: (_) => DateModel()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error initializing database",
                textDirection: TextDirection.ltr);
          } else if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              theme: ThemeData(
                primarySwatch: Colors.brown,
              ),
              initialRoute: '/',
              routes: {
                '/': (context) => MissingPerson(),
                '/map': (context) => MapView(),
                '/saved': (context) => SavedPersonScreen(),
                '/charts': (context) => Charts(),
                '/settings': (context) => Settings(),
                '/profile': (context) => Profile(),
                '/password': (context) => Password(),
                '/theme': (context) => ThemeP(),
              },
            );
          } else {
            return Text("Loading...", textDirection: TextDirection.ltr);
          }
        });
  }
}
