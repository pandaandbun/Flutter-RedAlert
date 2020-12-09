import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

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
        _syncScreen(currentRoute, context),
        _about(),
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
        title: Text(FlutterI18n.translate(context, "drawer.missing_persons")),
        onTap: () => currentRoute == '/missing'
            ? Navigator.pop(context)
            : Navigator.pushReplacementNamed(context, '/missing'),
      );

  Widget savedSceeenDrawer(String currentRoute, context) => ListTile(
        leading: Icon(Icons.save),
        title: Text(FlutterI18n.translate(context, "drawer.saved")),
        onTap: () => currentRoute == '/saved'
            ? Navigator.pop(context)
            : Navigator.pushReplacementNamed(context, '/saved'),
      );

  Widget mapScreenDrawer(String currentRoute, context) => ListTile(
        leading: Icon(Icons.map),
        title: Text(FlutterI18n.translate(context, "drawer.map")),
        onTap: () => currentRoute == '/map'
            ? Navigator.pop(context)
            : Navigator.pushReplacementNamed(context, '/map'),
      );

  Widget chartScreenDrawer(String currentRoute, context) => ListTile(
        leading: Icon(Icons.show_chart),
        title: Text(FlutterI18n.translate(context, "drawer.breakdown")),
        onTap: () => currentRoute == '/charts'
            ? Navigator.pop(context)
            : Navigator.pushReplacementNamed(context, '/charts'),
      );

  Widget _syncScreen(String currentRoute, context) => ListTile(
        leading: Icon(Icons.cloud_download),
        title: Text(FlutterI18n.translate(context, "drawer.sync")),
        onTap: () => currentRoute == '/sync'
            ? Navigator.pop(context)
            : Navigator.pushReplacementNamed(context, '/sync'),
      );

  Widget _about() => AboutListTile(
        icon: Icon(Icons.info),
        applicationIcon: FlutterLogo(),
        applicationName: 'Red Alert',
        applicationVersion: 'December 2020',
        applicationLegalese: '\u{a9} Rico, Jessica, Joseph',
        aboutBoxChildren: [
          SizedBox(height: 24),
          Text(
              "Missing persons information was retrieved from canadasmissing.ca"),
        ],
      );
}
