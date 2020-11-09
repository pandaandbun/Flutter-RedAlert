import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: 300,
        margin: EdgeInsets.only(left:25,right:25),
        child: TextFormField(
          decoration: const InputDecoration(
            suffixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            hintText: 'John Doe',
            hintStyle: TextStyle(color: Colors.white),
            labelText: 'Enter The Missing Person Name',
            labelStyle: TextStyle(color: Colors.white),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            border: OutlineInputBorder(),
          ),
          style: TextStyle(
            color: Colors.white,
          ),
          validator: (String value) => null,
        ),
      ),
    );
  }
}
