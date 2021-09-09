import 'package:flutter/material.dart';

import 'LoginPage.dart';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'login demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
    );
  }
}


class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 90.0,
              child: const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                ),
                child: Text('Drawer Header'),
              ),
            ),
            ListTile(
              title: const Text('내정보 '),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('처리 목asdfas록'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),ListTile(
              title: const Text('증빙 처리'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text('main'),
            Text('body'),
            Text('vidw'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        fixedColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), title: Text('계정 정보')),
          BottomNavigationBarItem(
              icon: Icon(Icons.present_to_all), title: Text('처리 목록')),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), title: Text('증빙 처리')),
        ],
      ),
      );
  }
}
