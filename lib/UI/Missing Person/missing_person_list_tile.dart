import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../Database/selected_item_model.dart';

import '../notification.dart';

import 'missing_person_dialog.dart';

class MissingPersonListTile extends StatefulWidget {
  final Map person;
  final Notifications _notifications;
  final SharedPreferences prefs;

  MissingPersonListTile(this.person, this._notifications, this.prefs);

  @override
  _MissingPersonListTileState createState() => _MissingPersonListTileState(prefs);
}

class _MissingPersonListTileState extends State<MissingPersonListTile> {
  bool _selectedIndex = false;
  DateFormat formatter;
  final SharedPreferences prefs;

  _MissingPersonListTileState(this.prefs) {
    formatter = DateFormat('MMMM dd, yyyy', prefs.getString('language') ?? "en");
  }

  void refresh(bool bool) {
    setState(() {
      _selectedIndex = bool;
    });
  }

  void _moreInfo() async {
    await showDialog(
      context: context,
      child: PeopleDialog(widget.person, prefs),
    );
  }

  void _tileSelectionHandler(SelectedPeopleModel selectedPeopleModel) =>
      setState(() {
        _selectedIndex = !_selectedIndex;

        if (_selectedIndex) {
          selectedPeopleModel.insertDocId(widget.person['id'].toString());
        } else {
          selectedPeopleModel.removeDocId(widget.person['id'].toString());
        }
      });

  // ---------------------------------------------------------------------

  void _notifyBtnHandler(SharedPreferences prefs) async {
    if(prefs.getBool('notifications_scheduled') ?? false) {
      var when = await _selectDate(context); //function which opens a DatePicker

      if (when != null) {
        await widget._notifications.sendNotificationNow(
            "Reminder Set For " + formatter.format(when),
            widget.person['firstName'] + " " + widget.person['lastName']);
        await widget._notifications.sendNotificationLater(
          widget.person['id'],
          "Did you find me?",
          widget.person['firstName'] + " " + widget.person['lastName'],
          when,
        );

        _confirmationFialog(when);
      }
    }
    else {
      _notEnabledDialog();
    }
  }

  //dialog to alert user that the notification was scheduled
  Future _confirmationFialog(when) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: new Text(
                "Reminder for ${widget.person['firstName']} ${widget.person['lastName']} set for ${formatter.format(when)}."),
            backgroundColor: Colors.brown[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
      });
    
  Future _notEnabledDialog() => showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          content: new Text(
              FlutterI18n.translate(context, "person_list.notification_dialog")),
          backgroundColor: Colors.brown[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
    });

  // ---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final SelectedPeopleModel selectedPeopleModel =
        context.watch<SelectedPeopleModel>();

    List<String> selectedPeople = selectedPeopleModel.getDocIds();

    if (selectedPeople.length == 0) {
      // deselect item after saving to local db
      refresh(false);
    } else if (selectedPeople.contains(widget.person['id'].toString())) {
      // select even after item is destroy by ListView
      refresh(true);
    }

    return _personTile(selectedPeopleModel, prefs);
  }

  // ---------------------------------------------------------------------

  Widget _personTile(SelectedPeopleModel selectedPeopleModel, SharedPreferences prefs) => Container(
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
        child: _tileContent(selectedPeopleModel, prefs),
        onLongPress: _moreInfo,
      ));

  Widget _tileContent(SelectedPeopleModel selectedPeopleModel, SharedPreferences prefs) => Ink(
        child: ListTile(
          leading: _tileImage(),
          title: _tileTitle(),
          subtitle: _tileSubTitle(),
          trailing: notifyButton(prefs),
          onTap: () => _tileSelectionHandler(selectedPeopleModel),
        ),
      );

  Widget _tileImage() => CircleAvatar(
        backgroundImage: NetworkImage(widget.person['image']),
        radius: 30,
        onBackgroundImageError: (e, stackTrace) => print(e),
      );

  Widget _tileTitle() => Text(
        widget.person['firstName'] + " " + widget.person['lastName'],
        style: TextStyle(color: Colors.white),
      );

  Widget _tileSubTitle() => Text(
        formatter.format(DateTime.parse(widget.person['missingSince'])),
        style: TextStyle(color: Colors.white),
      );

  // ---------------------------------------------------------------------
  //_selectDate: opens a DatePicker to choose the date of the notification to set.
  Future<tz.TZDateTime> _selectDate(BuildContext context) async {
    final DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        locale: Locale(prefs.getString('language') ?? "en"));

    if (selectedDate == null) {
      return null;
    } else {
      return tz.TZDateTime.from(selectedDate, tz.local);
    }
  }

  //notifyButton: a button which processes a future notification for the accociated person.
  Widget notifyButton(SharedPreferences prefs) => IconButton(
        icon: Icon(
          Icons.add_alert,
          color: Colors.white,
        ),
        onPressed: () => _notifyBtnHandler(prefs),
      );
}
