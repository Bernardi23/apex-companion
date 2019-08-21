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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchPage(),
      theme: ThemeData(fontFamily: 'Google Sans'),
    );
  }
}
