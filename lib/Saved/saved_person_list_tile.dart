import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../Database/missing_person_database.dart';
import '../Database/saved_people_database.dart';

class SavedPersonTile extends StatelessWidget {
  final doc;
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');

  SavedPersonTile(this.doc);

  @override
  Widget build(BuildContext context) {
    final SavedPeopleModel savedPeopleModel =
        Provider.of<SavedPeopleModel>(context);

    Person person = Person.fromMap(doc.data(), reference: doc.reference);

    return personCard(person, savedPeopleModel);
  }

  Widget delBtn(SavedPeopleModel savedPeopleModel) => RaisedButton(
        child: Icon(Icons.delete),
        color: Colors.red[200],
        onPressed: () {
          savedPeopleModel.deletePeopleId(doc.reference.id);
        },
      );

  Widget personCard(Person person, SavedPeopleModel savedPeopleModel) => Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: personCardImage(person),
                subtitle: personCardText(person, savedPeopleModel)),
          ],
        ),
        color: Colors.brown,
      );

  Widget personCardImage(Person person) => ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          person.image,
          fit: BoxFit.fill,
        ),
      );

  Widget personCardText(Person person, SavedPeopleModel savedPeopleModel) =>
      Column(
        children: [
        SizedBox(height: 10),
        Text(
          person.firstName + " " + person.lastName,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 10),
        Text(
          formatter.format(person.missingSince),
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 10),
        Text(
          person.city + " " + person.province,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 10),
        delBtn(savedPeopleModel),
      ]);
}
