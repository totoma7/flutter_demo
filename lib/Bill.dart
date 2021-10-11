import 'dart:io';

import 'package:E_AC/Accnt.dart';
import 'package:E_AC/util/wave_clipper_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Bill extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class Picture {
  /*
  "email": "ilchul.jung@naver.com",
        "name": "sample1",
        "userId": "af42ebfb-a263-4c0d-be07-9a62daf8d48d"
 */

  String name;
  String id;
  String filename;
  int account;
  String filecontent;
  String filebyte;
  String insert_date;

  Picture(this.name, this.id, this.filename, this.filecontent, this.filebyte,this.insert_date,this.account);
}

class _HomeScreenState extends State<Bill> with AutomaticKeepAliveClientMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  List _data = [];
  int page = 1;
  int limit = 20;
  @override
  // TODO: implement wantKeepAlive 페이지 이동시 상태 유지값
  bool get wantKeepAlive => true;
  bool _isDialogVisible = false; //
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // String tokenString ="eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI3NzJmNzc3Mi0wN2Q4LTRhMGMtODQ5NC05NTMyYWRiZGIxMTIiLCJleHAiOjE2MzE3MDY0NjV9.A7-1CZX_M1bNUhgtM2S4rcBrqCXufwz1O9uLGkqkw1Uabueoqvn4aVzs26KKcgqOhKMHTu3s9k_GnHVJeZZa6g";
  Future<int> _fetchData() async {
    try {
      _scaffoldKey.currentState!.showSnackBar(addSnackBar());
    }catch(e ){

    }
    print('test');
    List? pictures;
    final response = await http.get(
      Uri.parse('http://222.108.225.7:18080/test/data?page=$page'),
      // Send authorization headers to the backend.
    );

    // setState(() {
    //   _isDialogVisible = true;
    // });

    print('success');
    if (response.statusCode == 200) {
      // String jsonString = response.body;
      var responseBody = utf8.decode(response.bodyBytes);
      print(responseBody);

      pictures = jsonDecode(responseBody);

      for (int i = 0; i < pictures!.length; i++) {
        var picture = pictures[i];
        Picture pictureToAdd = Picture(picture["name"], picture["id"],
            picture["filename"], picture["filecontent"], picture["filebyte"],picture["insert_date"],picture["account"]);
        print(pictureToAdd.filename);
        setState(() {
          _data.add(pictureToAdd);
        });
      }
      setState(() {
        page++;
      });
      // Future.delayed(Duration(seconds: 2), () {
      //   // 2초 뒤에 false로 변경
      //   setState(() {
      //     CircularProgressIndicator();
      //     // _isDialogVisible = false;
      //
      //   });
      // });
    } else {
      print('error');
    }
    int pCount = 0;
    pCount = pictures!.length;
    return pCount;
  }
  final pageController = PageController();
  void onPageChanged(int index) {
    setState(() {
      // _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO: implement build
    // final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey, //s
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          title: Text('증빙 선택'),
          backgroundColor: Colors.deepOrange[500],
          actions: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _fetchData();
                  },
                  icon: Icon(Icons.add),
                  tooltip: '더가져오기',
                  iconSize: 30,
                ),
              ],
            )
          ],
        ),
      ),
      body:   Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.deepOrange.withOpacity(0.7)
              ),
              height: 400,
            ),
          ),
          Scrollbar(
            thickness: 9,
            isAlwaysShown: true,
            radius: Radius.circular(3), // give t
        // color: Colors.white,
        child: ListView.builder(
          itemCount: _data.length,
            controller: pageController,
            // onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              Picture picture = _data[index];
              return Card(
                child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white, // background
                           onPrimary: Colors.red, // foreground
                          padding: EdgeInsets.all(1), // Set padding
                        ),
                        child: Image.memory(
                          base64Decode(picture.filebyte),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierColor: Colors.black87,

                            builder: (BuildContext context) {
                              return Container(
                                margin: EdgeInsets.all(1.0),
                                padding: EdgeInsets.all(1.0),
                                width: 10.0,
                                child: AlertDialog(
                                  backgroundColor: Colors.deepOrange,
                                  actionsPadding: EdgeInsets.symmetric(horizontal: 3.0),
                                  contentPadding: EdgeInsets.zero,
                                  titlePadding: EdgeInsets.zero,
                                  buttonPadding: EdgeInsets.zero,
                                  insetPadding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1.0)),
                                  content: Image.memory(
                                    base64Decode(picture.filebyte),
                                    // width: 400,
                                    // height: 400,
                                    //
                                    fit: BoxFit.cover,
                                  ),
                                  actions: <Widget>[
                                    new FlatButton(
                                      child: new Text("닫기"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(child: Text(picture.id+'번째  썸네일 '),margin: const EdgeInsets.all(8.0),),
                            Container(child: Text('금액  '+picture.account.toString() +"원"),margin: const EdgeInsets.all(8.0),),
                            Container(child: Text(picture.insert_date.substring(2,16).replaceAll("-", "/")+" upload"),margin: const EdgeInsets.all(8.0),),
                          ]),
                      // Visibility(
                      //         visible: _isDialogVisible,
                      //         child: Container(
                      //           color: Colors.black26,
                      //           alignment: Alignment.center,
                      //           child: Padding(
                      //             padding: EdgeInsets.all(10.0),
                      //             child: CircularProgressIndicator(),
                      //           ),
                      //         )
                      // ),
                    ]),
              );
            }),
      ),
    ]),
        floatingActionButton: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
              // padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
              child: ElevatedButton.icon(
                icon:Icon(Icons.add,size: 40),
                onPressed: () async {
                  // var count = "0";
                  int imgCount = 0;
                  imgCount = await _fetchData() ;
                  print('imgCount '+imgCount.toString());
                 if(imgCount.toString() != "0"){
                   Scaffold.of(context).removeCurrentSnackBar();
                   // _scaffoldKey.currentState!.showSnackBar(addSnackBar());
                 }else if(imgCount.toString() == "0"){
                   _scaffoldKey.currentState!.showSnackBar(zeroSnackBar());
                 }
                },
                label: Text(' 가져오기',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange, // background
                  onPrimary: Colors.white, // foreground
                ),
          ),
            ),
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
            //   // padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
            //   child: ElevatedButton.icon(
            //     icon:Icon(Icons.add,size: 40,color: Colors.red,),
            //     onPressed: () async {
            //       var push = Navigator.push(context,
            //           MaterialPageRoute(builder: (context) => Accnt()));
            //     }, label: Text('',style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),),
            //     style: ElevatedButton.styleFrom(
            //       primary: Colors.white, // background
            //       onPrimary: Colors.red, // foreground
            //     ),
            //   ),
            // ),

          ],
        ),
    );
  }
  SnackBar addSnackBar() {
    return SnackBar(

      backgroundColor: Colors.deepOrange[900],
      duration: Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      content: Row(
        children: [
          Text("더 가져 오기"),
          Expanded(child: Container(height: 0)),
          CircularProgressIndicator(),
        ],

      ),
    );
  }
  SnackBar zeroSnackBar() {
    return SnackBar(
      backgroundColor: Colors.deepOrange[200],
      duration: Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      content: Row(
        children: [
          Text("더이상 가져 올게 없습니다."),
          Expanded(child: Container(height: 0)),
          CircularProgressIndicator(),
        ],
      ),
    );
  }


}
