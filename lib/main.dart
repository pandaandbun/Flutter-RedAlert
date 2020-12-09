import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'UI/Missing Person/missing_person_screen.dart';
import 'UI/Map/map_screen.dart';
import 'UI/Saved/saved_person_screen.dart';
import 'UI/Breakdown/breakdown_screen.dart';
import 'UI/Sync/sync_screen.dart';

import 'UI/Settings/settings.dart';
import 'UI/Settings/profile.dart';
import 'UI/Settings/theme.dart';

import 'Database/saved_people_database.dart';
import 'Database/filter_by_date_model.dart';
import 'Database/selected_item_model.dart';
import 'Database/missing_person_database.dart';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
        useCountryCode: false,
        fallbackFile: 'en',
        basePath: 'assets/flutter_i18n',),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await flutterI18nDelegate.load(null);
  runApp(MultiProvider(
    providers: [
      // Listener for when the Local DB is synced
      ChangeNotifierProvider(create: (_) => MissingPeopleModel()),
      // Listener for when someone is saved
      ChangeNotifierProvider(create: (_) => SavedPeopleModel()),
      // Listener for when a date to filter by is picked
      ChangeNotifierProvider(create: (_) => DateModel()),
      // Listener for when people are save and to deselect them
      ChangeNotifierProvider(create: (_) => SelectedPeopleModel()),
    ],
    child: MyApp(flutterI18nDelegate),
  ));
}

class MyApp extends StatelessWidget {
  // final MissingPeopleModel missingPeopleModel = MissingPeopleModel();
  final FlutterI18nDelegate flutterI18nDelegate;
  MyApp(this.flutterI18nDelegate);
  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();

    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              "Error initializing database",
              textDirection: TextDirection.ltr,
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            // Main
            return _checkIfDbIsEmpty();
          } else {
            // Before Start up loading Screen
            return _loadingIcon();
          }
        });
  }

  Widget _checkIfDbIsEmpty() {
    MissingPeopleModel missingPeopleModel = MissingPeopleModel();
    return FutureBuilder(
        future: missingPeopleModel.isDbEmpty(),
        builder: (_, dbSnapshot) {
          if (dbSnapshot.hasData) {
            if (dbSnapshot.data) {
              return _startingPageIs("sync");
            } else {
              return _startingPageIs("missing");
            }
          } else {
            // Waiting for if local DB is empty
            return _loadingIcon();
          }
        });
  }

  Widget _loadingIcon() => Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: Colors.white,
          ),
          Text("Loading"),
        ],
      )));

  Widget _startingPageIs(String main) => MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        initialRoute: '/' + main,
        routes: {
          '/sync': (context) => SyncScreen(),
          '/missing': (context) => MissingPerson(),
          '/map': (context) => MapScreen(),
          '/saved': (context) => SavedPersonScreen(),
          '/charts': (context) => Breakdown(),
          '/settings': (context) => Settings(),
          '/profile': (context) => Profile(),
          '/theme': (context) => ThemeP(),
        },
        localizationsDelegates: [
          flutterI18nDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('fr'),
        ],
      );
}
