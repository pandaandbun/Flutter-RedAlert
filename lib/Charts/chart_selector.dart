import 'pie_chart.dart';
import 'package:flutter/material.dart';
import 'bar_chart.dart';
import 'line_chart.dart';
import 'scatter_chart.dart';

class ChartSelector extends StatefulWidget {
  @override
  _ChartSelectorState createState() => _ChartSelectorState();
}

class _ChartSelectorState extends State<ChartSelector> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Container(child: _barChart1())],
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Container(child: _lineChart())],
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Container(child: _pieChart())],
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Container(child: _scatterChart())],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _barChart1() {
    return GestureDetector(
        child: Container(
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  image: AssetImage("images/barChart.png"),
                  fit: BoxFit.cover),
              //child: Text("clickMe") // button text
            )),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      GroupedBarChart.withSampleData()));
        });
  }

  Widget _barChart() {
    return Container(
      height: 150.0,
      width: 350.0,
      color: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://www.mathworks.com/help/examples/graphics/win64/CompareTypesOfBarGraphsExample_01.png"),
                fit: BoxFit.cover),
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: new RaisedButton(
            child: new Text(
              "Bar Chart",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            color: Colors.green,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            elevation: 10,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          GroupedBarChart.withSampleData()));
            },
          )),
    );
  }

  Widget _lineChart() {
    return Container(
      height: 150.0,
      width: 350.0,
      color: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: new RaisedButton(
            child: new Text(
              "Line Chart",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            color: Colors.green,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            elevation: 10,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SimpleLineChart.withSampleData()));
            },
          )),
    );
  }

  Widget _pieChart() {
    return Container(
      height: 150.0,
      width: 350.0,
      color: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: new RaisedButton(
            child: new Text(
              "Pie Chart",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            color: Colors.green,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            elevation: 10,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          DonutAutoLabelChart.withSampleData()));
            },
          )),
    );
  }

  Widget _scatterChart() {
    return Container(
      height: 150.0,
      width: 350.0,
      color: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: new RaisedButton(
            child: new Text(
              "Scatter Chart",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            color: Colors.green,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            elevation: 10,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SimpleScatterPlotChart.withSampleData()));
            },
          )),
    );
  }
}
