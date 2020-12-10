import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/tutorial_database.dart';

class TutorialDialog extends StatefulWidget {
  final String parentScreen;
  final Map imgPaths = {
    'missingPersonPage': [
      {
        'name': 'Search Bar',
        'path': 'images/tutorials/missing_person/search.gif'
      },
      {
        'name': 'Calendar',
        'path': 'images/tutorials/missing_person/calendar.gif'
      },
      {
        'name': 'Long Press',
        'path': 'images/tutorials/missing_person/long_press.gif'
      },
      {
        'name': 'Map',
        'path': 'images/tutorials/missing_person/map_distance.gif'
      },
      {
        'name': 'Bell',
        'path': 'images/tutorials/missing_person/notifications.gif'
      },
      {
        'name': 'Save',
        'path': 'images/tutorials/missing_person/save_delete.gif'
      },
      {
        'name': 'About',
        'path': 'images/tutorials/about/about.gif',
      },
    ],
    'syncPage': [
      {
        'name': 'Tutorial',
        'path': 'images/tutorials/sync/sync.gif',
      },
    ],
    'mapPage': [
      {
        'name': 'Map',
        'path': 'images/tutorials/map/map.gif',
      },
    ],
    'breakdownPage': [
      {
        'name': 'Table',
        'path': 'images/tutorials/charts_data_table/data_table.gif'
      },
      {
        'name': 'Table',
        'path': 'images/tutorials/charts_data_table/charts.gif'
      },
    ],
  };
  final SharedPreferences prefs;

  TutorialDialog(this.parentScreen, this.prefs);

  @override
  _TutorialDialogState createState() => _TutorialDialogState(prefs);
}

class _TutorialDialogState extends State<TutorialDialog> {
  final SharedPreferences prefs;
  _TutorialDialogState(this.prefs);
  TutorialModel tutorialModel = TutorialModel();

  double _curSliderVal = 0;

  @override
  Widget build(BuildContext context) {
    return _dialog(prefs);
  }

  // --------------------------------------------------------------

  Widget _dialog(SharedPreferences prefs) => AlertDialog(
        backgroundColor: Colors.brown[400],
        title: _dialogTitle(),
        content: _dialogBody(),
        actions: [
          _turnOfAllTutorialBtn(prefs),
          _turnOffThisTutorialBtn(),
          _exitBtn(),
        ],
      );

  Widget _dialogTitle() => Text(
        widget.imgPaths[widget.parentScreen][_curSliderVal.toInt()]['name'],
        style: TextStyle(color: Colors.white),
      );

  Widget _dialogBody() => Column(
        children: [
          Expanded(child: _image()),
          _slider(),
        ],
      );

  Widget _image() => Image.asset(
        widget.imgPaths[widget.parentScreen][_curSliderVal.toInt()]['path'],
        fit: BoxFit.cover,
      );

  Widget _slider() => Slider(
        value: _curSliderVal,
        min: 0,
        max: widget.imgPaths[widget.parentScreen].length.toDouble() - 1,
        divisions: widget.imgPaths[widget.parentScreen].length == 1
            ? 1
            : widget.imgPaths[widget.parentScreen].length - 1,
        label: _curSliderVal.round().toString(),
        onChanged: (value) {
          setState(() {
            _curSliderVal = value;
          });
        },
      );

  // --------------------------------------------------------------

  Widget _exitBtn() => TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          "Skip",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );

  Widget _turnOffThisTutorialBtn() => TextButton(
      onPressed: () {
        tutorialModel.turnOffTutorialSettingFor(widget.parentScreen);
        Navigator.pop(context);
      },
      child: Row(children: [
        Icon(
          Icons.not_interested,
          color: Colors.red[900],
        ),
        Text(" This",
            style: TextStyle(
              color: Colors.white,
            )),
      ]));

  Widget _turnOfAllTutorialBtn(SharedPreferences prefs) => TextButton(
      onPressed: () {
        tutorialModel.turnOffAllTutorials();
        prefs.setBool("tutorial_on", false);
        Navigator.pop(context);
      },
      child: Row(children: [
        Icon(
          Icons.not_interested,
          color: Colors.red[900],
        ),
        Text(" All",
            style: TextStyle(
              color: Colors.white,
            )),
      ]));
}
