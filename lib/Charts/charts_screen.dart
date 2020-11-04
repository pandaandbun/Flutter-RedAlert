import 'package:flutter/material.dart';
import '../settings_btn.dart';
import '../drawer.dart';
import 'chart_selector.dart';


class Charts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Charts'),
          actions: [SettingsBtn()],
        ),
        drawer: DrawerMenu(),
        body: Column(children: [
          ChartSelector(),
        ]));
  }
}
