import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String currentRoute = ModalRoute.of(context).settings.name;

    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        drawerHeader(),
        missingScreenDrawer(currentRoute, context),
        savedSceeenDrawer(currentRoute, context),
        mapScreenDrawer(currentRoute, context),
        chartScreenDrawer(currentRoute, context),
      ]),
    );
  }

  Widget drawerHeader() => DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.brown[900],
      ),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_alert,
            color: Colors.white,
          ),
          Text(
            'Red Alert',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ],
      )));

  Widget missingScreenDrawer(String currentRoute, context) => ListTile(
        leading: Icon(Icons.list),
        title: Text('Missing Person'),
        onTap: () => currentRoute == '/'
            ? Navigator.pop(context)
            : Navigator.pushReplacementNamed(context, '/'),
      );

  Widget savedSceeenDrawer(String currentRoute, context) => ListTile(
        leading: Icon(Icons.save),
        title: Text('Saved'),
        onTap: () => currentRoute == '/saved'
            ? Navigator.pop(context)
            : Navigator.pushReplacementNamed(context, '/saved'),
      );

  Widget mapScreenDrawer(String currentRoute, context) => ListTile(
        leading: Icon(Icons.map),
        title: Text('Map'),
        onTap: () => currentRoute == '/map'
            ? Navigator.pop(context)
            : Navigator.pushReplacementNamed(context, '/map'),
      );

  Widget chartScreenDrawer(String currentRoute, context) => ListTile(
        leading: Icon(Icons.show_chart),
        title: Text('Charts'),
        onTap: () => currentRoute == '/charts'
            ? Navigator.pop(context)
            : Navigator.pushReplacementNamed(context, '/charts'),
      );
}
