import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_layout/MyCustomForm.dart';
import 'package:image_cropper/image_cropper.dart';

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
  final String uploadUrl = 'http://10.0.2.2:18080/test/upload';
  // final String uploadUrl = 'http://localhost/test/upload';
  final myController = TextEditingController();
  String _password ='';

  late AppState state;
  File? imageFile;
  late Uint8List _data;
  var _result ='';
  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }
  Future<void> _saveImage(Uint8List data,String filename) async {
    bool success = false;
    try {
      success = (await ImageSave.saveImage(data, filename, albumName: "demo",overwriteSameNameFile: true))!;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
    }
    setState(() {
      _result = success ? "Save to album success" : "Save to album failed";
      print(_result);
    });
  }

  Future<String?> uploadImage(filepath, url,password) async {
    print('filepath '+filepath);
    print('url '+url);
    print('password '+password);
    print('uploadImage');
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['userid'] = 'password';
    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var res = await request.send();
    return res.reasonPhrase;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            imageFile != null ?
            Image.file(imageFile!,width: 200,height: 200,):Container(),
            SizedBox(
              height: 2,
            ),
            imageFile != null ? RaisedButton(
              onPressed: () async {
                 print('금액  '+_password);
                var res = await uploadImage(imageFile!.path, uploadUrl,'myController.text');
                print(res);
              },
              child: const Text('저장'),
            ) : Container(),
          ],
          ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.deepOrange,
            onPressed: () {
              if (state == AppState.free)
                _pickImage();
              else if (state == AppState.picked)
                _cropImage();
              else if (state == AppState.cropped) _clearImage();
            },
            child: _buildButtonIcon(),
          ),
          SizedBox(width: 20,),
          FloatingActionButton(
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
          ),
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
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      _saveImage(imageFile!.readAsBytesSync(),"data"+getRandomString(5)+".png");
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

}
