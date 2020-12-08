import 'package:flutter/material.dart';

import '../settings_btn.dart';
import '../Search Bar/search_bar.dart';
import '../drawer.dart';
import '../are_you_sure_you_want_to_exit.dart';

import 'saved_person_list.dart';

// Save Person Screen Main Page
class SavedPersonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }

  Widget _scaffold() => Scaffold(
        appBar: AppBar(
          title: Text('Saved'),
          actions: [SettingsBtn()],
        ),
        drawer: DrawerMenu(),
        backgroundColor: Colors.brown[900],
        body: _areYourSureYouWantToExitWarpper(),
      );

  Widget _areYourSureYouWantToExitWarpper() => Builder(
      builder: (context) => WillPopScope(
          child: _body(),
          onWillPop: () async {
            bool value = await showDialog<bool>(
                context: context, builder: (context) => ExitDialog());
            return value;
          }));

  Widget _body() => Column(children: [
        Row(
          children: [
            SearchBar(),
          ],
        ),
        SavedPersonList(),
      ]);
}
