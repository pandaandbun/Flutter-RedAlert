import 'package:flutter/material.dart';

class DataSource extends DataTableSource {
  List _breakdown;
  String sourceBy, category;

  void setSource(List src, String srcBy, String cat) {
    _breakdown = src;
    sourceBy = srcBy;
    category = cat;

    notifyListeners();
  }

  void sort(String colName, bool ascending) {
    if (colName == 'Number') {
      _breakdown.sort((a, b) =>
          ascending ? a.value.compareTo(b.value) : b.value.compareTo(a.value));
    }

    if (colName == 'City' || colName == 'Month') {
      _breakdown.sort((a, b) {
        String aKey = a.key.split('*')[1];
        String bKey = b.key.split('*')[1];

        return ascending ? aKey.compareTo(bKey) : bKey.compareTo(aKey);
      });
    }

    if (colName == 'Province' || colName == 'Year') {
      _breakdown.sort((a, b) {
        String aKey = a.key.split('*')[0];
        String bKey = b.key.split('*')[0];

        return ascending ? aKey.compareTo(bKey) : bKey.compareTo(aKey);
      });
    }

    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final e = _breakdown[index];

    if (index >= _breakdown.length) return null;

    if (e.key.contains('*')) {
      List<String> splitted = e.key.split('*');

      String firstCol = splitted[0];
      String secondCol = splitted[1];

      return DataRow.byIndex(
        index: index,
        cells: [
          DataCell(Text(firstCol)),
          DataCell(Text(secondCol)),
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
