import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeopleDialog extends StatelessWidget {

  final person;
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');

  PeopleDialog(this.person);

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatter.format(person.missingSince);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: SimpleDialog(
        backgroundColor: Colors.brown[400],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Text(
          person.firstName + " " + person.lastName,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.0),
        ),
        children: [
          Image(
            image: NetworkImage(person.image),
            height: 140,
            fit: BoxFit.contain,
          ),
          Container(
            margin: EdgeInsets.only(left: 50),
            child: SimpleDialogOption(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Row(children: [
                    Expanded(
                        child: Text(
                      'Missing Since: $formattedDate',
                      style: TextStyle(fontSize: 15),
                    )),
                  ]),
                  SizedBox(
                    height: 15,
                  ),
                  Row(children: [
                    Expanded(
                        child: Text(
                      'Last Location: ${person.city}, ${person.province}',
                      style: TextStyle(fontSize: 15),
                    )),
                  ]),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
