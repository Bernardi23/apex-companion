import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 100),
          Container(width: 100, height: 100, color: Colors.red),
          SizedBox(height: 200),
          Center(
            child: FlatButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return buildDialog(context);
                  },
                );
              },
              child: Text("show dialog"),
            ),
          ),
        ],
      ),
    );
  }

  Material buildDialog(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.5,
          child: Center(
            child: FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }
}
