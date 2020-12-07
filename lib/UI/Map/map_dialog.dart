import 'package:Red_Alert/Database/saved_people_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Database/saved_people_database.dart';

class MapDialog extends StatelessWidget {
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');
  final SavedPeopleModel savedPeopleModel = SavedPeopleModel();
  final List people;

  MapDialog(this.people);

  void savePerson(String id) async {
    SavedPerson person = SavedPerson(id);
    await savedPeopleModel.insertPeople(person);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Missing People (${people.length})"),
      content: _peopleList(),
      actions: [_exitBtn(context)],
    );
  }

  Widget _exitBtn(context) => TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text("Exit"),
      );

  Widget _peopleList() => Container(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: people.length,
          itemBuilder: (BuildContext context, int index) => _peopleCard(index),
        ),
      );

  Widget _peopleCard(int index) => Card(
        color: Colors.brown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_peopleCardContent(people[index])],
        ),
      );

  Widget _peopleCardContent(Map person) {
    String url = person['image'];
    String name = person['firstName'] + " " + person['lastName'];
    String date = formatter.format(DateTime.parse(person['missingSince']));
    String id = person['id'].toString();

    return ListTile(
        leading: _cardImg(url),
        title: _cardTitle(name),
        subtitle: _cardSubTitle(date),
        trailing: _cardSaveBtn(id));
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
        style: TextStyle(color: Colors.grey),
      );

  Widget _cardSaveBtn(String id) => IconButton(
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        onPressed: () => savePerson(id),
      );
}
