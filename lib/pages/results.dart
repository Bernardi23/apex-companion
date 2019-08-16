import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:transparent_image/transparent_image.dart';

const URL = "https://apextab.com/api/search.php";

class Results extends StatefulWidget {
  String username, platform;
  Results({this.username, this.platform});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  bool _isLoading;
  var _json;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _getUserInfo();
  }

  _getUserInfo() async {
    setState(() => _isLoading = true);
    final String finalURL =
        "$URL?platform=${widget.platform}&search=${widget.username}";
    final response = await http.get(finalURL);

    setState(() {
      _json = jsonDecode(response.body);
      _isLoading = false;
    });

    print(_json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xffCD3333),
                  strokeWidth: 8.0,
                ),
              )
            : RefreshIndicator(
                onRefresh: () async => await _getUserInfo(),
                displacement: 30.0,
                color: Colors.white,
                backgroundColor: Color(0xffCD3333),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 25,
                      ),
                      child: Text(
                        "Search results",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 32.0,
                        ),
                      ),
                    ),
                    if (_json["totalresults"] != 0)
                      for (var user in _json["results"]) userTile(user),
                    if (_json["totalresults"] == 0) ...[
                      SizedBox(height: MediaQuery.of(context).size.height / 4),
                      Center(
                        child: Icon(
                          Icons.not_interested,
                          size: 120.0,
                          color: Colors.grey[300],
                        ),
                      ),
                      SizedBox(height: 5),
                      Center(
                        child: Text(
                          "No results found",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Widget userTile(var user) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              spreadRadius: 8,
              color: Colors.blueGrey[900].withOpacity(0.1),
            )
          ],
        ),
        child: FlatButton(
          onPressed: () => null,
          splashColor: Colors.red[50],
          highlightColor: Colors.red[50],
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: user["avatar"],
                  width: 30.0,
                  height: 30.0,
                ),
              ),
              SizedBox(width: 12.0),
              Text(
                user["name"],
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Column _buildUserStats() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Row(
  //         children: <Widget>[
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(30.0),
  //             child: FadeInImage.memoryNetwork(
  //               placeholder: kTransparentImage,
  //               image: _userPicture,
  //               width: 60.0,
  //               height: 60.0,
  //             ),
  //           ),
  //           SizedBox(width: 12.0),
  //           Text(
  //             _username,
  //             style: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: 16.0),
  //       Row(
  //         children: <Widget>[
  //           Text(
  //             "Kills: $_kills",
  //             style: TextStyle(fontSize: 20.0),
  //           ),
  //         ],
  //       )
  //     ],
  //   );
  // }
}
