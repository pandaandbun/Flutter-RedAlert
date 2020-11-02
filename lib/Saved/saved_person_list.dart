import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Database/saved_people_database.dart';
import '../Database/missing_person_database.dart';

class SavedPersonList extends StatefulWidget {
  @override
  _SavedPersonListState createState() => _SavedPersonListState();
}

class _SavedPersonListState extends State<SavedPersonList> {
  @override
  Widget build(BuildContext context) {
    final PeopleModel peopleModel = context.watch<PeopleModel>();
    Future<List> people = peopleModel.getAllPeople();

    return FutureBuilder(
      future: people,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List peopleIds = snapshot.data;
          return savedPersonGridView(peopleIds);
        } else {
          return Text("Data Loading....");
        }
      },
    );
  }
}

Widget savedPersonGridView(peopleIds) => Expanded(
    child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: peopleIds.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> person = findMap(peopleIds[index]['id']);
          return ListTile(
              leading: Image.network(person['image']),
              title: Text(person['firstName'] + " " + person['lastName']),
              subtitle: Text(person['missingSince'].toString()));
        }));

Map<String, dynamic> findMap(int id) {
  for (var person in people) {
    if (person['id'] == id) {
      return person;
    }
  }

  return null;
}
