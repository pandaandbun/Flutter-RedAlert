import 'package:flutter/material.dart';

class SortBy extends StatefulWidget {
  @override
  _SortByState createState() => _SortByState();
}

class _SortByState extends State<SortBy> {
  String dropDownValue = "Date";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Sort By"),
        DropdownButton<String>(
          value: dropDownValue,
          icon: Icon(Icons.arrow_downward),
          items: <String>["Date", "Age", "Area"]
              .map<DropdownMenuItem<String>>((String value) =>
                  DropdownMenuItem<String>(value: value, child: Text(value)))
              .toList(),
          onChanged: (String newValue) {
            setState(() {
              dropDownValue = newValue;
            });
          }
        ),
      ],
    );
  }
}
