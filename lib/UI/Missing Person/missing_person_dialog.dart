import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Pop up dialog for main page
class PeopleDialog extends StatelessWidget {
  final Map person;
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');

  PeopleDialog(this.person);

  @override
  Widget build(BuildContext context) {
    return _blurBackGround();
  }

  Widget _blurBackGround() => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: SimpleDialog(
          backgroundColor: Colors.brown[400],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: _dialogHeader(),
          children: [
            _dialogImage(),
            _dialogBody(),
          ],
        ),
      );

  Widget _dialogHeader() => Text(
        person['firstName'] + " " + person['lastName'],
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.0),
      );

  Widget _dialogImage() => Image.network(
        person['image'],
        height: 250,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(Icons.error),
      );

  Widget _dialogBody() => Container(
        margin: EdgeInsets.only(left: 50),
        child: SimpleDialogOption(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              _dialogBodyDate(),
              SizedBox(height: 15),
              _dialogBodyLoc(),
              SizedBox(height: 15),
            ],
          ),
        ),
      );

  Widget _dialogBodyDate() {
    String missingSince =
        formatter.format(DateTime.parse(person['missingSince']));

    return Row(
      children: [
        Expanded(
            child: Text(
          'Missing Since: $missingSince',
          style: TextStyle(fontSize: 15),
        ))
      ],
    );
  }

  Widget _dialogBodyLoc() => Row(children: [
        Expanded(
            child: Text(
          'Last Location: ${person['city']}, ${person['province']}',
          style: TextStyle(fontSize: 15),
        )),
      ]);
}
