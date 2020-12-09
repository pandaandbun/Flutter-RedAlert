import 'package:flutter/material.dart';

import '../Database/tutorial_database.dart';

class TutorialDialog extends StatefulWidget {
  final String parentScreen;

  TutorialDialog(this.parentScreen);

  @override
  _TutorialDialogState createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<TutorialDialog> {
  TutorialModel tutorialModel = TutorialModel();

  double _curSliderVal = 0;

  Map _imgPaths = {
    'missingPersonPage': [
      'images/tutorials/missing_person/missing_person.png',
      'images/tutorials/missing_person/missing_person_1.png',
      'images/tutorials/missing_person/missing_person_2.png',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.brown[400],
      title: _dialogTitle(),
      content: _dialogBody(),
      actions: [
        _turnOfAllTutorialBtn(),
        _turnOffThisTutorialBtn(),
        _exitBtn(),
      ],
    );
  }

  // --------------------------------------------------------------

  Widget _dialogTitle() => Text(
        "Tutorial",
        style: TextStyle(
          color: Colors.white,
        ),
      );

  Widget _dialogBody() => Column(
        children: [
          Expanded(child: _image()),
          _slider(),
        ],
      );

  Widget _image() => Image.asset(
        _imgPaths[widget.parentScreen][_curSliderVal.toInt()],
        fit: BoxFit.cover,
      );

  Widget _slider() => Slider(
        value: _curSliderVal,
        min: 0,
        max: _imgPaths[widget.parentScreen].length.toDouble() - 1,
        divisions: _imgPaths[widget.parentScreen].length - 1,
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
        tutorialModel.turnOffTutorialSettingFor("missingPersonPage");
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

  Widget _turnOfAllTutorialBtn() => TextButton(
      onPressed: () {
        tutorialModel.turnOffAllTutorials();
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
