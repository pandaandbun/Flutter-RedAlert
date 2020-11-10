import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'missing_person_list_tile.dart';
import '../Database/missing_person_database.dart';

class MissingPersonList extends StatelessWidget {
  final savedPeople;

  MissingPersonList(this.savedPeople);

  Person _buildPerson(BuildContext context, DocumentSnapshot data) {
    return Person.fromMap(data.data(), reference: data.reference);
  }

  @override
  Widget build(BuildContext context) {
    final MissingPeopleModel missingPeople = MissingPeopleModel();

    return StreamBuilder(
        stream: missingPeople.getAllPeople(),
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
  }

  Widget errorText() =>
      Text("Error building list", textDirection: TextDirection.ltr);

  Widget elseText() => Text("Loading...", textDirection: TextDirection.ltr);

  Widget peopleList(snapshot, people) => Expanded(
        child: ListView.builder(
          itemCount: snapshot.data.size,
          itemBuilder: (BuildContext context, int index) =>
              MissingPersonListTile(
            people[index],
            savedPeople,
          ),
        ),
      );
}
