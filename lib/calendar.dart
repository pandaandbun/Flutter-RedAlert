import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Database/filter_by_date_model.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _doB;
  var now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final DateModel dateModel = Provider.of<DateModel>(context);
    return _buildDoB(dateModel);
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
