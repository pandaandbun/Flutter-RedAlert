import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'missing_person_list_tile.dart';

import '../Database/missing_person_database.dart';
import '../Database/filter_by_date_model.dart';

// import '../notification.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// import 'dart:math';

class MissingPersonList extends StatelessWidget {
  final savedPeople;
  // final _notifications = Notifications();

  MissingPersonList(this.savedPeople);

  Person _buildPerson(BuildContext context, DocumentSnapshot data) {
    return Person.fromMap(data.data(), reference: data.reference);
  }

  @override
  Widget build(BuildContext context) {
    final MissingPeopleModel missingPeople = MissingPeopleModel();
    final DateModel dateModel = context.watch<DateModel>();
    Stream stream;
    
    // _notifications.init();
    
    /*final _notifications = Notifications();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Detroit'));
    _notifications.init();*/

    DateTime filterByDate = dateModel.getDate();
    if (filterByDate != null) {
      stream = missingPeople.getPersonWhereDate(filterByDate);
    } else {
      stream = missingPeople.getAllPeople();
    }

    return streamList(stream);
  }

  Widget streamList(stream) => StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return errorText();
        } else if (snapshot.hasData) {
          List people = snapshot.data.docs
              .map((DocumentSnapshot document) =>
                  _buildPerson(context, document))
              .toList();
          return peopleList(snapshot, people);
        } else {
          return elseText();
        }
      });

  Widget errorText() =>
      Text("Error building list", textDirection: TextDirection.ltr);

  Widget elseText() => Text("Loading...", textDirection: TextDirection.ltr);

  Widget peopleList(snapshot, people) => Expanded(
        child: ListView.builder(
          itemCount: snapshot.data.size,
          itemBuilder: (BuildContext context, int index) =>
              MissingPersonListTile(people[index]),
        ),
      );

  // void _notifyFeaturedPerson(_notifications, persons) {
  //   print("activated");
  //   int count = persons.length();
  //   var random = new Random();
  //   int index = random.nextInt(count);
  //   Person person = persons[index];

  //   _notifications.sendNotificationDaily(
  //     'Highlighted Missing Person', 
  //     '{$person.firstName} {$person.lastName} is still missing, last seen in {$person.city}, {$person.province}',
  //     tz.TZDateTime.parse(tz.getLocation('America/Detroit'), '2099-01-01 23:35:00'));
  // }
}
