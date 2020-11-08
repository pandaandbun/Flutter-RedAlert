import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Database/missing_person_database.dart';
import '../Database/saved_people_database.dart';

class SavedPersonTile extends StatelessWidget {
  final doc;

  SavedPersonTile(this.doc);

  @override
  Widget build(BuildContext context) {
    final SavedPeopleModel savedPeopleModel =
        Provider.of<SavedPeopleModel>(context);

    Person person = Person.fromMap(doc.data(), reference: doc.reference);

    return ListTile(
      leading: Image.network(person.image),
      title: Text(person.firstName + " " + person.lastName),
      subtitle: Text(person.missingSince.toString()),
      trailing: delBtn(savedPeopleModel),
    );
  }

  Widget delBtn(SavedPeopleModel savedPeopleModel) => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          savedPeopleModel.deletePeopleId(doc.reference.id);
        },
      );
}
