import 'package:E_AC/tab_page.dart';
import 'package:flutter/material.dart';


import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final formKey = new GlobalKey<FormState>();
  var _isChecked = false; //checkbox or swtich의 체크상태는 false로 지정. _ 는 private
  final _key = GlobalKey();
  late String _email;
  late String _password;
  bool _isVisible = true;
  bool _flag = true;
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
        title: new Text('e-Accounting',
          style: TextStyle(
            color: Colors.white
          ),),
        backgroundColor: Colors.deepOrange[700],
      ),
      body: Column(
        children: [
          new Container(
            child: AnimatedOpacity(
              duration:  const Duration(milliseconds: 500),
              opacity: _isVisible ? 1.0 : 0.0,
              child:
                Visibility(child: Image(
                    image: AssetImage('assets/images/4.gif'),
                    height: 240,
                    width: 400.0,
                  ),
                  visible: _isVisible,
                ),
            ),
          ),
          new Container(
            padding: EdgeInsets.all(5),
            child: new Form(
              key: formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new TextFormField(
                    decoration: new InputDecoration(labelText: '사용자 ID'),
                    validator: (value) =>
                    value!.isEmpty ? 'Email can\'t be empty' : null,
                    onSaved: (value) => _email = value!,
                    onTap: (){
                      setState(() {
                        _isVisible = false;
                      });
                    },
                  ),
                  new TextFormField(
                    obscureText: true,
                    decoration: new InputDecoration(labelText: '비밀 번호'),
                    validator: (value) =>
                    value!.isEmpty ? 'Password can\'t be empty' : null,
                    onSaved: (value) => _password = value!,
                    onTap: () {
                      setState(() {
                        _isVisible = false;
                      });
                    },

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
                      Text('자동 로그인 '),
                      SizedBox(width: 20,),
                      new ElevatedButton(
                        child: new Text(_flag ? '로그인' : '로그인',
                          style: new TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,

                          ),
                        ),
                        // onPressed: validateAndSave,
                        onPressed:(){
                          setState((){
                            validateAndSave();
                          });
                        },
                      style: ElevatedButton.styleFrom(
                      primary:  Colors.red ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

