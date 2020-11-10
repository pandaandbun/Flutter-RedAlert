import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'Database/missing_person_database.dart';
import 'Database/saved_people_database.dart';

class Name {
  String firstName;
  String lastName;
}

class SearchBar extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final MissingPeopleModel missingPeople = MissingPeopleModel();
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');
  final Name name = Name();

  Future<void> _findPeople(scaffoldContext, savedPeopleModel) async {
    await showDialog(
        context: scaffoldContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('People Found'),
            content: searchList(scaffoldContext, savedPeopleModel),
          );
        });
  }

  Person _buildPerson(BuildContext context, DocumentSnapshot data) {
    return Person.fromMap(data.data(), reference: data.reference);
  }

  void savePerson(context, String id, SavedPeopleModel savedPeopleModel) async {
    var snackBar = SnackBar(content: Text('Saved'));
    SavedPerson person = SavedPerson(id);
    var result = await savedPeopleModel.insertPeople(person);

    if (result != null) {
      snackBar = SnackBar(content: Text('One Of The Item Is Already Saved'));
    }

    Navigator.pop(context);
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final SavedPeopleModel savedPeopleModel =
        Provider.of<SavedPeopleModel>(context);

    return Expanded(
        child: ExpansionTile(
      title: Icon(Icons.search),
      children: [
        searchForm(),
        saveBtn(context, savedPeopleModel),
      ],
    ));
  }

  Widget searchForm() => Form(
        key: _formKey,
        child: Container(
            width: 300,
            margin: EdgeInsets.only(left: 25, right: 25),
            child: Column(children: [firstNameForm(), lastNameForm()])),
      );

  Widget firstNameForm() => TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          hintText: 'John',
          hintStyle: TextStyle(color: Colors.grey),
          labelText: 'First Name',
          labelStyle: TextStyle(color: Colors.white),
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(),
        ),
        style: TextStyle(
          color: Colors.white,
        ),
        onSaved: (String value) => name.firstName = value,
      );

  Widget lastNameForm() => TextFormField(
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          hintText: 'Doe',
          hintStyle: TextStyle(color: Colors.grey),
          labelText: 'Last Name',
          labelStyle: TextStyle(color: Colors.white),
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(),
        ),
        style: TextStyle(
          color: Colors.white,
        ),
        onSaved: (String value) => name.lastName = value,
      );

  Widget saveBtn(context, savedPeopleModel) => RaisedButton(
        child: Icon(Icons.search),
        onPressed: () {
          _formKey.currentState.save();
          if (name.firstName.isNotEmpty || name.lastName.isNotEmpty) {
            _findPeople(context, savedPeopleModel);
          }
        },
      );

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

  Widget seachCard(context, Person person, SavedPeopleModel savedPeopleModel) =>
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
                onPressed: () =>
                    savePerson(context, person.reference.id, savedPeopleModel),
              ),
            ),
          ],
        ),
      );
}
