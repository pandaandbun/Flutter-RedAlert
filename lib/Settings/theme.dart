import 'package:flutter/material.dart';

/*
class ThemeP extends StatefulWidget {
  @override
  ThemePage createState() => ThemePage();
}

class ThemePage extends State<ThemeP> {
  */
class ThemeP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: _goBack(), title: Text('Theme')),
      body: Column(
        children: [],
      ),
    );
  }
}

class _goBack extends StatelessWidget {
  const _goBack({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
      onPressed: () => Navigator.pushReplacementNamed(context, '/settings'),
    );
  }
}
