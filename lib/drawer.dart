import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String currentRoute = ModalRoute.of(context).settings.name;

    return Drawer(
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
          onTap: () => currentRoute == '/'
              ? Navigator.pop(context)
              : Navigator.pushReplacementNamed(context, '/'),
        ),
        ListTile(
            leading: Icon(Icons.map),
            title: Text('Map'),
            onTap: () {
              if (currentRoute == '/map') {
                Navigator.pop(context);
              } else if (currentRoute == '/') {
                Navigator.pushNamed(context, '/map');
              } else {
                Navigator.pushReplacementNamed(context, '/map');
              }
            }),
        ListTile(
            leading: Icon(Icons.save),
            title: Text('Saved'),
            onTap: () {
              if (currentRoute == '/saved') {
                Navigator.pop(context);
              } else if (currentRoute == '/') {
                Navigator.pushNamed(context, '/saved');
              } else {
                Navigator.pushReplacementNamed(context, '/saved');
              }
            }),
      ]),
    );
  }
}
