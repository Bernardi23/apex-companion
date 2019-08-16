import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:transparent_image/transparent_image.dart';

const URL = "https://public-api.tracker.gg/v2/apex/standard/profile";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading;
  String _username;
  String _kills;
  String _userPicture;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _getUserInfo("psn", "Bernardi_23");
  }

  _getUserInfo(String platform, String id) async {
    final String finalURL = "$URL/$platform/$id";
    final response = await http.get(finalURL, headers: {
      "TRN-Api-Key": "515aa9e9-d490-4190-9bf8-5bd2e75c3f71",
    });
    final json = jsonDecode(response.body)["data"];

    setState(() {
      _username = json["platformInfo"]["platformUserId"];
      _kills = json["segments"][0]["stats"]["kills"]["value"].toString();
      _userPicture = json["platformInfo"]["avatarUrl"];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.orange,
                  strokeWidth: 12.0,
                ),
              )
            : _buildUserStats(),
      ),
    );
  }

  Column _buildUserStats() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: _userPicture,
                width: 60.0,
                height: 60.0,
              ),
            ),
            SizedBox(width: 12.0),
            Text(
              _username,
              style: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          children: <Widget>[
            Text(
              "Kills: $_kills",
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        )
      ],
    );
  }
}
