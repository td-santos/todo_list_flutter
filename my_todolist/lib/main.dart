import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_todolist/homePage.dart';
import 'package:my_todolist/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final prefs = await SharedPreferences.getInstance();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color.fromRGBO(143, 148, 251, 2), // navigation bar color
    //statusBarColor: Colors.transparent// status bar color
  ));

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    if (!(prefs.getString("nome") == null ||
        prefs.getString("nome") == " " ||
        prefs.getString("nome") == "")) {
      runApp(MaterialApp(
        //home: Home(),
        home: HomPage(),
        //home: HomPage(),
        debugShowCheckedModeBanner: false,
      ));
    } else {
      runApp(MaterialApp(
        //home: Home(),
        home: Login(),
        //home: HomPage(),
        debugShowCheckedModeBanner: false,
      ));
    }
  });
}
