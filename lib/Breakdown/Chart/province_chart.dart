import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class ProvinceBarChart extends StatelessWidget {
  final Map breakdown;

  ProvinceBarChart(this.breakdown);

  List<Series<dynamic, String>> _createSeriesData(Map people) {
    return [
      Series<dynamic, String>(
        id: 'Default',
        measureFn: (var e, _) => e.value,
        data: people.entries.toList(),
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (var e, _) => e.key,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      _createSeriesData(breakdown),
      animate: true,
      defaultRenderer: new BarRendererConfig(
          groupingType: BarGroupingType.grouped, strokeWidthPx: 2.0),
    );
  }
}
