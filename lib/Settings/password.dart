import 'package:flutter/material.dart';

class Password extends StatefulWidget {
  @override
  PasswordPage createState() => PasswordPage();
}

class PasswordPage extends State<Password> {
  bool _isEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: _goBack(), title: Text('Password')),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Builder(
          builder: (context) => ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 48.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Old Password'),
                      onSaved: (String value) {
                        //so something when saved
                      },
                      /*
                      validator: (String value){
                        return value.contains(other) //Old password checker
                      },
                      \*/
                      // ignore: missing_return
                      validator: (String txt){
                        if(txt.length >= 8){
                          setState(() {
                            _isEnabled = true;
                          });
                        } else{
                          setState(() {
                            _isEnabled = false;
                          });
                        }
                      },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 48.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'New Password'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 48.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Re-Enter New Password'),
                ),
              ),
              RaisedButton(
                color: Colors.red,
                textColor: Colors.white,
                disabledColor: Colors.grey.shade400,
                disabledTextColor: Colors.black,
                elevation: 10,
                splashColor: Colors.redAccent,
                //update password in database
                onPressed: (null), //still have to figure out how to disable/enable button
                child: Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _goBack extends StatelessWidget {
  const _goBack({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
      onPressed: () => Navigator.pushReplacementNamed(context, '/settings'),
    );
  }
}
