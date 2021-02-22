import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_app/src/Pages/HomePage.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return MaterialApp(
      title: 'tflite_app',
      theme: ThemeData(
        primaryColor:Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.id,
      routes: {
        HomePage.id : (BuildContext context)=> HomePage(),
      },
    );
  }
}