import 'package:flutter/material.dart';
import 'search_list.dart';
import 'search_form.dart';

class Name {
  String firstName;
  String lastName;
}

class SearchBar extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Name name = Name();

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
      title: Icon(Icons.search),
      children: [
        SearchForm(_formKey, name),
        searchBtn(context),
      ],
    ));
  }

  Widget searchBtn(context) => RaisedButton(
        child: Icon(Icons.search),
        onPressed: () {
          _formKey.currentState.save();
          if (name.firstName.isNotEmpty || name.lastName.isNotEmpty) {
            _findPeople(context);
          }
        },
      );
}
