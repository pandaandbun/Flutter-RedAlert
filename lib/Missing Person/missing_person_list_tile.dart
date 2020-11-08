import 'package:flutter/material.dart';
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

  void refresh() {
    setState(() {
      _selectedIndex = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: _selectedIndex ? Colors.grey : Colors.transparent,
      child: ListTile(
        leading: Image.network(widget.person.image),
        title:
            Text(widget.person.firstName+ " " + widget.person.lastName),
        subtitle: Text(widget.person.missingSince.toString()),
        onTap: () => setState(() {
          _selectedIndex = !_selectedIndex;

          if (_selectedIndex) {
            widget.savedPeople.ids.add(widget.person.reference.id);
            widget.savedPeople.refreshStates.add(refresh);
          } else{
            widget.savedPeople.ids.remove(widget.person.reference.id);
            widget.savedPeople.refreshStates.remove(refresh);
          }
        }),
      ),
    );
  }
}
