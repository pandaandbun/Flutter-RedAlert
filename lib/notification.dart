import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Database/missing_person_database.dart' as db;

// Based on Randy's Lecture Code
class Notifications {
  final channelId = 'testNotification';
  final channelName = 'Test Notification';
  final channelDescription = 'Test Notification Channel';
  final db.MissingPeopleModel missingPeople = db.MissingPeopleModel();
  BuildContext context;
  bool sent = false;

  var _flutterNotificationPlugin = FlutterLocalNotificationsPlugin();

  NotificationDetails _platformChannelInfo;
  var _notificationId = 100;

  void init({BuildContext scaffoldContext}) {
    context = scaffoldContext;

    var initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var initSettings = InitializationSettings(android: initSettingsAndroid);

    _flutterNotificationPlugin.initialize(
      initSettings,
      onSelectNotification: onSelectNotification,
    );

    var androidChannelInfo = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ticker: 'ticker',
    );

    _platformChannelInfo = NotificationDetails(
      android: androidChannelInfo,
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload.isNotEmpty && sent) {
      Stream<QuerySnapshot> personStream =
          missingPeople.getPeopleFromId(payload);

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.brown,
          title: Text(
            "Feature Person",
            style: TextStyle(color: Colors.white),
          ),
          content: _missingPersonOfTheyDayStream(personStream),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "OK",
                style: TextStyle(color: Colors.blue[300]),
              ),
            )
          ],
        ),
      );
    }
  }

  sendNotificationNow(String title, String body, {String payload}) {
    sent = true;
    _flutterNotificationPlugin.show(
      _notificationId++,
      title,
      body,
      _platformChannelInfo,
      payload: payload,
    );
  }

  // sendNotificationDaily(String title, String body, DateTime date,
  //     {String payload}) {
  //   _flutterNotificationPlugin.zonedSchedule(
  //     1,
  //     'Test',
  //     'Daily Notification',
  //     date,
  //     _platformChannelInfo,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //     androidAllowWhileIdle: true,
  //   );
  // }

  sendNotificationLater(int id, String title, String body, tz.TZDateTime when,
      {String payload}) {
    sent = true;
    _flutterNotificationPlugin.zonedSchedule(
      //_notificationId++,
      id,
      title,
      body,
      when,
      _platformChannelInfo,
      payload: payload,
      uiLocalNotificationDateInterpretation: null,
      androidAllowWhileIdle: true,
    );
  }
}

Widget _missingPersonOfTheyDayStream(Stream personStream) => StreamBuilder(
    stream: personStream,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data.docs.length > 0) {
          db.Person person = db.Person.fromMap(
            snapshot.data.docs[0].data(),
            reference: snapshot.data.docs[0].reference,
          );

          return _missingPersonOfTheDayContent(person);
        } else {
          return Text("No Data");
        }
      } else {
        return Text("Fetching Data");
      }
    });

Widget _missingPersonOfTheDayContent(db.Person person) {
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');

  return Column(mainAxisSize: MainAxisSize.min, children: [
    Image.network(person.image),
    SizedBox(
      height: 10,
    ),
    Text(
      person.firstName + " " + person.lastName,
      style: TextStyle(color: Colors.white, fontSize: 20),
      textAlign: TextAlign.center,
    ),
    SizedBox(
      height: 10,
    ),
    Text(
      "Missing Since: " + formatter.format(person.missingSince),
      style: TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
    ),
    Text(
      "Last Known Location: " + person.city + ", " + person.province,
      style: TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
    ),
  ]);
}
