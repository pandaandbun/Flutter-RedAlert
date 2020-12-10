import 'package:flutter/material.dart';
import 'package:Red_Alert/UI/drawer.dart';
import '../notification.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/tutorial_database.dart';

class Settings extends StatefulWidget {
  final SharedPreferences prefs;
  Settings(this.prefs);
  @override
  SettingsPage createState() => SettingsPage(prefs);
}

class SettingsPage extends State<Settings> {
  final SharedPreferences prefs;

  SettingsPage(this.prefs);
  @override
  Widget build(BuildContext context) {
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
                _languageSettings(),
                _notificationSettings(notification),
                _tutorialSettings(tutorialModel),
              ],
            )
          )
        )
    );
  }

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
          FlutterI18n.translate(context, "settings.language"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Column(
          children: <Widget> [
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
                    (prefs.getString('language')=="en") ? Icon(Icons.check, color:Colors.white) : Text(""),
                  ]
                ),
                shape: RoundedRectangleBorder(  
                  borderRadius: BorderRadius.circular(15)),
                onPressed: () async {
                  print('Language Select: English');
                  prefs.setString("language", "en");
                  Locale newLocale = Locale('en');
                  await FlutterI18n.refresh(context, newLocale);
                  setState(() {});
                },
              )
            ),
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
                    (prefs.getString('language')=="fr") ? Icon(Icons.check, color:Colors.white) : Text(""), 
                  ]
                ),
                shape: RoundedRectangleBorder(  
                  borderRadius: BorderRadius.circular(15)),
                onPressed: () async {
                  print('Language Select: French');
                  prefs.setString("language", "fr");
                  Locale newLocale = Locale('fr');
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
          FlutterI18n.translate(context, "settings.notifications.title"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
          //secondary: const Icon(Icons.notification_important, color: Colors.red),
        ),
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
          //secondary:
              //const Icon(Icons.notification_important, color: Colors.red),
        ),
      ]
    )
  );

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
          FlutterI18n.translate(context, "settings.tutorial.title"),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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

/*class _solidLine extends StatelessWidget {
  const _solidLine({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: 1,
      color: Colors.grey,
    );
  }
}*/

/*
const SizedBox(height: 10),
Card(
  elevation: 8,
  margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)),
  child: Column(
    children: <Widget>[
      ListTile(
        leading: Icon(
          Icons.lock_outline,
          color: Colors.red,
        ),
        title: Text('Change Password'),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.red,
        ),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/password');
        },
      ),
      _solidLine(),
      ListTile(
        leading: Icon(
          Icons.brightness_medium,
          color: Colors.red,
        ),
        title: Text('Change Theme'),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.red,
        ),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/theme');
        },
      ),
    ],
  ),
),
*/


