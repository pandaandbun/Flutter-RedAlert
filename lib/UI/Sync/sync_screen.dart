import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Database/missing_person_database.dart';

import '../drawer.dart';
import '../are_you_sure_you_want_to_exit.dart';

class SyncScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MissingPeopleModel missingPeopleModel = context.watch<MissingPeopleModel>();

    return _scaffold(missingPeopleModel);
  }

  Widget _scaffold(MissingPeopleModel missingPeopleModel) => Scaffold(
        appBar: AppBar(
          title: Text('Sync'),
        ),
        drawer: DrawerMenu(),
        backgroundColor: Colors.brown[900],
        body: _areYourSureYouWantToExitWarpper(missingPeopleModel),
      );

  Widget _areYourSureYouWantToExitWarpper(
          MissingPeopleModel missingPeopleModel) =>
      Builder(
          builder: (context) => WillPopScope(
              child: _body(missingPeopleModel),
              onWillPop: () async {
                bool value = await showDialog<bool>(
                    context: context, builder: (context) => ExitDialog());
                return value;
              }));

  Widget _body(MissingPeopleModel missingPeopleModel) => Column(
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

  Widget _backToMainPageBtn() => Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/missing'),
          child: Text("To Main Page"),
        ),
      );
}
