import 'package:flutter/material.dart';
import 'package:flutter_layout/tab_page.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  var _isChecked = false; //checkbox or swtich의 체크상태는 false로 지정. _ 는 private

  late String _email;
  late String _password;

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid Email: $_email, password: $_password');
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => TabPage()), (route) => false);


    } else {
      print('Form is invalid Email: $_email, password: $_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text('login demo'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value!.isEmpty ? 'Email can\'t be empty' : null,
                onSaved: (value) => _email = value!,
              ),
              new TextFormField(
                obscureText: true,
                decoration: new InputDecoration(labelText: 'Password'),
                validator: (value) =>
                value!.isEmpty ? 'Password can\'t be empty' : null,
                onSaved: (value) => _password = value!,
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked, //처음엔 false
                    onChanged: (value) { //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                      setState(() {
                        _isChecked = value!; //true가 들어감.
                      });
                    },
                  ),
                  Text('자동 로그인 ')
                ],
              ),
              new RaisedButton(
                child: new Text(
                  'Login',
                  style: new TextStyle(fontSize: 20.0),
                ),
                onPressed: validateAndSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

