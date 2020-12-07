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

  Widget _content(MissingPeopleModel missingPeopleModel) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _localDbStatusText(missingPeopleModel),
          _btns(missingPeopleModel),
          _backToMainPageBtn(),
        ],
      );

  // ----------------------------------------------------

  Widget _localDbStatusText(MissingPeopleModel missingPeopleModel) =>
      FutureBuilder(
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

  Widget _btns(MissingPeopleModel missingPeopleModel) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            _refreshBtn(missingPeopleModel),
            SizedBox(height: 10),
            _downloadBtn(missingPeopleModel),
            SizedBox(height: 10),
            _deleteBtn(missingPeopleModel),
            SizedBox(height: 10),
          ],
        ),
      );

  Widget _refreshBtn(MissingPeopleModel missingPeopleModel) =>
      FloatingActionButton(
        child: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        onPressed: () => missingPeopleModel.refreshLocalDb(),
        heroTag: "btn1",
      );

  Widget _downloadBtn(MissingPeopleModel missingPeopleModel) =>
      FloatingActionButton(
        child: Icon(
          Icons.cloud_download,
          color: Colors.white,
        ),
        onPressed: () => missingPeopleModel.downloadAllPeopleToDb(),
        heroTag: "btn2",
      );

  Widget _deleteBtn(MissingPeopleModel missingPeopleModel) =>
      FloatingActionButton(
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        onPressed: () => missingPeopleModel.deleteAllPeople(),
        heroTag: "btn3",
      );

  // ----------------------------------------------------

  Widget _backToMainPageBtn() => ElevatedButton(
        onPressed: () => Navigator.pushReplacementNamed(context, '/missing'),
        child: Text("To Main Page"),
      );
}
