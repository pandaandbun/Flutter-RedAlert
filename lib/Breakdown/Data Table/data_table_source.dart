import 'package:flutter/material.dart';

class DataSource extends DataTableSource {
  List _breakdown;

  void setSource(List src) {
    _breakdown = src;
  }

  void sort(int index, bool ascending) {

    if (index == 2) {
      _breakdown.sort((a, b) =>
          ascending ? a.value.compareTo(b.value) : b.value.compareTo(a.value));
    }

    if (index == 1) {
      _breakdown.sort((a, b) {
        String citya = a.key.split('*')[1];
        String cityb = b.key.split('*')[1];

        return ascending ? citya.compareTo(cityb) : cityb.compareTo(citya);
      });
    }

    if (index == 0) {
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
  }

  @override
  bool get isRowCountApproximate => true;

  @override
  int get rowCount => _breakdown.length;

  @override
  int get selectedRowCount => 0;
}