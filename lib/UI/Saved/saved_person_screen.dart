import 'package:flutter/material.dart';

import '../settings_btn.dart';
import '../Search Bar/search_bar.dart';
import '../drawer.dart';

import 'saved_person_list.dart';

// Save Person Screen Main Page
class SavedPersonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Saved'),
          actions: [SettingsBtn()],
        ),
        drawer: DrawerMenu(),
        backgroundColor: Colors.brown[900],
        body: Column(children: [
          Row(
            children: [
              SearchBar(),
            ],
          ),
          SavedPersonList(),
        ]));
  }
}
