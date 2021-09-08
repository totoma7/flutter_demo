import 'package:flutter/material.dart';

import 'main.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        backgroundColor: Colors.teal,
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
        title: Text('지출 결의'),

      ),
      body: Center(
        child: Text('지출결의'),
      ),
    );
  }
}
