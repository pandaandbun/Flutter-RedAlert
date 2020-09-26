import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        decoration: const InputDecoration(
          suffixIcon: Icon(Icons.search),
          hintText: 'John Doe',
          labelText: 'Enter The Missing Person Name',
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(),
        ),
        validator: (String value) => null,
      ),
    );
  }
}
