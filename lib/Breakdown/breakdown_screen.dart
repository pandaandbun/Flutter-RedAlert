import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../settings_btn.dart';
import '../drawer.dart';

import '../Database/missing_person_database.dart';

import 'Data Table/data_table.dart';
import 'Chart/chart_selector.dart';
import 'breakdown_func.dart';

class Breakdown extends StatelessWidget {
  final MissingPeopleModel missingPerson = MissingPeopleModel();
  final BreakdownFunc _breakdownFunc = BreakdownFunc();
  final int _numOfTabs = 2;

  Person _buildPerson(DocumentSnapshot data) {
    return Person.fromMap(data.data(), reference: data.reference);
  }

  @override
  Widget build(BuildContext context) {
    return _tabs();
  }

  Widget _tabs() => DefaultTabController(
      length: _numOfTabs,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Breakdowns'),
          actions: [SettingsBtn()],
          bottom: _tabBar(),
        ),
        drawer: DrawerMenu(),
        body: _streamTable(),
      ));

  Widget _tabBar() => TabBar(
        tabs: [
          Tab(icon: Icon(Icons.table_chart)),
          Tab(icon: Icon(Icons.stacked_line_chart)),
        ],
      );

  Widget _streamTable() => StreamBuilder(
        stream: missingPerson.getAllPeople(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              List<Person> people = snapshot.data.docs
                  .map((DocumentSnapshot document) => _buildPerson(document))
                  .toList()
                  .cast<Person>();

              _breakdownFunc.people = people;

              return _mainTabBarView();
            } else {
              return _loadingTabBarView('Empty');
            }
          } else {
            return _loadingTabBarView('Loading');
          }
        },
      );

  Widget _mainTabBarView() => TabBarView(
        dragStartBehavior: DragStartBehavior.down,
        children: [
          BreakdownTable(_breakdownFunc.getByCity()),
          ChartSelector(_breakdownFunc.getByProvince()),
        ],
      );

  Widget _loadingTabBarView(String type) => TabBarView(
        children: _loadingText(type),
      );

  List<Widget> _loadingText(String type) {
    List<Widget> temp = [];
    for (int i = 0; i < _numOfTabs; i++) {
      temp.add(Text(type));
    }
    return temp;
  }
}
