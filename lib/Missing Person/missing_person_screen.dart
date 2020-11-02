import 'package:flutter/material.dart';
import 'package:path/path.dart';
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

Widget savedButton(savedPeople, peopleModel) => Builder(
    builder: (context) => IconButton(
          icon: Icon(Icons.save),
          tooltip: "Settings",
          onPressed: () async {
            var snackBar = SnackBar(content: Text('Please first click on someone'));

            if (savedPeople.ids.length != 0) {
              final PeopleModel peopleModel = PeopleModel();
              snackBar = SnackBar(content: Text('Saved'));

              for (int id in savedPeople.ids) {
                Person person = Person(id);
                var result = await peopleModel.insertPeople(person);

                if (result != null) {
                  snackBar = SnackBar(content: Text('One Of The Item Is Already Saved'));
                }
              }
            }

            Scaffold.of(context).showSnackBar(snackBar);
          },
        ));
