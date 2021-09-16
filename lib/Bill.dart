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

  Picture(this.name, this.id, this.filename, this.filecontent, this.filebyte);
}

class _HomeScreenState extends State<Bill> {
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
  _fetchData() async {
    print('test');

    final response = await http.get(
      Uri.parse('http://222.108.225.7:18080/test/data?page=$page'),
      // Send authorization headers to the backend.
    );

    setState(() {
      _isDialogVisible = true;
    });

    print('success');
    if (response.statusCode == 200) {
      // String jsonString = response.body;
      var responseBody = utf8.decode(response.bodyBytes);
      print(responseBody);

      List pictures = jsonDecode(responseBody);

      for (int i = 0; i < pictures.length; i++) {
        var picture = pictures[i];
        Picture pictureToAdd = Picture(picture["name"], picture["id"],
            picture["filename"], picture["filecontent"], picture["filebyte"]);
        print(pictureToAdd.filename);
        setState(() {
          _data.add(pictureToAdd);
        });
      }
      setState(() {
        page++;
      });
      Future.delayed(Duration(seconds: 2), () {
        // 2초 뒤에 false로 변경
        setState(() {
          _isDialogVisible = false;
        });
      });
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text('지출 내역'),
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
      body: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (context, index) {
            Picture picture = _data[index];

            // children = <Widget>[
            //   SizedBox(
            //     child: CircularProgressIndicator(),
            //     width: 60,
            //     height: 60,
            //   ),
            //   const Padding(
            //     padding: EdgeInsets.only(top: 16),
            //     child: Text('Awaiting result...'),
            //   )
            // ];
            return Card(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // background
                        onPrimary: Colors.red, // foreground
                      ),
                      child: Image.memory(
                        base64Decode(picture.filebyte),
                        width: 130,
                        height: 130,
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
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(child: Text(picture.id),margin: const EdgeInsets.all(8.0),),
                          Container(child: Text(picture.filename),margin: const EdgeInsets.all(18.0),),
                        ]),
                    // Visibility(
                    //                     //     visible: _isDialogVisible,
                    //                     //     child: Container(
                    //                     //       color: Colors.black26,
                    //                     //       alignment: Alignment.center,
                    //                     //       child: Padding(
                    //                     //         padding: EdgeInsets.all(10.0),
                    //                     //         child: CircularProgressIndicator(),
                    //                     //       ),
                    //                     //     )
                    //                     // ),
                  ]),
            );
          }),
    );
  }
}
