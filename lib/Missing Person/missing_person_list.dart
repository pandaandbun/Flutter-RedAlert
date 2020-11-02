import 'package:flutter/material.dart';
import 'missing_person_list_tile.dart';
import '../Database/missing_person_database.dart';

class MissingPersonList extends StatefulWidget {
  final savedPeople;

  MissingPersonList(this.savedPeople);

  @override
  _MissingPersonListState createState() => _MissingPersonListState();
}

class _MissingPersonListState extends State<MissingPersonList> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: people.length,
      itemBuilder: (BuildContext context, int index) => MissingPersonListTile(
        people[index],
        widget.savedPeople,
      ),
    ));
  }
}
