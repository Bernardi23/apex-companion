// Flutter Libraries
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Pages
import 'pages/home.dart';
import 'pages/search.dart';

// MAIN Method
void main() => runApp(ApexCompanion());

class ApexCompanion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
    );
    return MaterialApp(
      home: SearchPage(),
      theme: ThemeData(fontFamily: 'Google Sans'),
    );
  }
}
