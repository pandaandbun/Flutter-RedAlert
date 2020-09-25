import 'package:flutter/material.dart';

class MissingPerson extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Missing Person'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: "Settings",
            onPressed: null,
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          DrawerHeader(
            child: Text(
              'Red Alert',
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Missing Person'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Map'),
            onTap: () => Navigator.pushNamed(context, '/map'),
          ),
          ListTile(
            leading: Icon(Icons.save),
            title: Text('Saved'),
            onTap: () => Navigator.pushNamed(context, '/saved'),
          ),
        ]),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) => ListTile(
          leading: Icon(Icons.pregnant_woman),
          title: Text("Jane Doe"),
          subtitle: Text("Missing Since 2006"),
        ),
        separatorBuilder: (BuildContext context, int index) => Divider(
          color: Colors.transparent,
        ),
        itemCount: 10,
      ),
    );
  }
}
