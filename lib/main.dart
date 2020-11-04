import 'package:Red_Alert/Settings/profile.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    // FlutterLocalNotificationsPlugin();

void main() {  
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => PeopleModel())],
    child: MyApp(),
  ));
}

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
        '/charts': (context) => Charts(),
        '/settings': (context) => Settings(),
        '/profile': (context) => Profile(),
        '/password': (context) => Password(),
        '/theme': (context) => ThemeP(),
      },
    );
  }
}
