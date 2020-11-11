import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../calendar.dart';
import '../settings_btn.dart';
import '../drawer.dart';
import '../Search Bar/search_bar.dart';
import '../notification.dart';

import '../Database/saved_people_database.dart';
import '../Database/selected_item_model.dart';

import 'missing_person_list.dart';

// class SavedPeople {
//   List<String> ids = [];
//   List<Function> refreshStates = [];
// }

class MissingPerson extends StatelessWidget {
  final _notifications = Notifications();

  @override
  Widget build(BuildContext context) {
    final SavedPeopleModel savedPeopleModel =
        Provider.of<SavedPeopleModel>(context);
    final SelectedPeopleModel selectedPeopleModel =
        Provider.of<SelectedPeopleModel>(context);

    _notifications.init();

    return Scaffold(
      appBar: AppBar(
        title: Text('Missing Person'),
        actions: [
          savedButton(savedPeopleModel, selectedPeopleModel),
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
          MissingPersonList(savedPeopleModel),
        ],
      ),
    );
  }
}

Widget savedButton(SavedPeopleModel savedPeopleModel,
        SelectedPeopleModel selectedPeopleModel) =>
    Builder(
        builder: (context) => IconButton(
              icon: Icon(Icons.save),
              tooltip: "Settings",
              onPressed: () async {
                var snackBar =
                    SnackBar(content: Text('Please first click on someone'));
                List<String> ids = selectedPeopleModel.getDocIds();

                if (ids.length > 0) {
                  snackBar = SnackBar(content: Text('Saved'));
                  // int i = 0;

                  for (String id in ids) {
                    SavedPerson person = SavedPerson(id);
                    var result = await savedPeopleModel.insertPeople(person);

                    if (result != null) {
                      snackBar = SnackBar(
                          content: Text('One Of The Item Is Already Saved'));
                    }

                    // savedPeople.refreshStates[i]();
                    // i++;
                  }
                  selectedPeopleModel.resetDocIds();
                  // savedPeople.ids = [];
                  // savedPeople.refreshStates = [];
                }
                Scaffold.of(context).showSnackBar(snackBar);
              },
            ));

void _notifyNow(_notifications) {
  _notifications.sendNotificationNow('title', 'body', 'payload');
}
