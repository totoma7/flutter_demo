import 'package:flutter/material.dart';

import 'main.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        backgroundColor: Colors.amber,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.black,
            onPressed: () {
              // 로그아웃
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => MyApp()), (route) => false);
            },
          )
        ],
        title: Text('보고서',style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),),

      ),

      body: Center(
        child: Text('보고서'),
      ),
    );
  }
}
