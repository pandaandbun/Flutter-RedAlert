import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Database/missing_person_database.dart';

class MissingPersonListTile extends StatefulWidget {
  final Person person;
  final savedPeople;

  MissingPersonListTile(this.person, this.savedPeople);

  @override
  _MissingPersonListTileState createState() => _MissingPersonListTileState();
}

class _MissingPersonListTileState extends State<MissingPersonListTile> {
  bool _selectedIndex = false;
  final DateFormat formatter = DateFormat('dd MMMM yyyy');

  void refresh() {
    setState(() {
      _selectedIndex = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _wrapper();
  }

  Widget _wrapper() {
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
          child: _listTile(),
          onLongPress: _moreInfo,
        ));
  }

  Widget _listTile() {
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
            widget.savedPeople.ids.add(widget.person.reference.id);
            widget.savedPeople.refreshStates.add(refresh);
          } else {
            widget.savedPeople.ids.remove(widget.person.reference.id);
            widget.savedPeople.refreshStates.remove(refresh);
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
            title: Text(widget.person.firstName + " " + widget.person.lastName),
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      SimpleDialogOption(
                        child: Text(formattedDate),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SimpleDialogOption(
                        child: const Text('More work to be done...'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        })) {
    }
  }
}
