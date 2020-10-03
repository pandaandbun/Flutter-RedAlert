import 'package:flutter/material.dart';

class ChartSelector extends StatefulWidget {
  @override
  _Types createState() => _Types();
}

class _Types extends State<ChartSelector> {

  List<String> _charts = ['Bar Chart', 'Line Chart', 'Pie Chart', 'Scatter Plot'];
  String _value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Chart Type:"),
        DropdownButton(
          hint: Text('Please choose a chart type'),
          value: _value,
          onChanged: (newValue) {
            setState(() {
              _value = newValue;
            });
          },
          items: _charts.map((location) {
            return DropdownMenuItem(
              child: new Text(location),
              value: location,
            );
          }).toList(),
        )
      ],
    );
  }
}
