import 'dart:io';

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
  String filecontent;
  String filebyte;
  String insert_date;

  Picture(this.name, this.id, this.filename, this.filecontent, this.filebyte,this.insert_date);
}

class _HomeScreenState extends State<Bill> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  List _data = [];
  int page = 1;
  int limit = 20;

  bool _isDialogVisible = false; //
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // String tokenString ="eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI3NzJmNzc3Mi0wN2Q4LTRhMGMtODQ5NC05NTMyYWRiZGIxMTIiLCJleHAiOjE2MzE3MDY0NjV9.A7-1CZX_M1bNUhgtM2S4rcBrqCXufwz1O9uLGkqkw1Uabueoqvn4aVzs26KKcgqOhKMHTu3s9k_GnHVJeZZa6g";
  Future<int> _fetchData() async {
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
            picture["filename"], picture["filecontent"], picture["filebyte"],picture["insert_date"]);
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey, //s
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
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
      body: Container(
        color: Colors.pink[100],
        child: ListView.builder(
            itemCount: _data.length,
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
                          // onPrimary: Colors.red, // foreground
                        ),
                        child: Image.memory(
                          base64Decode(picture.filebyte),
                          width: 100,
                          height: 100,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.zero,
                                titlePadding: EdgeInsets.zero,
                                buttonPadding: EdgeInsets.symmetric(horizontal: 10),
                                insetPadding: EdgeInsets.symmetric(horizontal: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                content: Image.memory(
                                  base64Decode(picture.filebyte),
                                  width: 400,
                                  height: 400,
                                ),
                                actions: <Widget>[

                                  // new FlatButton(
                                  //   child: new Text("Close"),
                                  //   onPressed: () {
                                  //     Navigator.pop(context);
                                  //   },
                                  // ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(child: Text(picture.id+'번째'),margin: const EdgeInsets.all(8.0),),
                            Container(child: Text(picture.insert_date.substring(0,10)),margin: const EdgeInsets.all(8.0),),
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
        floatingActionButton: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(

              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
              // padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
              child: ElevatedButton.icon(

                icon:Icon(Icons.add_photo_alternate_outlined,size: 40,),
                onPressed: () async {
                  // var count = "0";
                  int imgCount = 0;
                  imgCount = await _fetchData() ;
                  print('imgCount '+imgCount.toString());
                 if(imgCount.toString() != "0"){
                   _scaffoldKey.currentState!.showSnackBar(addSnackBar());
                 }else if(imgCount.toString() == "0"){
                   _scaffoldKey.currentState!.showSnackBar(zeroSnackBar());
                 }
                }, label: Text('더 가져 오기',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
          ),
            )
          ],
        )
    );
  }
  SnackBar addSnackBar() {
    return SnackBar(
      backgroundColor: Colors.blue[500],
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
      backgroundColor: Colors.pink[500],
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
