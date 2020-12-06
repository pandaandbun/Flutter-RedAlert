import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Database/missing_person_database.dart';

// Based on Randy's Lecture Code
class Notifications {
  final channelId = 'testNotification';
  final channelName = 'Test Notification';
  final channelDescription = 'Test Notification Channel';
  final MissingPeopleModel missingPeople = MissingPeopleModel();
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

  // ---------------------------------------------------------

  Future onSelectNotification(String payload) async {
    if (payload.isNotEmpty && sent) {
      Future personFuture = missingPeople.getPeopleFromId(payload);
      await _notificationDialog(personFuture);
    }
  }

  Future _notificationDialog(Future personFuture) => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.brown,
          title: _dialogTitle(),
          content: _missingPersonOfTheyDay(personFuture),
          actions: [_dialogBtn()],
        ),
      );

  Widget _dialogTitle() => Text(
        "Feature Person",
        style: TextStyle(color: Colors.white),
      );

  Widget _dialogBtn() => TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "OK",
          style: TextStyle(color: Colors.blue[300]),
        ),
      );

  // ---------------------------------------------------------

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

  // ---------------------------------------------------------

  Widget _missingPersonOfTheyDay(Future personFuture) => FutureBuilder(
      future: personFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return _missingPersonOfTheDayContent(snapshot.data[0]);
          } else {
            return Text("No Data");
          }
        } else {
          return Text("Fetching Data");
        }
      });

  Widget _missingPersonOfTheDayContent(Map person) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');
    String url = person['image'];
    String name = person['firstName'] + " " + person['lastName'];
    String missingSince =
        formatter.format(DateTime.parse(person['missingSince']));
    String lastKnownLoc = person['city'] + ", " + person['province'];

    return Column(mainAxisSize: MainAxisSize.min, children: [
      _dialogImg(url),
      SizedBox(height: 10),
      _dialogName(name),
      SizedBox(height: 10),
      _dialogDate(missingSince),
      _dialogLoc(lastKnownLoc),
    ]);
  }

  Widget _dialogImg(String url) => Image.network(
        url,
        errorBuilder: (context, exception, stacktrace) => Icon(Icons.error),
      );

  Widget _dialogName(String name) => Text(
        name,
        style: TextStyle(color: Colors.white, fontSize: 20),
        textAlign: TextAlign.center,
      );

  Widget _dialogDate(String missingSince) => Text(
        "Missing Since: " + missingSince,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      );

  Widget _dialogLoc(String lastKnownLoc) => Text(
        "Last Known Location: " + lastKnownLoc,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      );
}
