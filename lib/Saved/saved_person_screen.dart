import 'package:flutter/material.dart';
import '../settings_btn.dart';
import '../search_bar.dart';
import '../sort_by.dart';
import '../drawer.dart';

class SavedPerson extends StatelessWidget {
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
          Expanded(
              child: ListView.separated(
            itemBuilder: (BuildContext context, int index) => ListTile(
              leading: Icon(Icons.child_care),
              title: Text("John Doe"),
              subtitle: Text("Missing Since 2006"),
            ),
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.transparent,
            ),
            itemCount: 10,
          )),
        ]));
  }
}
