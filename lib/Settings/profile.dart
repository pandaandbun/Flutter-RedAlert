import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  ProfilePage createState() => ProfilePage();
}

class ProfilePage extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: _goBack(), title: Text('Profile')),
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
