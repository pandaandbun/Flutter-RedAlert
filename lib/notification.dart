import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  final channelId = 'testNotification';
  final channelName = 'Test Notification';
  final channelDescription = 'Test Notification Channel';

  var _flutterNotificationPlugin = FlutterLocalNotificationsPlugin();

  NotificationDetails _platformChannelInfo;
  var _notificationId = 100;

  void init() {
    var initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var initSettings =
        InitializationSettings(android: initSettingsAndroid);

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

  Future onSelectNotification(var payload) async {
    if (payload != null) {
      print("onSelectNotification::payload = $payload");
    }
  }
  Future<void> sendNotificationNow(String title, String body, String payload) async {
    _flutterNotificationPlugin.show(
      _notificationId++, 
      title, 
      body, 
      _platformChannelInfo, 
      payload: payload,
    );
  }
}
