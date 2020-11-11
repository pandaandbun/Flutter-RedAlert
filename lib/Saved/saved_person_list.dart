import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Database/saved_people_database.dart';
import '../Database/missing_person_database.dart';

import 'saved_person_list_tile.dart';

class SavedPersonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SavedPeopleModel peopleModel = context.watch<SavedPeopleModel>();
    Future<List> people = peopleModel.getAllPeople();

    final MissingPeopleModel missingPeople = MissingPeopleModel();

    return FutureBuilder(
      future: people,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List peopleIds = snapshot.data;

          return savedPersonGridView(missingPeople, peopleIds);
        } else {
          return Text("Data Loading....");
        }
      },
    );
  }
}

Widget savedPersonGridView(missingPeople, peopleIds) => StreamBuilder(
    stream: missingPeople.getPeopleFromIds(peopleIds),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List people = [];

        for (var i = 0; i < snapshot.data.length; i++) {
          people.addAll(snapshot.data[i].docs);
        }

        return Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: people.length,
                itemBuilder: (BuildContext context, int index) =>
                    SavedPersonTile(people[index])));
      } else {
        return Text("Stream Loading....");
      }
    });
