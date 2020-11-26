import 'package:flutter/material.dart';
import 'data_table_source.dart';

class BreakdownTable extends StatefulWidget {

  final DataSource _dataSource = DataSource();

  BreakdownTable(Map breakdown) {
    _dataSource.setSource(breakdown.entries.toList());
  }

  @override
  _BreakdownTableState createState() => _BreakdownTableState();
}

class _BreakdownTableState extends State<BreakdownTable> {
  bool _sortAscending = false;
  int _sortColumnIndex = 0;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;


  void sort(int index, bool ascending, DataSource _dataSource) {

    setState(() {
      _sortColumnIndex = index;
      _sortAscending = ascending;
    });

    _dataSource.sort(index, ascending);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _dataTable(),
    );
  }

  Widget _dataTable() {
    return PaginatedDataTable(
      header: Text("Missing People by Location"),
      columns: _dataColumn(),
      source: widget._dataSource,
      onRowsPerPageChanged: (r) {
        setState(() {
          _rowsPerPage = r;
        });
      },
      rowsPerPage: _rowsPerPage,
      sortAscending: _sortAscending,
      sortColumnIndex: _sortColumnIndex,
    );
  }

  List<DataColumn> _dataColumn() => [
        DataColumn(
            label: Text('Province'),
            onSort: (index, ascending) {
              sort(index, ascending, widget._dataSource);
            }),
        DataColumn(
            label: Text('City'),
            onSort: (index, ascending) {
              sort(index, ascending, widget._dataSource);
            }),
        DataColumn(
            label: Icon(Icons.people),
            numeric: true,
            onSort: (index, ascending) {
              sort(index, ascending, widget._dataSource);
            }),
      ];
}
