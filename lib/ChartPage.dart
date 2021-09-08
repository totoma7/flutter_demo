// import 'package:flutter/material.dart';
// import 'package:pie_chart/pie_chart.dart';
// import 'PieChart.dart';
//
// class ChartPage extends StatelessWidget {
//   List<double> points = [50, 0, 73, 100, 150, 120, 200, 80];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Chart Page"),
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Center(
//           child: Column(
//             children: <Widget>[
//               Container(
//                 child: CustomPaint(
//                   // CustomPaint를 그리고 이 안에 차트를 그려줍니다..
//                   size: Size(150, 150),
//                   // CustomPaint의 크기는 가로 세로 150, 150으로 합니다.
//                   painter: PieChart(
//                       percentage: 50, // 파이 차트가 얼마나 칠해져 있는지 정하는 변수입니다.
//                       textScaleFactor: 1.0, // 파이 차트에 들어갈 텍스트 크기를 정합니다.
//                       textColor: Colors.blueGrey,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
