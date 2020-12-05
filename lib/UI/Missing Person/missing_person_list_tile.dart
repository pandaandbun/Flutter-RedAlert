import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../Database/missing_person_database.dart';
import '../../Database/selected_item_model.dart';

import '../notification.dart';

import 'missing_person_dialog.dart';

class MissingPersonListTile extends StatefulWidget {
  final Person person;
  final Notifications _notifications;

  MissingPersonListTile(this.person, this._notifications);

  @override
  _MissingPersonListTileState createState() => _MissingPersonListTileState();
}

class _MissingPersonListTileState extends State<MissingPersonListTile> {
  bool _selectedIndex = false;
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');

  void refresh(bool bool) {
    setState(() {
      _selectedIndex = bool;
    });
  }

  Future<void> _moreInfo() async {
    showDialog(context: context, child: PeopleDialog(widget.person));
  }

  void _tileSelectionHandler(SelectedPeopleModel selectedPeopleModel) =>
      setState(() {
        _selectedIndex = !_selectedIndex;

        if (_selectedIndex) {
          selectedPeopleModel.insertDocId(widget.person.reference.id);
        } else {
          selectedPeopleModel.removeDocId(widget.person.reference.id);
        }
      });

  @override
  Widget build(BuildContext context) {
    final SelectedPeopleModel selectedPeopleModel =
        context.watch<SelectedPeopleModel>();

    List<String> selectedPeople = selectedPeopleModel.getDocIds();

    if (selectedPeople.length == 0) {
      // deselect item after saving to local db
      refresh(false);
    } else if (selectedPeople.contains(widget.person.reference.id)) {
      // select even after item is destroy by ListView
      refresh(true);
    }

    return _personTile(selectedPeopleModel);
  }

  Widget _personTile(SelectedPeopleModel selectedPeopleModel) => Container(
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
        child: _tileContent(selectedPeopleModel),
        onLongPress: _moreInfo,
      ));

  Widget _tileContent(SelectedPeopleModel selectedPeopleModel) => Ink(
        child: ListTile(
          leading: _tileImage(),
          title: _tileTitle(),
          subtitle: _tileSubTitle(),
          trailing: notifyButton(),
          onTap: () => _tileSelectionHandler(selectedPeopleModel),
        ),
      );

  Widget _tileImage() => CachedNetworkImage(
        imageUrl: widget.person.image,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundImage: imageProvider,
          radius: 30,
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );

  // CircleAvatar(
  //   // backgroundImage: CachedNetworkImageProvider(widget.person.image),
  //   radius: 30,
  //   child: CachedNetworkImage(
  //     imageUrl: widget.person.image,
  //     progressIndicatorBuilder: (context, url, downloadProgress) =>
  //         CircularProgressIndicator(value: downloadProgress.progress),
  //     errorWidget: (context, url, error) => Icon(Icons.error),
  //   ),
  // );

  Widget _tileTitle() => Text(
        widget.person.firstName + " " + widget.person.lastName,
        style: TextStyle(color: Colors.white),
      );

  Widget _tileSubTitle() => Text(
        formatter.format(widget.person.missingSince),
        style: TextStyle(color: Colors.white),
      );

  //_selectDate: opens a DatePicker to choose the date of the notification to set.
  Future<tz.TZDateTime> _selectDate(BuildContext context) async {
    final DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime.now().add(const Duration(days: 365)));

    if (selectedDate == null) {
      return null;
    } else {
      return tz.TZDateTime.from(selectedDate, tz.local);
    }
  }

  //notifyButton: a button which processes a future notification for the accociated person.
  Widget notifyButton() => IconButton(
        icon: Icon(
          Icons.add_alert,
          color: Colors.white,
        ),
        onPressed: () async {
          var when =
              await _selectDate(context); //function which opens a DatePicker

          //for debugging:
          // print(when);
          //print(widget.person.id);
          if (when != null) {
            await widget._notifications.sendNotificationNow(
                "Reminder Set For " + formatter.format(when),
                widget.person.firstName + " " + widget.person.lastName);
            await widget._notifications.sendNotificationLater(
              widget.person.id,
              "Did you find me?",
              widget.person.firstName + " " + widget.person.lastName,
              when,
            );

            //dialog to alert user that the notification was scheduled
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      content: new Text(
                          'Reminder for ${widget.person.firstName} ${widget.person.lastName} set for ${formatter.format(when)}.'),
                      backgroundColor: Colors.brown[100],
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))));
                });
          }
        },
      );
}