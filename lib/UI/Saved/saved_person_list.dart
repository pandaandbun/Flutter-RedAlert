import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Database/saved_people_database.dart';
import '../../Database/missing_person_database.dart';

import 'saved_person_list_tile.dart';

class SavedPersonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SavedPeopleModel savedPeopleModel = context.watch<SavedPeopleModel>();
    Future<List> savePeople = savedPeopleModel.getAllPeople();

    final MissingPeopleModel missingPeople = MissingPeopleModel();

    return FutureBuilder(
      future: savePeople,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List peopleIds = snapshot.data;

          return savedPersonListView(missingPeople, peopleIds);
        } else {
          return Text("Data Loading....");
        }
      },
    );
  }

  Widget savedPersonListView(missingPeople, peopleIds) => StreamBuilder(
      stream: missingPeople.getPeopleFromIds(peopleIds),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List people = [];

          for (var i = 0; i < snapshot.data.length; i++) {
            people.addAll(snapshot.data[i].docs);
          }

          return Expanded(
            child: ListView.separated(
              itemCount: people.length,
              itemBuilder: (BuildContext context, int index) =>
                  SavedPersonTile(people[index]),
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          );
        } else {
          return Text("Stream Loading....");
        }
      });
}
