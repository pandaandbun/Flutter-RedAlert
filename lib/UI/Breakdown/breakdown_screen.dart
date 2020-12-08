import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../settings_btn.dart';
import '../drawer.dart';
import '../are_you_sure_you_want_to_exit.dart';

import '../../Database/missing_person_database.dart';

import 'Chart/chart_selector.dart';

import 'Data Table/data_table.dart';
import 'breakdown_func.dart';

class Breakdown extends StatelessWidget {
  final MissingPeopleModel missingPerson = MissingPeopleModel();
  final BreakdownFunc _breakdownFunc = BreakdownFunc();
  final int _numOfTabs = 2;

  @override
  Widget build(BuildContext context) {
    return _tabs();
  }

  Widget _tabs() => DefaultTabController(
      length: _numOfTabs,
      child: Scaffold(
        appBar: _appBar(),
        drawer: DrawerMenu(),
        body: _areYourSureYouWantToExitWarpper(),
      ));

  Widget _areYourSureYouWantToExitWarpper() => Builder(
      builder: (context) => WillPopScope(
          child: _futureTable(),
          onWillPop: () async {
            bool value = await showDialog<bool>(
                context: context, builder: (context) => ExitDialog());
            return value;
          }));

  // ---------------------------------------------------------

  AppBar _appBar() => AppBar(
        title: Text('Breakdowns'),
        actions: [SettingsBtn()],
        bottom: _tabBar(),
      );

  Widget _tabBar() => TabBar(
        tabs: [
          Tab(icon: Icon(Icons.table_chart)),
          Tab(icon: Icon(Icons.stacked_line_chart)),
        ],
      );

  // ---------------------------------------------------------

  Widget _futureTable() => FutureBuilder(
        future: missingPerson.getAllPeople(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              _breakdownFunc.people = snapshot.data;

              return _mainTabBarView();
            } else {
              return _waitingForMainViewTabBarView('Empty');
            }
          } else {
            return _waitingForMainViewTabBarView('Loading');
          }
        },
      );

  Widget _mainTabBarView() => TabBarView(
        dragStartBehavior: DragStartBehavior.down,
        children: [
          BreakdownTable(_breakdownFunc),
          ChartSelector(_breakdownFunc),
        ],
      );

  Widget _waitingForMainViewTabBarView(String type) => TabBarView(
        children: _loadingText(type),
      );

  List<Widget> _loadingText(String type) {
    List<Widget> text = [];
    for (int i = 0; i < _numOfTabs; i++) {
      text.add(Text(type));
    }
    return text;
  }
}
