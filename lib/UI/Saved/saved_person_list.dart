import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Database/saved_people_database.dart';
import '../../Database/missing_person_database.dart';

import 'saved_person_list_tile.dart';

class SavedPersonList extends StatelessWidget {
  final MissingPeopleModel missingPeople = MissingPeopleModel();

  @override
  Widget build(BuildContext context) {
    final SavedPeopleModel savedPeopleModel = context.watch<SavedPeopleModel>();

    return FutureBuilder(
      future: savedPeopleModel.getAllSavedPeople(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Set<String> peopleIds =
              snapshot.data.map((e) => e['id'].toString()).toSet().cast<String>();

          return savedPersonListView(peopleIds);
        } else {
          return Text("Data Loading or Data is Empty");
        }
      },
    );
  }

  Widget savedPersonListView(Set<String> peopleIds) => FutureBuilder(
      future: missingPeople.getPeopleFromIds(peopleIds),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List people = snapshot.data;

          return Expanded(
            child: ListView.separated(
              itemCount: people.length,
              itemBuilder: (BuildContext context, int index) =>
                  SavedPersonTile(people[index]),
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
          );
        } else {
          return Text("Data Loading....");
        }
      });
}
