import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Pop up dialog for main page
class PeopleDialog extends StatelessWidget {
  final person;
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');

  PeopleDialog(this.person);

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatter.format(person.missingSince);

    return _blurBackGround(formattedDate);
  }

  Widget _blurBackGround(formattedDate) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: SimpleDialog(
          backgroundColor: Colors.brown[400],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: _dialogHeader(),
          children: [
            _dialogImage(),
            _dialogBody(formattedDate),
          ],
        ),
      );

  Widget _dialogHeader() => Text(
        person.firstName + " " + person.lastName,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.0),
      );

  // Widget _dialogImage() => Image(
  //       image: NetworkImage(person.image),
  //       height: 140,
  //       fit: BoxFit.contain,
  //     );

  Widget _dialogImage() => CachedNetworkImage(
        imageUrl: person.image,
        imageBuilder: (context, imageProvider) => Image(
          image: imageProvider,
          height: 140,
          fit: BoxFit.contain,
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );

  Widget _dialogBody(formattedDate) => Container(
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
      );
}
