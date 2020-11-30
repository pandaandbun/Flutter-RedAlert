import 'package:flutter/material.dart';

import '../breakdown_func.dart';
import 'data_table_source.dart';

class BreakdownTable extends StatefulWidget {
  final BreakdownFunc _breakdownFunc;
  final DataSource _dataSource = DataSource();

  BreakdownTable(this._breakdownFunc) {
    _dataSource.setSource(_breakdownFunc.byCity.entries.toList(), "City");
  }

  @override
  _BreakdownTableState createState() => _BreakdownTableState();
}

class _BreakdownTableState extends State<BreakdownTable> {
  bool _sortAscending = false;
  int _sortColumnIndex = 0;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  String _sourceByCity = "City";
  String _sourceByProvince = "Province";

  void sort(int index, String colName, bool ascending, DataSource _dataSource) {
    setState(() {
      _sortColumnIndex = index;
      _sortAscending = ascending;
    });

    _dataSource.sort(colName, ascending);
  }

  void _onRowsPerPageChanged(r) {
    setState(() {
      _rowsPerPage = r;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _dataTable(),
    );
  }

  Widget _dataTable() => PaginatedDataTable(
        header: _header(),
        columns: widget._dataSource.sourceBy == _sourceByCity
            ? _provinceAndCityColumn()
            : provineColumn(),
        source: widget._dataSource,
        onRowsPerPageChanged: _onRowsPerPageChanged,
        rowsPerPage: _rowsPerPage,
        sortAscending: _sortAscending,
        sortColumnIndex: _sortColumnIndex,
      );

  Widget _header() => Row(children: [
        Text("Missing People by"),
        TextButton(
          onPressed: () => setState(() {
            String _newSourceBy = widget._dataSource.sourceBy == _sourceByCity
                ? _sourceByProvince
                : _sourceByCity;

            Map breakdown;
            if (_newSourceBy != _sourceByCity) {
              breakdown = widget._breakdownFunc.byProvince;
            } else {
              breakdown = widget._breakdownFunc.byCity;
            }

            widget._dataSource.setSource(
              breakdown.entries.toList(),
              _newSourceBy,
            );
          }),
          child: Text(widget._dataSource.sourceBy, textScaleFactor: 1.7),
        ),
      ]);

  List<DataColumn> _provinceAndCityColumn() => [
        DataColumn(
            label: Text('Province'),
            onSort: (index, ascending) {
              sort(index, "Province", ascending, widget._dataSource);
            }),
        DataColumn(
            label: Text('City'),
            onSort: (index, ascending) {
              sort(index, "City", ascending, widget._dataSource);
            }),
        DataColumn(
            label: Icon(Icons.people),
            numeric: true,
            onSort: (index, ascending) {
              sort(index, "Number", ascending, widget._dataSource);
            }),
      ];

  List<DataColumn> provineColumn() => [
        DataColumn(
            label: Text('Province'),
            onSort: (index, ascending) {
              sort(index, "Province", ascending, widget._dataSource);
            }),
        DataColumn(
            label: Icon(Icons.people),
            numeric: true,
            onSort: (index, ascending) {
              sort(index, "Number", ascending, widget._dataSource);
            }),
      ];
}
