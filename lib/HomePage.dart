import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  static const String id = 'Home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  final picker = ImagePicker();
  String label = "";
  String accuracy = "";

  getImage(bool source) async {
    PickedFile file;
    if (source == true) {
      file = await picker.getImage(source: ImageSource.gallery);
    }else{
      file = await picker.getImage(source: ImageSource.camera);
    }
    setState(() {
      _image = File(file.path);
      if (_image != null) {
        _image = File(file.path);
        applyModelOnImage(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  loadModel() async {
    String res = await Tflite.loadModel(
        labels: "assets/labels_mobilenet.txt",
        model: "assets/mobilenet.tflite");
    print("Modelo cargado $res");
  }

  applyModelOnImage(File file) async {
    List<dynamic> res = await Tflite.runModelOnImage(
        path: file.path,
        numResults: 1001,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      label = res[0]["label"];
      double condifence = res[0]['confidence'] * 100.0;
      accuracy = condifence.toString().substring(0,2)+" %";
    });
  }

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TFLite'),
        centerTitle: true,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            child: Icon(Icons.photo),
            onPressed: ()=>getImage(true),
          ),
          SizedBox(height: 10.0),
          FloatingActionButton(
            child: Icon(Icons.camera),
            onPressed: ()=>getImage(false),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            _image != null
                ? Container(
                    height: 350,
                    width: 350,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(_image), fit: BoxFit.contain),
                    ),
                  )
                : Container(),
            _image != null
                ? Text("Nombre: $label \nExactitud: $accuracy")
                : Container()
          ],
        ),
      ),
    );
  }
}
