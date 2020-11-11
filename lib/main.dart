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
import 'Database/selected_item_model.dart';

import 'notification.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:math';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SavedPeopleModel()),
      ChangeNotifierProvider(create: (_) => DateModel()),
      ChangeNotifierProvider(create: (_) => SelectedPeopleModel()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  //final _notifications = Notifications();
  @override
  
  Widget build(BuildContext context) {
    /*tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Detroit'));
    _notifications.init();
    _notifyDaily(_notifications);*/

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

  /*void _notifyDaily(_notifications) {
    _notifications.sendNotificationDaily('test daily', 'test body', tz.TZDateTime.parse(tz.getLocation('America/Detroit'), '2099-01-01 18:50:00'));
  }*/
}
