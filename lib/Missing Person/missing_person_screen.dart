import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings_btn.dart';
import '../drawer.dart';
import '../search_bar.dart';
import '../sort_by.dart';
import '../Database/saved_people_database.dart';

import 'missing_person_list.dart';


class SavedPeople {
  List<int> ids = [];
}

class MissingPerson extends StatelessWidget {

  final SavedPeople savedPeople = SavedPeople();

  @override
  Widget build(BuildContext context) {
    final PeopleModel peopleModel = Provider.of<PeopleModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Missing Person'),
        actions: [
          savedButton(savedPeople, peopleModel),
          SettingsBtn(),
        ],
      ),
      drawer: DrawerMenu(),
      body: Column(
        children: [
          SearchBar(),
          SortBy(),
          MissingPersonList(savedPeople),
        ],
      ),
    );
  }
}

Widget savedButton(savedPeople, peopleModel) => IconButton(
      icon: Icon(Icons.save),
      tooltip: "Settings",
      onPressed: () async {

        if (savedPeople.ids != null) {
          final PeopleModel peopleModel = PeopleModel();    

          for (int id in savedPeople.ids) {
            Person person = Person(id);
            await peopleModel.insertPeople(person);
          }
        }        
      },
    );
