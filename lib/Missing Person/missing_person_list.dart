import 'package:flutter/material.dart';

class MissingPersonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.separated(
      itemBuilder: (BuildContext context, int index) => ListTile(
        leading: Icon(Icons.pregnant_woman),
        title: Text("Jane Doe"),
        subtitle: Text("Missing Since 2006"),
      ),
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: Colors.transparent,
      ),
      itemCount: 10,
    ));
  }
}
