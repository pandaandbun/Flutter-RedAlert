import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../Database/missing_person_database.dart';
import '../Database/saved_people_database.dart';

class SearchList extends StatelessWidget {
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');
  final MissingPeopleModel missingPeople = MissingPeopleModel();

  final name;

  SearchList(this.name);

  Person _buildPerson(BuildContext context, DocumentSnapshot data) {
    return Person.fromMap(data.data(), reference: data.reference);
  }

  void savePerson(
      scaffoldContext, String id, SavedPeopleModel savedPeopleModel) async {
    // var snackBar = SnackBar(content: Text('Saved'));
    SavedPerson person = SavedPerson(id);
    await savedPeopleModel.insertPeople(person);

    // if (result != null) {
    // snackBar = SnackBar(content: Text('One Of The Item Is Already Saved'));
    // }

    // Scaffold.of(context).showSnackBar(snackBar);
    Navigator.pop(scaffoldContext);
  }

  @override
  Widget build(BuildContext context) {
    final SavedPeopleModel savedPeopleModel =
        Provider.of<SavedPeopleModel>(context);

    return searchList(context, savedPeopleModel);
  }

  Widget searchList(scaffoldContext, savedPeopleModel) => Container(
      width: double.maxFinite,
      child: StreamBuilder(
        stream: missingPeople.getPersonWhereName(name),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              List people = snapshot.data.docs
                  .map((DocumentSnapshot document) =>
                      _buildPerson(context, document))
                  .toList();

              return ListView.builder(
                itemCount: people.length,
                itemBuilder: (BuildContext context, int index) =>
                    seachCard(scaffoldContext, people[index], savedPeopleModel),
              );
            }
          }
          return Text("Loading People Or No One Was Found");
        },
      ));

  Widget seachCard(
          scaffoldContext, Person person, SavedPeopleModel savedPeopleModel) =>
      Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(person.image),
              ),
              title: Text(person.firstName + " " + person.lastName),
              subtitle: Text(formatter.format(person.missingSince)),
              trailing: IconButton(
                icon: Icon(Icons.save),
                onPressed: () => savePerson(
                    scaffoldContext, person.reference.id, savedPeopleModel),
              ),
            ),
          ],
        ),
      );
}
