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

  sort() {
    print('');
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
                String formattedDate = formatter.format(_doB);
                /*
              var num = toDateString(_doB).split(' ')[2];
              var num2 = toDateString(now).split(' ')[2];
              var tot = int.parse(num);
              var tot2 = int.parse(num2);
              age = tot2 - tot;
              */
                // print(formattedDate);
                sort();
              });
              dateModel.setDate(value);
            }
          });
        });
  }

  //THE THREE FUNCTIONS BELOW ARE TAKE FROM THE TAKE HOME MIDTERM
  //AND ALL CREDIT GOES TO RANDY FORTIER
  String toDateString(DateTime date) {
    return '${toMonthName(date.month)} ${toOrdinal(date.day)}, ${date.year}';
  }

  String toOrdinal(number) {
    if ((number >= 10) && (number <= 19)) {
      return number.toString() + 'th';
    } else if ((number % 10) == 1) {
      return number.toString() + 'st';
    } else if ((number % 10) == 2) {
      return number.toString() + 'nd';
    } else if ((number % 10) == 3) {
      return number.toString() + 'rd';
    } else {
      return number.toString() + 'th';
    }
  }

  String toMonthName(monthNum) {
    switch (monthNum) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Error';
    }
  }
}
