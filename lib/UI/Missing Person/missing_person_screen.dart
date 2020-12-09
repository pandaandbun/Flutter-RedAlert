import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'calendar.dart';
import 'missing_person_list.dart';

import '../settings_btn.dart';
import '../drawer.dart';
import '../Search Bar/search_bar.dart';
import '../notification.dart';
import '../are_you_sure_you_want_to_exit.dart';
import '../tutorial.dart';

import '../../Database/saved_people_database.dart';
import '../../Database/selected_item_model.dart';
import '../../Database/tutorial_database.dart';

import 'package:flutter_i18n/flutter_i18n.dart';

class NotificationsNum {
  int num = 0;
}

// Missing Person Initial Page
class MissingPerson extends StatelessWidget {
  final Notifications _notifications = Notifications();
  final NotificationsNum notificationsNum = NotificationsNum();
  final TutorialModel tutorialModel = TutorialModel();

  void _tutorial(BuildContext context) async {
    bool showTutorial =
        await tutorialModel.getTutorialSettingFor("missingPersonPage");
    if (showTutorial) {
      await showDialog(
        context: context,
        child: TutorialDialog("missingPersonPage"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _notifications.init(scaffoldContext: context);

    final SavedPeopleModel savedPeopleModel =
        Provider.of<SavedPeopleModel>(context);
    final SelectedPeopleModel selectedPeopleModel =
        Provider.of<SelectedPeopleModel>(context);

    _tutorial(context);

    return _scaffold(savedPeopleModel, selectedPeopleModel, context);
  }

  // ------------------------------------------------------------

  Widget _scaffold(SavedPeopleModel savedPeopleModel,
          SelectedPeopleModel selectedPeopleModel,
          BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: Text(FlutterI18n.translate(context, "drawer.missing_persons")),
          actions: [
            _turnOnTutorialBtn(),
            savedButton(savedPeopleModel, selectedPeopleModel),
            SettingsBtn(),
          ],
        ),
        drawer: DrawerMenu(),
        backgroundColor: Colors.brown[900],
        body: _areYourSureYouWantToExitWarpper(savedPeopleModel),
      );

  Widget _areYourSureYouWantToExitWarpper(SavedPeopleModel savedPeopleModel) =>
      Builder(
          builder: (context) => WillPopScope(
              child: _body(savedPeopleModel),
              onWillPop: () async {
                bool value = await showDialog<bool>(
                    context: context, builder: (context) => ExitDialog());
                return value;
              }));

  Widget _body(SavedPeopleModel savedPeopleModel) => Column(
        children: [
          Row(children: [
            SearchBar(),
            Calendar(),
          ]),
          MissingPersonList(savedPeopleModel, _notifications, notificationsNum),
        ],
      );

  // ------------------------------------------------------------

  Widget _turnOnTutorialBtn() => IconButton(
      icon: Icon(Icons.school),
      onPressed: () {
        tutorialModel.turnOnAllTutorials();
      });

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
