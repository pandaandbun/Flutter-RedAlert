import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'missing_person_list_tile.dart';

import '../notification.dart';

import '../../Database/missing_person_database.dart';
import '../../Database/filter_by_date_model.dart';

class MissingPersonList extends StatelessWidget {
  final Random random = new Random();
  final Notifications _notifications;
  final notificationsNum;
  final SharedPreferences prefs;

  MissingPersonList(this._notifications, this.notificationsNum, this.prefs);

  void _notifyMissingPersonOfTheDay(Map person) async {
    if(prefs.getBool('notifications_featured') ?? false)
    await _notifications.sendNotificationNow(
        "Feature Person", person['firstName'] + " " + person['lastName'],
        payload: person['id'].toString());
  }

  @override
  Widget build(BuildContext context) {
    final MissingPeopleModel missingPeople =
        context.watch<MissingPeopleModel>();
    final DateModel dateModel = context.watch<DateModel>();
    Future future;

    DateTime filterByDate = dateModel.getDate();
    if (filterByDate != null) {
      // Filter List after selecting date
      future = missingPeople.getPersonWhereDate(filterByDate);
    } else {
      // list with everyone
      future = missingPeople.getAllPeople();
    }

    return _futureList(future);
  }

  // Wait for list from firebase
  Widget _futureList(Future future) => FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return errorText();
        } else if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            List people = snapshot.data;

            if (notificationsNum.num == 0) {
              int randomNumber = random.nextInt(people.length);
              Map randomPerson = people[randomNumber];

              notificationsNum.num++;
              _notifyMissingPersonOfTheDay(randomPerson);
            }

            return peopleList(people);
          } else {
            return errorText();
          }
        } else {
          return loadingText();
        }
      });

  Widget errorText() =>
      Text("No One Was Found", textDirection: TextDirection.ltr);

  Widget loadingText() => Text("Loading...", textDirection: TextDirection.ltr);

  Widget peopleList(List people) => Expanded(
        child: ListView.builder(
          itemCount: people.length,
          itemBuilder: (BuildContext context, int index) =>
              MissingPersonListTile(people[index], _notifications, prefs),
        ),
      );
}
