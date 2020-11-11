import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Database/missing_person_database.dart';
import '../Database/selected_item_model.dart';

class MissingPersonListTile extends StatefulWidget {
  final Person person;

  MissingPersonListTile(this.person);

  @override
  _MissingPersonListTileState createState() => _MissingPersonListTileState();
}

class _MissingPersonListTileState extends State<MissingPersonListTile> {
  bool _selectedIndex = false;
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');

  void refresh(bool bool) {
    setState(() {
      _selectedIndex = bool;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SelectedPeopleModel selectedPeopleModel =
        context.watch<SelectedPeopleModel>();

    List<String> selectedPeople = selectedPeopleModel.getDocIds();

    if (selectedPeople.length == 0) {
      refresh(false);
    } else if (selectedPeople.contains(widget.person.reference.id)) {
      refresh(true);
    }

    return _wrapper(selectedPeopleModel);
  }

  Widget _wrapper(SelectedPeopleModel selectedPeopleModel) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: _selectedIndex ? Colors.brown[900] : Colors.brown,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.brown[300], spreadRadius: 3),
          ],
        ),
        margin: EdgeInsets.only(left: 20, right: 20, top: 15),
        child: GestureDetector(
          child: _listTile(selectedPeopleModel),
          onLongPress: _moreInfo,
        ));
  }

  Widget _listTile(SelectedPeopleModel selectedPeopleModel) {
    String formattedDate = formatter.format(widget.person.missingSince);

    return Ink(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.person.image),
          radius: 30,
        ),
        title: Text(
          widget.person.firstName + " " + widget.person.lastName,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          formattedDate,
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(Icons.person),
        onTap: () => setState(() {
          _selectedIndex = !_selectedIndex;

          if (_selectedIndex) {
            selectedPeopleModel.insertDocId(widget.person.reference.id);
          } else {
            selectedPeopleModel.removeDocId(widget.person.reference.id);
          }
        }),
      ),
    );
  }

  Future<void> _moreInfo() async {
    String formattedDate = formatter.format(widget.person.missingSince);

    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              widget.person.firstName + " " + widget.person.lastName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0),
            ),
            children: [
              Image(
                image: NetworkImage(widget.person.image),
                height: 140,
                fit: BoxFit.contain,
              ),
              Container(
                margin: EdgeInsets.only(left: 50),
                child: SimpleDialogOption(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Row(children: [
                        Expanded(
                            child: Text(
                          'Last Seen: $formattedDate',
                          style: TextStyle(fontSize: 15),
                        )),
                      ]),
                      SizedBox(
                        height: 15,
                      ),
                      Row(children: [
                        Expanded(
                            child: Text(
                          'Last Location: ${widget.person.city}, ${widget.person.province}',
                          style: TextStyle(fontSize: 15),
                        )),
                      ]),
                      SizedBox(
                        height: 15,
                      ),
                      Row(children: [
                        Expanded(
                            child: Text(
                          'Last Seen: $formattedDate',
                          style: TextStyle(fontSize: 15),
                        )),
                      ]),
                    ],
                  ),
                ),
              )
            ],
          );
        })) {
    }
  }
}
