import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'missing_person_list_tile.dart';
import '../Database/saved_people_database.dart';

class MissingPersonList extends StatefulWidget {
  final savedPeople;
  final db = FirebaseFirestore.instance;

  MissingPersonList(this.savedPeople);

  @override
  _MissingPersonListState createState() => _MissingPersonListState();
}

class _MissingPersonListState extends State<MissingPersonList> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot> (
      future: getPersons(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasError) {
          return Text(
            "Error building list",
            textDirection: TextDirection.ltr
          );
        }
        else if(snapshot.connectionState == ConnectionState.done) {
          List<Person> people = snapshot.data.docs.map((DocumentSnapshot document) => _buildPerson(context, document)).toList();
          return Expanded(
            child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: snapshot.data.size,
            itemBuilder: (BuildContext context, int index) => MissingPersonListTile(
              people[index],
              widget.savedPeople,
            ),
          ));
        }
        else {
          return Text(
            "Loading...",
            textDirection: TextDirection.ltr
          );
        }
      }
    );
  }

  Future<QuerySnapshot> getPersons() async {
    return await FirebaseFirestore.instance.collection('persons').get();
  }

  Person _buildPerson(BuildContext context, DocumentSnapshot data) {
    return Person.fromMap(data.data(), reference: data.reference);
  }
}
