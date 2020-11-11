import 'package:flutter/material.dart';
import 'package:Red_Alert/drawer.dart';
import '../notification.dart';

class Settings extends StatefulWidget {
  @override
  SettingsPage createState() => SettingsPage();
}

class SettingsPage extends State<Settings> {
  bool _isOn1 = false;
  bool _isOn2 = false;
  bool _isOn3 = false;
  bool _isOn4 = false;

  @override
  Widget build(BuildContext context) {
    Notifications notification = new Notifications();
    return Scaffold(
        appBar: AppBar(title: Text('Settings')),
        drawer: DrawerMenu(),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(10),
                color: Colors.red,
                child: ListTile(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/profile');
                  },
                  title: Text('Profile'),
                  leading: Icon(Icons.person),
                  trailing: Icon(Icons.edit),
                )),
            const SizedBox(height: 10),
            Card(
              elevation: 8,
              margin: const EdgeInsets.fromLTRB(30, 5, 30, 5),
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
                if(value) {
                  notification.sendNotificationNow(
                    "Test Notification",
                    "This is an instant notification",
                    "Received"
                    );
                }
                setState(() {
                  _isOn1 = value;
                });
              },
              title: Text('Receive Notifications'),
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
              title: Text('Receive Notifications'),
              secondary:
                  const Icon(Icons.notification_important, color: Colors.red),
            ),
            SwitchListTile(
              activeColor: Colors.red,
              contentPadding: const EdgeInsets.all(0),
              value: _isOn3,
              onChanged: (bool value) {
                setState(() {
                  _isOn3 = value;
                });
              },
              title: Text('Receive Notifications'),
              secondary:
                  const Icon(Icons.notification_important, color: Colors.red),
            ),
            SwitchListTile(
              activeColor: Colors.red,
              contentPadding: const EdgeInsets.all(0),
              value: _isOn4,
              onChanged: (bool value) {
                setState(() {
                  _isOn4 = value;
                });
              },
              title: Text('Receive Notifications'),
              secondary:
                  const Icon(Icons.notification_important, color: Colors.red),
            ),
          ],
        )));
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
