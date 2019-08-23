// PACKAGES
import 'package:flutter/material.dart';

// Pages
import 'pages/search.dart';
import 'pages/test.dart';

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
