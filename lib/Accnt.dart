import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:E_AC/Bill.dart';
import 'package:E_AC/image_cropper.dart';
import 'package:E_AC/main.dart';
import 'package:E_AC/tab_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:flutter/services.dart';
// import 'package:flutter_layout/MyCustomForm.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_save/image_save.dart';
import 'package:http/http.dart' as http;



class Accnt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '영수증 추가',
      theme: ThemeData.light().copyWith(primaryColor: Colors.cyan),
      home: MyHomePage(
        title: '영수증 추가',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({required this.title});


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum AppState {
  free,
  picked,
  cropped,

}

class _MyHomePageState extends State<MyHomePage> {
  String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  final String uploadUrl = 'http://222.108.225.7:18080/test/upload';

  // final String uploadUrl = 'http://localhost/test/upload';
  final myController = TextEditingController();
  String _password = '';
  bool _isVisiblePick = true;
  bool _isVisibleCamera = true;
  late AppState state;
  File? imageFile;
  late Uint8List _data;
  var _result = '';

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  Future<void> _saveImage(Uint8List data, String filename) async {
    bool success = false;
    try {
      success = (await ImageSave.saveImage(
          data, filename, albumName: "demo", overwriteSameNameFile: true))!;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
    }
    setState(() {
      _result = success ? "Save to album success" : "Save to album failed";
      print(_result);
    });
  }

  Future<int?> uploadImage(filepath, url, password) async {
    print('filepath ' + filepath);
    print('url ' + url);
    print('password ' + password);
    print('uploadImage');
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['userid'] = 'password';
    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var res = await request.send();
    return res.statusCode;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          imageFile != null ?
          Image.file(imageFile!, width: 400, height: 400,) : Container(),
          Container(
            child: Center(
              child: SizedBox(
                height: 2,
              ),
            ),
          ),
          imageFile != null ? ElevatedButton(
            onPressed: () async {
              print('금액  ' + _password);
              var res = await uploadImage(
                  imageFile!.path, uploadUrl, 'myController.text');
              print('res:' + res.toString());
              if (res == 201) {
                showAlertDialog(context);
                //_clearImage();
              }
              // setState(() {
              //   state = AppState.free;
              //   _isVisibleCamera = true;
              //   _isVisiblePick = true;
              // });
            },
            child: Text('저장', style: new TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),),
          ) : Container(),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: _isVisiblePick,
            child: FloatingActionButton(
              backgroundColor: Colors.deepOrange,
              onPressed: () {
                if (state == AppState.free)
                  _pickImage();
                else if (state == AppState.picked)
                  _cropImage();
                else if (state == AppState.cropped)
                  _clearImage();
              },
              child: _buildButtonIcon(),
            ),),

          SizedBox(width: 20,),
          Visibility(
            visible: _isVisibleCamera,

            child: FloatingActionButton(
              backgroundColor: Colors.deepOrange,
              onPressed: () {
                if (state == AppState.free)
                  _cameraImage();
                else if (state == AppState.picked)
                  _cropImage();
                else if (state == AppState.cropped)
                  _clearImage();
              },
              child: _buildcameraButtonIcon(),
            ),)

        ],
      ),
    );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.photo_album);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

  Widget _buildcameraButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.camera);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

  Future<Null> _pickImage() async {
    final pickedImage =
    await ImagePicker().getImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
        _isVisibleCamera = false;
      });
    }
    _cropImage();
  }

  Future<Null> _cameraImage() async {
    final pickedImage =
    await ImagePicker().getImage(source: ImageSource.camera);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
        _isVisiblePick = false;
      });
    }
    _cropImage();
  }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
        ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
        ]
        : [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '자르기',
            toolbarColor: Colors.indigo,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: '자르기',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      _saveImage(
          imageFile!.readAsBytesSync(), "data" + getRandomString(5) + ".png");
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
      _isVisibleCamera = true;
      _isVisiblePick = true;
    });
  }

  String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("저장 되었습니다."),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.pop(context);
                _clearImage();
              },
            ),
          ],
        );
      },
    );
  }
}