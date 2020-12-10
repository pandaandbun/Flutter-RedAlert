import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/filter_by_date_model.dart';

class Calendar extends StatefulWidget {
  final SharedPreferences prefs;
  Calendar(this.prefs);
  @override
  _CalendarState createState() => _CalendarState(prefs);
}

class _CalendarState extends State<Calendar> {
  DateTime _selectDate;
  DateTime now = DateTime.now();
  final SharedPreferences prefs;

  _CalendarState(this.prefs);

  void _calendarHandler(value, dateModel) {
    if (value != null) {
      setState(() {
        _selectDate = value;
      });
      dateModel.setDate(value);
    } else {
      dateModel.setDate(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateModel dateModel = Provider.of<DateModel>(context);
    return _calendar(dateModel, prefs);
  }

  Widget _calendar(DateModel dateModel, SharedPreferences prefs) => GestureDetector(
      child: Icon(
        Icons.date_range,
        color: Colors.white,
      ),
      onTap: () => _calendarDatePicker(prefs)
          .then((value) => _calendarHandler(value, dateModel)));

  Future<DateTime> _calendarDatePicker(SharedPreferences prefs) => showDatePicker(
      context: context,
      initialDate: _selectDate == null ? now : _selectDate,
      firstDate: DateTime(1850),
      lastDate: now,
      locale: Locale(prefs.getString('language') ?? "en"));
}
