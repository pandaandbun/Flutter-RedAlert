import 'package:flutter/material.dart';
import '../settings_btn.dart';
import '../drawer.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        actions: [SettingsBtn()],
      ),
      drawer: DrawerMenu(),
      body: null,
    );
  }
}
