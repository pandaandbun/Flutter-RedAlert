import 'package:flutter/material.dart';

import '../settings_btn.dart';
import '../search_bar.dart';
import '../sort_by.dart';
import '../drawer.dart';

import 'saved_person_list.dart';

class SavedPersonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Saved'),
          actions: [SettingsBtn()],
        ),
        drawer: DrawerMenu(),
        body: Column(children: [
          SearchBar(),
          SortBy(),
          SavedPersonList()
        ]));
  }
}
