import 'package:flutter/material.dart';

import '../../Database/missing_person_database.dart';

import '../drawer.dart';

class SyncScreen extends StatefulWidget {
  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final MissingPeopleModel missingPeopleModel = MissingPeopleModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sync'),
      ),
      drawer: DrawerMenu(),
      backgroundColor: Colors.brown[900],
      body: _content(),
    );
  }

  Future<bool> myTypedFuture() async {
    return Future.delayed(
      Duration(seconds: 1),
    );
  }

  Widget _content() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _localDbStatusText(),
          _btns(),
          _backToMainPageBtn(),
        ],
      );

  Widget _localDbStatusText() => FutureBuilder(
        future: missingPeopleModel.isDbEmpty(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return Text(
                "Local DB is Empty",
                style: TextStyle(color: Colors.white),
                textScaleFactor: 2,
              );
            } else {
              return Text(
                "Local DB is Sync",
                style: TextStyle(color: Colors.white),
                textScaleFactor: 2,
              );
            }
          } else {
            return Text(
              "Loading Status....",
              style: TextStyle(color: Colors.white),
              textScaleFactor: 2,
            );
          }
        },
      );

  Widget _btns() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _refreshBtn(),
          _downloadBtn(),
          _deleteBtn(),
        ],
      );

  Widget _refreshBtn() => IconButton(
        icon: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        onPressed: () {
          missingPeopleModel.refreshLocalDb().then((value) => setState(() {}));
        },
      );

  Widget _downloadBtn() => IconButton(
        icon: Icon(
          Icons.cloud_download,
          color: Colors.white,
        ),
        onPressed: () {
          missingPeopleModel
              .downloadAllPeopleToDb()
              .then((value) => setState(() {}));
        },
      );

  Widget _deleteBtn() => IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        onPressed: () {
          missingPeopleModel.deleteAllPeople().then((value) => setState(() {}));
        },
      );

  Widget _backToMainPageBtn() => ElevatedButton(
        onPressed: () => Navigator.pushReplacementNamed(context, '/missing'),
        child: Text("To Main Page"),
      );
}
