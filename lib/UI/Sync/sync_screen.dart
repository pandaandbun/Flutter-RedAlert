import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Database/missing_person_database.dart';

import '../drawer.dart';

class SyncScreen extends StatefulWidget {
  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  @override
  Widget build(BuildContext context) {
    MissingPeopleModel missingPeopleModel = context.watch<MissingPeopleModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sync'),
      ),
      drawer: DrawerMenu(),
      backgroundColor: Colors.brown[900],
      body: _content(missingPeopleModel),
    );
  }

  Widget _content(missingPeopleModel) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _localDbStatusText(missingPeopleModel),
          _btns(missingPeopleModel),
          _backToMainPageBtn(),
        ],
      );

  // ----------------------------------------------------

  Widget _localDbStatusText(missingPeopleModel) => FutureBuilder(
        future: missingPeopleModel.isDbEmpty(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return _emptyText();
            } else {
              return _fullText();
            }
          } else {
            return _loadingText();
          }
        },
      );

  Widget _emptyText() => Text(
        "Local DB is Empty",
        style: TextStyle(color: Colors.white),
        textScaleFactor: 2,
      );

  Widget _fullText() => Text(
        "Local DB is Sync",
        style: TextStyle(color: Colors.white),
        textScaleFactor: 2,
      );

  Widget _loadingText() => Text(
        "Loading Status....",
        style: TextStyle(color: Colors.white),
        textScaleFactor: 2,
      );

  // ----------------------------------------------------

  Widget _btns(missingPeopleModel) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _refreshBtn(missingPeopleModel),
          _downloadBtn(missingPeopleModel),
          _deleteBtn(missingPeopleModel),
        ],
      );

  Widget _refreshBtn(missingPeopleModel) => IconButton(
        icon: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        onPressed: () {
          missingPeopleModel.refreshLocalDb();
        },
      );

  Widget _downloadBtn(missingPeopleModel) => IconButton(
        icon: Icon(
          Icons.cloud_download,
          color: Colors.white,
        ),
        onPressed: () {
          missingPeopleModel.downloadAllPeopleToDb();
        },
      );

  Widget _deleteBtn(missingPeopleModel) => IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        onPressed: () {
          missingPeopleModel.deleteAllPeople();
        },
      );

  // ----------------------------------------------------

  Widget _backToMainPageBtn() => ElevatedButton(
        onPressed: () => Navigator.pushReplacementNamed(context, '/missing'),
        child: Text("To Main Page"),
      );
}
