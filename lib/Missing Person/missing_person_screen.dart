import 'package:flutter/material.dart';
import '../settings_btn.dart';
import '../drawer.dart';
import '../search_bar.dart';
import '../sort_by.dart';
import 'missing_person_list.dart';

class MissingPerson extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Missing Person'),
        actions: [SettingsBtn()],
      ),
      drawer: DrawerMenu(),
      body: Column(
        children: [
          SearchBar(),
          SortBy(),
          MissingPersonList(),
        ],
      ),
    );
  }
}
