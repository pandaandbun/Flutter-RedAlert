import 'package:flutter/material.dart';
import 'package:Red_Alert/UI/drawer.dart';
import '../notification.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  final SharedPreferences prefs;
  Settings(this.prefs);
  @override
  SettingsPage createState() => SettingsPage(prefs);
}

class SettingsPage extends State<Settings> {
  final SharedPreferences prefs;
  bool _isOn1 = false;
  bool _isOn2 = false;
  bool _isOn3 = false;
  bool _isOn4 = false;

  SettingsPage(this.prefs);
  @override
  Widget build(BuildContext context) {
    Notifications notification = new Notifications();
    notification.init();

    return Scaffold(
        appBar: AppBar(title: Text(FlutterI18n.translate(context, "settings.title"))),
        drawer: DrawerMenu(),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(25, 5, 25, 5),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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
                const SizedBox(height: 20),
                Text(
                  "Language Settings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Column(
                  children: <Widget> [
                    SizedBox(
                      width: double.infinity,
                      child: OutlineButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget> [
                            Text(
                              'English',
                              textScaleFactor: 1.2,
                            ),
                            (prefs.getString('language')=="en") ? Icon(Icons.check) : Text(""), //update this to actually check language
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget> [
                            Text(
                            'French',
                            textScaleFactor: 1.2,
                            ),
                            (prefs.getString('language')=="fr") ? Icon(Icons.check) : Text(""), //update this to actually check language
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
                const SizedBox(height: 20),
                Text(
                  "Notification Settings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SwitchListTile(
                  activeColor: Colors.red,
                  contentPadding: const EdgeInsets.all(0),
                  value: _isOn1,
                  onChanged: (bool value) {
                    if (value) {
                      notification.sendNotificationNow(
                        "Test Notification",
                        "This is an instant notification",
                        // "Received"
                      );
                    }
                    setState(() {
                      _isOn1 = value;
                    });
                  },
                  title: Text('Instant Notifications'),
                  secondary:
                      const Icon(Icons.notification_important, color: Colors.red),
                ),
                SwitchListTile(
                  activeColor: Colors.red,
                  contentPadding: const EdgeInsets.all(0),
                  value: _isOn2,
                  onChanged: (bool value) {
                    setState(() {
                      _isOn2 = value;
                    });
                  },
                  title: Text('Featured Persons'),
                  secondary:
                      const Icon(Icons.notification_important, color: Colors.red),
                ),
              ],
            )
          )
        )
    );
  }
}

class _solidLine extends StatelessWidget {
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
}
