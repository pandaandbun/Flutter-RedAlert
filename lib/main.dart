import 'package:Red_Alert/Settings/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Missing Person/missing_person_screen.dart';
import 'Map/map_screen.dart';
import 'Saved/saved_person_screen.dart';
import 'Charts/charts_screen.dart';

import 'Settings/settings.dart';
import 'Settings/profile.dart';
import 'Settings/password.dart';
import 'Settings/theme.dart';

import 'package:provider/provider.dart';
import 'Database/saved_people_database.dart';


void main() {  
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => SavedPeopleModel())],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context,snapshot) {
        if(snapshot.hasError) {
          return Text(
            "Error initializing database",
            textDirection: TextDirection.ltr
          );
        }
        else if(snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.red,
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
        }
        else {
          return Text(
            "Loading...",
            textDirection: TextDirection.ltr
          );
        }
      }
    );
  }
}
