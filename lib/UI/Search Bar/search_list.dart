import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Database/missing_person_database.dart';
import '../../Database/saved_people_database.dart';

class SearchList extends StatelessWidget {
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');
  final MissingPeopleModel missingPeople = MissingPeopleModel();

  final String name;

  SearchList(this.name);

  // Save person to Saved Person Screen
  void savePerson(
      scaffoldContext, String id, SavedPeopleModel savedPeopleModel) async {
    SavedPerson person = SavedPerson(id);
    await savedPeopleModel.insertPeople(person);

    Navigator.pop(scaffoldContext);
  }

  // --------------------------------------

  @override
  Widget build(BuildContext context) {
    final SavedPeopleModel savedPeopleModel =
        Provider.of<SavedPeopleModel>(context);

    return searchList(savedPeopleModel);
  }

  // --------------------------------------

  // List response
  Widget searchList(savedPeopleModel) => Container(
      width: double.maxFinite,
      child: FutureBuilder(
        future: missingPeople.getPersonWhereName(name),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              List people = snapshot.data;

              return ListView.builder(
                itemCount: people.length,
                itemBuilder: (BuildContext context, int index) =>
                    seachCard(people[index], savedPeopleModel),
              );
            }
          }
          return Text("Loading People Or No One Was Found");
        },
      ));

  // Search Cards
  Widget seachCard(Map person, SavedPeopleModel savedPeopleModel) => Card(
        color: Colors.brown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            searchCardText(person, savedPeopleModel),
          ],
        ),
      );

  // Search Card Text Content
  Widget searchCardText(Map person, SavedPeopleModel savedPeopleModel) {
    String url = person['image'];
    String name = person['firstName'] + " " + person['lastName'];
    String date = formatter.format(DateTime.parse(person['missingSince']));
    String id = person['id'].toString();

    return ListTile(
        leading: _cardImg(url),
        title: _cardTitle(name),
        subtitle: _cardSubTitle(date),
        trailing: _cardSaveBtn(id, savedPeopleModel));
  }

  Widget _cardImg(String url) => CircleAvatar(
        backgroundImage: NetworkImage(url),
        onBackgroundImageError: (_, __) {},
      );

  Widget _cardTitle(String name) => Text(
        name,
        style: TextStyle(color: Colors.white),
      );

  Widget _cardSubTitle(String date) => Text(
        date,
        style: TextStyle(color: Colors.white),
      );

  Widget _cardSaveBtn(String id, SavedPeopleModel savedPeopleModel) => Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.save,
            color: Colors.white,
          ),
          onPressed: () => savePerson(context, id, savedPeopleModel),
        ),
      );
}
