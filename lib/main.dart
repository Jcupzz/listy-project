import 'package:flutter/material.dart';
import 'package:listy/Register.dart';

import 'Home.dart';
import 'Login.dart';
import 'SplashScreen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/SplashScreen",
    home: Register(),
    routes: {
      '/SplashScreen':(context)=>SplashScreen(),
      '/Login': (context) => Login(),
      '/Register': (context) => Register(),
      '/Home':(context)=>Home(),
    }
  ));
}
