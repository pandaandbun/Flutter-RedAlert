import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../Database/missing_person_database.dart';
import '../Database/selected_item_model.dart';

import '../notification.dart';

import 'missing_person_dialog.dart';

class MissingPersonListTile extends StatefulWidget {
  final Person person;

  MissingPersonListTile(this.person);

  @override
  _MissingPersonListTileState createState() => _MissingPersonListTileState();
}

class _MissingPersonListTileState extends State<MissingPersonListTile> {
  bool _selectedIndex = false;
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');
  final _notifications = Notifications();

  void refresh(bool bool) {
    setState(() {
      _selectedIndex = bool;
    });
  }

  Future<void> _moreInfo() async {
    showDialog(context: context, child: PeopleDialog(widget.person));
  }

  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();
    _notifications.init();
    final SelectedPeopleModel selectedPeopleModel =
        context.watch<SelectedPeopleModel>();

    List<String> selectedPeople = selectedPeopleModel.getDocIds();

    if (selectedPeople.length == 0) {
      refresh(false);
    } else if (selectedPeople.contains(widget.person.reference.id)) {
      refresh(true);
    }

    return _wrapper(selectedPeopleModel);
  }

  Widget _wrapper(SelectedPeopleModel selectedPeopleModel) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: _selectedIndex ? Colors.brown[900] : Colors.brown,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.brown[300], spreadRadius: 3),
          ],
        ),
        margin: EdgeInsets.only(left: 20, right: 20, top: 15),
        child: GestureDetector(
          child: _listTile(selectedPeopleModel),
          onLongPress: _moreInfo,
        ));
  }

  Widget _listTile(SelectedPeopleModel selectedPeopleModel) {
    String formattedDate = formatter.format(widget.person.missingSince);

    return Ink(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.person.image),
          radius: 30,
        ),
        title: Text(
          widget.person.firstName + " " + widget.person.lastName,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          formattedDate,
          style: TextStyle(color: Colors.white),
        ),
        trailing: notifyButton(),

        onTap: () => setState(() {
          _selectedIndex = !_selectedIndex;

          if (_selectedIndex) {
            selectedPeopleModel.insertDocId(widget.person.reference.id);
          } else {
            selectedPeopleModel.removeDocId(widget.person.reference.id);
          }
        }),
      ),
    );
  }

  Widget notifyButton() => IconButton(
        icon: Icon(Icons.notification_important_sharp),
        onPressed: () async {
          var when =
              tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
          await _notifications.sendNotificationLater(
            "Did you find them ?",
            widget.person.firstName + " " + widget.person.lastName,
            when,
          );
        },
      );
}
