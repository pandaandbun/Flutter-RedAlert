import 'package:flutter/material.dart';
import 'package:Red_Alert/UI/drawer.dart';
import '../notification.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/tutorial_database.dart';

class Settings extends StatefulWidget {
  final SharedPreferences prefs; //used to get stored settings
  Settings(this.prefs);
  @override
  SettingsPage createState() => SettingsPage(prefs);
}

class SettingsPage extends State<Settings> {
  final SharedPreferences prefs;

  SettingsPage(this.prefs);
  @override
  Widget build(BuildContext context) {
    //initialize notifications and tutorial screens
    Notifications notification = new Notifications();
    notification.init();
    TutorialModel tutorialModel = TutorialModel();

    return Scaffold(
        appBar: AppBar(title: Text(FlutterI18n.translate(context, "settings.title"))),
        drawer: DrawerMenu(),
        backgroundColor: Colors.brown[900],
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(25, 5, 25, 5),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _languageSettings(), //widget for language settings
                _notificationSettings(notification), //widget for notification settings
                _tutorialSettings(tutorialModel), //widget for tutorial settings
              ],
            )
          )
        )
    );
  }

  // -- Language Settings --
  //options: english and french
  Widget _languageSettings() => Container(
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Colors.brown,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(color: Colors.brown[300], spreadRadius: 3),
      ],
    ),
    margin: EdgeInsets.fromLTRB(0,20,0,15),
    child: Column(
      children: <Widget>[
        Text(
          FlutterI18n.translate(context, "settings.language"), //section header
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Column(
          children: <Widget> [

            // -- English --
            SizedBox(
              width: double.infinity,
              child: OutlineButton(
                color: Colors.brown[900],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget> [
                    Text(
                      'English',
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Colors.white),
                    ),
                    //display checkbox if language is selected
                    (prefs.getString('language')=="en") ? Icon(Icons.check, color:Colors.white) : Text(""),
                  ]
                ),
                shape: RoundedRectangleBorder(  
                  borderRadius: BorderRadius.circular(15)),
                onPressed: () async {
                  //set the stored language and current locale to english
                  print('Language Select: English');
                  prefs.setString("language", "en"); //set stored language
                  Locale newLocale = Locale('en'); //set current locale
                  await FlutterI18n.refresh(context, newLocale);
                  setState(() {});
                },
              )
            ),

            // -- French --
            SizedBox(
              width: double.infinity,
              child: OutlineButton(
                color: Colors.brown[900],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget> [
                    Text(
                    'Français',
                    textScaleFactor: 1.2,
                    style: TextStyle(color: Colors.white),
                    ),
                    //display checkbox if language is selected
                    (prefs.getString('language')=="fr") ? Icon(Icons.check, color:Colors.white) : Text(""), 
                  ]
                ),
                shape: RoundedRectangleBorder(  
                  borderRadius: BorderRadius.circular(15)),
                onPressed: () async {
                  //set the stored language and current locale to french
                  print('Language Select: French');
                  prefs.setString("language", "fr"); //set stored language
                  Locale newLocale = Locale('fr'); //set current locale
                  await FlutterI18n.refresh(context, newLocale);
                  setState(() {});
                },
              )
            ),
          ]
        ),
      ]
    )
  );

  // -- Notification Settings --
  //options: scheduled notifications and featured persons notifications
  Widget _notificationSettings(Notifications notification) => Container(
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Colors.brown,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(color: Colors.brown[300], spreadRadius: 3),
      ],
    ),
    margin: EdgeInsets.fromLTRB(0,15,0,15),
    child: Column(
      children: <Widget> [
        Text(
          FlutterI18n.translate(context, "settings.notifications.title"), //header
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // -- Scheduled Notifications --
        SwitchListTile(
          activeColor: Colors.white,
          contentPadding: const EdgeInsets.all(0),
          value: prefs.getBool('notifications_scheduled') ?? true,
          onChanged: (bool value) {
            setState(() {
              prefs.setBool("notifications_scheduled", value);
            });
          },
          title: Text(
            FlutterI18n.translate(context, "settings.notifications.scheduled"),
            textScaleFactor: 1.1,
            style: TextStyle(color: Colors.white)
          ),
        ),

        // -- Featured Persons Notifications --
        SwitchListTile(
          activeColor: Colors.white,
          contentPadding: const EdgeInsets.all(0),
          value: prefs.getBool('notifications_featured') ?? true,
          onChanged: (bool value) {
            setState(() {
              prefs.setBool("notifications_featured", value);
            });
          },
          title: Text(
            FlutterI18n.translate(context, "settings.notifications.featured"),
            textScaleFactor: 1.1,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ]
    )
  );

  // -- Tutorial Settings --
  //options: enable or disable tutorials
  Widget _tutorialSettings(TutorialModel tutorialModel) => Container(
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Colors.brown,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(color: Colors.brown[300], spreadRadius: 3),
      ],
    ),
    margin: EdgeInsets.fromLTRB(0,15,0,15),
    child: Column(
      children: <Widget> [
        Text(
          FlutterI18n.translate(context, "settings.tutorial.title"), //header
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // -- Tutorials On/Off --
        SwitchListTile(
          activeColor: Colors.white,
          contentPadding: const EdgeInsets.all(0),
          value: prefs.getBool('tutorial_on') ?? false,
          onChanged: (bool value) {
            setState(() {
              if(value) {
                tutorialModel.turnOnAllTutorials();
                prefs.setBool('tutorial_on', true);
              }
              else {
                tutorialModel.turnOffAllTutorials();
                prefs.setBool('tutorial_on', false);
              }
            });
          },
          title: Text(
            FlutterI18n.translate(context, "settings.tutorial.text"),
            textScaleFactor: 1.1,
            style: TextStyle(color: Colors.white)
          ),
        ),
      ]
    )
  );
}