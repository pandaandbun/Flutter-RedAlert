import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../calendar.dart';
import '../settings_btn.dart';
import '../drawer.dart';
import '../Search Bar/search_bar.dart';
import '../Database/saved_people_database.dart';
import '../notification.dart';

import 'missing_person_list.dart';

class SavedPeople {
  List<String> ids = [];
  List<Function> refreshStates = [];
}

class MissingPerson extends StatelessWidget {
  final _notifications = Notifications();

  @override
  Widget build(BuildContext context) {
    SavedPeople savedPeople = SavedPeople();
    final SavedPeopleModel peopleModel = Provider.of<SavedPeopleModel>(context);

    _notifications.init();

    return Scaffold(
      appBar: AppBar(
        title: Text('Missing Person'),
        actions: [
          savedButton(savedPeople, peopleModel),
          SettingsBtn(),
          IconButton(
            icon: Icon(Icons.text_snippet),
            onPressed: () => _notifyNow(_notifications),
          )
        ],
      ),
      drawer: DrawerMenu(),
      backgroundColor: Colors.brown[900],
      body: Column(
        children: [
          Row(children: [
            SearchBar(),
            Calendar(),
          ]),
          MissingPersonList(savedPeople),
        ],
      ),
    );
  }
}

Widget savedButton(SavedPeople savedPeople, SavedPeopleModel peopleModel) =>
    Builder(
        builder: (context) => IconButton(
              icon: Icon(Icons.save),
              tooltip: "Settings",
              onPressed: () async {
                var snackBar =
                    SnackBar(content: Text('Please first click on someone'));

                if (savedPeople.ids.length > 0) {
                  snackBar = SnackBar(content: Text('Saved'));
                  int i = 0;

                  for (String id in savedPeople.ids) {
                    SavedPerson person = SavedPerson(id);
                    var result = await peopleModel.insertPeople(person);

                    if (result != null) {
                      snackBar = SnackBar(
                          content: Text('One Of The Item Is Already Saved'));
                    }

                    savedPeople.refreshStates[i]();
                    i++;
                  }
                  savedPeople.ids = [];
                  savedPeople.refreshStates = [];
                }
                Scaffold.of(context).showSnackBar(snackBar);
              },
            ));

void _notifyNow(_notifications) {
  _notifications.sendNotificationNow('title', 'body', 'payload');
}
