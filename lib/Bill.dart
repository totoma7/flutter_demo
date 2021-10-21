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

class _HomeScreenState extends State<Bill> with AutomaticKeepAliveClientMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  late bool _hasMore;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _defaultPhotosPerPageCount = 10;
  late List<Photo> _photos;
  final int _nextPageThreshold = 5;

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
    _hasMore = true;
    _pageNumber = 1;
    _error = false;
    _loading = true;
    _photos = [];
    fetchPhotos();
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
        ),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (_photos.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(
          child: InkWell(
            onTap: () => setState(
              () {
                _loading = true;
                _error = false;
                fetchPhotos();
              },
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text("Error while loading photos, tap to try agin"),
            ),
          ),
        );
      }
    } else {
      return ListView.builder(
        itemCount: _photos.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _photos.length - _nextPageThreshold) {
            fetchPhotos();
          }
          if (index == _photos.length) {
            if (_error) {
              return Center(
                child: InkWell(
                  onTap: () => setState(
                    () {
                      _loading = true;
                      _error = false;
                      fetchPhotos();
                    },
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("Error while loading photos, tap to try agin"),
                  ),
                ),
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
          final Photo photo = _photos[index];
          return Card(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // background
                    onPrimary: Colors.red, // foreground
                    padding: EdgeInsets.all(1), // Set padding
                  ),
                  child: Image.memory(
                    base64Decode(photo.filebyte),
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                    height: 160,
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
                            actionsPadding:
                                EdgeInsets.symmetric(horizontal: 3.0),
                            contentPadding: EdgeInsets.zero,
                            titlePadding: EdgeInsets.zero,
                            buttonPadding: EdgeInsets.zero,
                            insetPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.0)),
                            content: Image.memory(
                              base64Decode(photo.filebyte),
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
                      Container(
                        child: Text(photo.id + '번째  썸네일 '),
                        margin: const EdgeInsets.all(8.0),
                      ),
                      Container(
                        child: Text(photo.insert_date
                                .substring(2, 16)
                                .replaceAll("-", "/") +
                            " upload"),
                        margin: const EdgeInsets.all(8.0),
                      ),
                    ]),
              ],
            ),
          );
        },
      );
    }
    return Container();
  }

  Future<void> fetchPhotos() async {
    try {
      final response = await http.get(
          Uri.parse("http://222.108.225.7:18080/test/data?page=$_pageNumber"));
      List<Photo> fetchedPhotos = Photo.parseList(jsonDecode(response.body));
      setState(
        () {
          _hasMore = fetchedPhotos.length == _defaultPhotosPerPageCount;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          print(_pageNumber);
          _photos.addAll(fetchedPhotos);
        },
      );
    } catch (e) {
      setState(
        () {
          _loading = false;
          _error = true;
        },
      );
    }
  }
}

class Photo {
  final String id;
  final String filebyte;
  final String insert_date;

  Photo(this.id, this.filebyte, this.insert_date);

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(json["id"], json["filebyte"], json["insert_date"]);
  }

  static List<Photo> parseList(List<dynamic> list) {
    return list.map((i) => Photo.fromJson(i)).toList();
  }
}
