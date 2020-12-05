import 'package:flutter/material.dart';
import 'search_list.dart';
import 'search_form.dart';

// Class to store text field value
class Name {
  String firstName;
  String lastName;
}

// Search Bar
class SearchBar extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Name name = Name();

  // Show result as a dialog
  Future<void> _findPeople(scaffoldContext) async {
    await showDialog(
        context: scaffoldContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('People Found'),
            backgroundColor: Colors.brown[100],
            content: SearchList(name),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ExpansionTile(
      title: Icon(
        Icons.search,
        color: Colors.white,
      ),
      children: [
        SearchForm(_formKey, name),
        searchBtn(context),
      ],
    ));
  }

  // Search Icon Button
  Widget searchBtn(context) => RaisedButton(
        color: Colors.brown,
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: () {
          _formKey.currentState.save();
          if (name.firstName.isNotEmpty || name.lastName.isNotEmpty) {
            _findPeople(context);
          }
        },
      );
}
