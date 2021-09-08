import 'dart:io';

import 'package:flutter/material.dart';
import 'main.dart';

class Accnt extends StatelessWidget {
  int _selectedIndex = 0;

  List _pages=[0,1,2];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[100],
      appBar: AppBar(
        backgroundColor: Colors.cyan,
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
        title: Text('영수증'),

      ),
      body: Center(
        child: Text('영수증'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: (){
          // _getImage();
        },
        child: Icon(Icons.add,color: Colors.black,),
      ),
    );
  }

}


