import 'package:flutter/material.dart';

import 'Report.dart';
import 'Accnt.dart';
import 'Bill.dart';


class TabPage extends StatefulWidget {
  TabPage();
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  List _pages=[0,1];
  _TabPageState();
  @override
  void initState() {
    super.initState();
    _pages = [
      Bill(),
      Accnt(),
      // Report()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        fixedColor: Colors.deepOrange,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long), title: Text('기록',style: TextStyle(
            fontWeight: FontWeight.bold
          ),),),
          BottomNavigationBarItem(
              icon: Icon(Icons.present_to_all), title: Text('올리기')),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.addchart), title: Text('Report')
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
