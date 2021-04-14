import 'package:flutter/material.dart';
import 'package:intelligent_construction/appearance/theme.dart';
import 'package:intelligent_construction/pages/login.dart';
import 'package:intelligent_construction/pages/mainPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/mainPage': (context) => MainPage(),
      },
    );
  }
}