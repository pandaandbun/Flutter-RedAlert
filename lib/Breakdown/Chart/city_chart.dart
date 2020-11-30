import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class CityBarChart extends StatefulWidget {
  final Map breakdown;
  final Set<String> provinces;

  CityBarChart(this.breakdown, this.provinces);

  @override
  _CityBarChartState createState() => _CityBarChartState();
}

class _CityBarChartState extends State<CityBarChart> {
  String selectedProvince = '';

  List<Series<dynamic, String>> _createSeriesData(List people) {
    return [
      Series<dynamic, String>(
        id: 'Default',
        measureFn: (var e, _) => e.value,
        domainFn: (var e, _) => e.key.split("*")[1],
        data: people,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (selectedProvince.isEmpty) {
      selectedProvince = widget.provinces.first;
    }
    return Column(
      children: [
        _dropDownList(),
        _pieChart(),
      ],
    );
  }

  Widget _dropDownList() => DropdownButton(
        items: widget.provinces
            .map((String e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ))
            .toList(),
        value: selectedProvince,
        onChanged: (e) => setState(() {
          selectedProvince = e;
        }),
      );

  Widget _pieChart() => Expanded(
          child: PieChart(
        _createSeriesData(widget.breakdown.entries
            .toList()
            .where((e) => e.key.contains(selectedProvince))
            .toList()),
        animate: true,
        defaultRenderer: new ArcRendererConfig(
          arcWidth: 110,
          arcRendererDecorators: [
            new ArcLabelDecorator(
              labelPosition: ArcLabelPosition.outside,
            )
          ],
        ),
      ));
}
