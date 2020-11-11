import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'Database/missing_person_database.dart';

import 'Database/filter_by_date_model.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _doB;
  var now = DateTime.now();
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');
  Person person;
  final MissingPeopleModel missingPeople = MissingPeopleModel();

  @override
  Widget build(BuildContext context) {
    final DateModel dateModel = Provider.of<DateModel>(context);
    return _buildDoB(dateModel);
  }

  Widget _getLoc() {
    return GestureDetector(
      child: Icon(Icons.calendar_today_outlined),
      onTap: () async {
        //BASE CODY FROM PACKAGE FOR NOW
        Location location = new Location();

        bool _serviceEnabled;
        PermissionStatus _permissionGranted;
        LocationData _locationData;

        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            return;
          }
        }

        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.granted) {
            return;
          }
        }

        _locationData = await location.getLocation();
        print(_locationData);
      },
    );
  }

  Widget _buildDoB(DateModel dateModel) {
    return GestureDetector(
        child: Icon(Icons.date_range),
        onTap: () {
          showDatePicker(
                  context: context,
                  initialDate: _doB == null ? now : _doB,
                  firstDate: DateTime(1850),
                  lastDate: now)
              .then((value) {
            if (value != null) {
              setState(() {
                _doB = value;
              });
              dateModel.setDate(value);
            }
          });
        });
  }
}
