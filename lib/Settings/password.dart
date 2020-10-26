import 'package:flutter/material.dart';
import 'package:Red_Alert/drawer.dart';
/*
class Password extends StatefulWidget {
  @override
  PasswordPage createState() => PasswordPage();
}

class PasswordPage extends State<Password> {
  */
  class Password extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Password')),
      drawer: DrawerMenu(),
      body: Column(
        children: [
          _goBack(),
        ],
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
