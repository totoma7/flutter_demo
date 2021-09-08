import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'main.dart';


class Report extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.indigo[800],
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                color: Colors.black,
                onPressed: () {
                  // 로그아웃
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (BuildContext context) => MyApp()), (
                      route) => false);
                },
              ),
            ],
            title: Text('보고서'),

        bottom: TabBar(
          indicatorColor: Colors.cyan,
          indicatorWeight: 5.0,
          labelColor: Colors.white,
          labelPadding: EdgeInsets.only(top: 10.0),
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              text: '사용금액',
              iconMargin: EdgeInsets.only(bottom: 10.0),
            ),
            Tab(
              text: '진행금액',
              iconMargin: EdgeInsets.only(bottom: 10.0),
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          Center(
              child: Text(
                '결재 진행 금액 차트',
                style: TextStyle(fontSize: 25),
              )),
          Center(
            child: Text(
              '당월월별 사용금액',
              style: TextStyle(fontSize: 28),
            ),
          ),
        ],
      ),
    ),);
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

