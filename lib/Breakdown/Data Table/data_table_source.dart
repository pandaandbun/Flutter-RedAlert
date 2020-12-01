import 'package:flutter/material.dart';

class DataSource extends DataTableSource {
  List _breakdown;
  String sourceBy;

  void setSource(List src, String srcBy) {
    _breakdown = src;
    sourceBy = srcBy;

    notifyListeners();
  }

  void sort(String colName, bool ascending) {
    if (colName == 'Number') {
      _breakdown.sort((a, b) =>
          ascending ? a.value.compareTo(b.value) : b.value.compareTo(a.value));
    }

    if (colName == 'City') {
      _breakdown.sort((a, b) {
        String citya = a.key.split('*')[1];
        String cityb = b.key.split('*')[1];

        return ascending ? citya.compareTo(cityb) : cityb.compareTo(citya);
      });
    }

    if (colName == 'Province') {
      _breakdown.sort((a, b) {
        String provincea = a.key.split('*')[0];
        String provinceb = b.key.split('*')[0];

        return ascending
            ? provincea.compareTo(provinceb)
            : provinceb.compareTo(provincea);
      });
    }

    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final e = _breakdown[index];

    if (e.key.contains('*')) {
      List<String> splitted = e.key.split('*');
      String province = splitted[0];
      String city = splitted[1];

      return DataRow.byIndex(
        index: index,
        cells: [
          DataCell(Text(province)),
          DataCell(Text(city)),
          DataCell(Text(e.value.toString())),
        ],
      );
    } else {
      return DataRow.byIndex(
        index: index,
        cells: [
          DataCell(Text(e.key)),
          DataCell(Text(e.value.toString())),
        ],
      );
    }
  }
  
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _breakdown.length;

  @override
  int get selectedRowCount => 0;
}
