import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../settings_btn.dart';

class GroupedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GroupedBarChart(this.seriesList, {this.animate});

  factory GroupedBarChart.withSampleData() {
    return new GroupedBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Missing Person'),
        actions: [
          SettingsBtn(),
        ],
      ),
      //drawer: DrawerMenu(),
      body: Container(
        height: 400,
        padding: EdgeInsets.all(20.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Bar Chart',
                ),
                Expanded(
                  child: new charts.BarChart(
                    seriesList,
                    animate: animate,
                    barGroupingType: charts.BarGroupingType.grouped,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales(
          '2014', 5, charts.ColorUtil.fromDartColor(Colors.blue[50])),
      new OrdinalSales(
          '2015', 25, charts.ColorUtil.fromDartColor(Colors.red[50])),
      new OrdinalSales(
          '2016', 100, charts.ColorUtil.fromDartColor(Colors.green[50])),
      new OrdinalSales(
          '2017', 75, charts.ColorUtil.fromDartColor(Colors.pink[50])),
    ];

    final tableSalesData = [
      new OrdinalSales(
          '2014', 25, charts.ColorUtil.fromDartColor(Colors.blue[100])),
      new OrdinalSales(
          '2015', 50, charts.ColorUtil.fromDartColor(Colors.red[100])),
      new OrdinalSales(
          '2016', 10, charts.ColorUtil.fromDartColor(Colors.green[100])),
      new OrdinalSales(
          '2017', 20, charts.ColorUtil.fromDartColor(Colors.pink[100])),
    ];

    final mobileSalesData = [
      new OrdinalSales(
          '2014', 10, charts.ColorUtil.fromDartColor(Colors.blue[200])),
      new OrdinalSales(
          '2015', 15, charts.ColorUtil.fromDartColor(Colors.red[200])),
      new OrdinalSales(
          '2016', 50, charts.ColorUtil.fromDartColor(Colors.green[200])),
      new OrdinalSales(
          '2017', 45, charts.ColorUtil.fromDartColor(Colors.pink[200])),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesData,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Mobile',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;
  final charts.Color barColor;

  OrdinalSales(this.year, this.sales, this.barColor);
}
