import 'package:flutter/material.dart';

class SavedPerson extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: "Settings",
            onPressed: null,
          )
        ],
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) => ListTile(
          leading: Icon(Icons.child_care),
          title: Text("John Doe"),
          subtitle: Text("Missing Since 2006"),
        ),
        separatorBuilder: (BuildContext context, int index) => Divider(
          color: Colors.transparent,
        ),
        itemCount: 10,
      )
    );
  }
}
