import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'missing_person_list_tile.dart';

import '../notification.dart';

import '../../Database/missing_person_database.dart';
import '../../Database/filter_by_date_model.dart';

class MissingPersonList extends StatelessWidget {
  final savedPeople;
  final Random random = new Random();
  final Notifications _notifications;
  final notificationsNum;

  MissingPersonList(
      this.savedPeople, this._notifications, this.notificationsNum);

  Person _buildPerson(DocumentSnapshot data) {
    return Person.fromMap(data.data(), reference: data.reference);
  }

  void _notifyMissingPersonOfTheDay(Person person) async {
    await _notifications.sendNotificationNow(
      "Feature Person",
      person.firstName + " " + person.lastName,
      payload: person.reference.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final MissingPeopleModel missingPeople = MissingPeopleModel();
    final DateModel dateModel = context.watch<DateModel>();
    Stream stream;

    DateTime filterByDate = dateModel.getDate();
    if (filterByDate != null) {
      // Filter List after selecting date
      stream = missingPeople.getPersonWhereDate(filterByDate);
    } else {
      // list with everyone
      stream = missingPeople.getAllPeople();
    }

    return streamList(stream);
  }

  // Wait for list from firebase
  Widget streamList(stream) => StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return errorText();
        } else if (snapshot.hasData) {
          if (snapshot.data.docs.length > 0) {
            List people = snapshot.data.docs
                .map((DocumentSnapshot document) => _buildPerson(document))
                .toList();

            if (notificationsNum.num == 0) {
              int randomNumber = random.nextInt(people.length);
              Person randomPerson = people[randomNumber];

              _notifyMissingPersonOfTheDay(randomPerson);
              notificationsNum.num++;
            }

            return peopleList(people);
          } else {
            return errorText();
          }
        } else {
          return errorText();
        }
      });

  Widget errorText() =>
      Text("Error building list", textDirection: TextDirection.ltr);

  Widget elseText() => Text("Loading...", textDirection: TextDirection.ltr);

  Widget peopleList(List people) => Expanded(
        child: ListView.builder(
          itemCount: people.length,
          itemBuilder: (BuildContext context, int index) =>
              MissingPersonListTile(people[index], _notifications),
        ),
      );
}
