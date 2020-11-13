import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../calendar.dart';
import '../settings_btn.dart';
import '../drawer.dart';
import '../Search Bar/search_bar.dart';
import '../notification.dart';

import 'missing_person_list.dart';

import '../Database/saved_people_database.dart';
import '../Database/selected_item_model.dart';

class NotificationsNum {
  int num = 0;
}

// Missing Person Initial Page
class MissingPerson extends StatelessWidget {
  final Notifications _notifications = Notifications();
  final NotificationsNum notificationsNum = NotificationsNum();

  MissingPerson();

  @override
  Widget build(BuildContext context) {
    _notifications.init(scaffoldContext: context);

    final SavedPeopleModel savedPeopleModel =
        Provider.of<SavedPeopleModel>(context);
    final SelectedPeopleModel selectedPeopleModel =
        Provider.of<SelectedPeopleModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Missing Person'),
        actions: [
          savedButton(savedPeopleModel, selectedPeopleModel),
          SettingsBtn(),
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
          MissingPersonList(savedPeopleModel, _notifications, notificationsNum),
        ],
      ),
    );
  }

  // Save button for saving people to local list
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

                    for (String id in ids) {
                      SavedPerson person = SavedPerson(id);
                      var result = await savedPeopleModel.insertPeople(person);

                      if (result != null) {
                        snackBar = SnackBar(
                            content: Text('One Of The Item Is Already Saved'));
                      }
                    }
                    selectedPeopleModel.resetDocIds();
                  }
                  Scaffold.of(context).showSnackBar(snackBar);
                },
              ));
}
