import 'package:Red_Alert/Breakdown/Chart/city_chart.dart';
import 'package:flutter/material.dart';

import '../breakdown_func.dart';

import 'province_chart.dart';

class ChartSelector extends StatelessWidget {
  final BreakdownFunc _breakdownFunc;

  ChartSelector(this._breakdownFunc);

  @override
  Widget build(BuildContext context) {
    if (_breakdownFunc.currentTable == 'Province') {
      return ProvinceBarChart(_breakdownFunc.byProvince);
    } else if (_breakdownFunc.currentTable == 'City') {
      return CityBarChart(
        _breakdownFunc.byCity,
        _breakdownFunc.provinces,
      );
    }

    return Text("ERROR: No Chart");
  }
}
