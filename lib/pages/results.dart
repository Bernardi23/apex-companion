// PACKAGES
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// THIRD PARTY PACKAGES
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// PAGES
import 'user.dart';

const URL = "https://apextab.com/api/search.php";

class Results extends StatefulWidget {
  final String username, platform;
  Results({this.username, this.platform});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> with SingleTickerProviderStateMixin {
  bool _isLoading;
  bool _gotResults;
  var _json;

  AnimationController _transitionController;
  Animation<double> _opacity;

  @override
  void initState() {
    _transitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      curve: Curves.easeOut,
      parent: _transitionController,
    ));
    super.initState();
    _isLoading = true;
    _getUserInfo();
  }

  _getUserInfo() async {
    await _transitionController.forward();
    setState(() => _isLoading = true);
    await _transitionController.reverse();
    final String finalURL =
        "$URL?platform=${widget.platform}&search=${widget.username}";
    final response = await http.get(finalURL);

    await _transitionController.forward();
    if (response.statusCode == 200) {
      final json = await jsonDecode(response.body);
      setState(() {
        _json = json;
        _gotResults = !(json["totalresults"] == 0);
        _isLoading = false;
      });
    } else {
      setState(() {
        _json = null;
        _gotResults = false;
        _isLoading = false;
      });
    }
    _transitionController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return AnimatedBuilder(
        animation: _opacity,
        builder: (context, _) {
          return Scaffold(
            body: _isLoading
                ? Center(
                    child: Opacity(
                      opacity: _opacity.value,
                      child: SpinKitRipple(
                        color: Color(0xFFD93248),
                        size: 200.0,
                      ),
                    ),
                  )
                : Opacity(
                    opacity: _opacity.value,
                    child: RefreshIndicator(
                      onRefresh: () async => await _getUserInfo(),
                      displacement: 30.0,
                      color: Colors.white,
                      backgroundColor: Color(0xFFD93248),
                      child: _buildSearchResults(context),
                    ),
                  ),
          );
        });
  }

  Widget _buildSearchResults(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 25,
          ),
          child: Text(
            "SEARCH RESULTS",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 32.0,
            ),
          ),
        ),
        if (_gotResults) for (var user in _json["results"]) userTile(user),
        if (!_gotResults) ..._noResultWidgets(context),
      ],
    );
  }

  List<Widget> _noResultWidgets(BuildContext context) {
    return [
      SizedBox(height: MediaQuery.of(context).size.height * 0.15),
      Center(
        child: Icon(
          IconData(0xE8B5, fontFamily: "Feather"),
          size: 120.0,
          color: Color(0xFFD93248),
        ),
      ),
      SizedBox(height: 35),
      Center(
        child: Text(
          "No results found".toUpperCase(),
          style: TextStyle(
            color: Colors.black38,
            fontSize: 18,
            fontWeight: FontWeight.normal,
            letterSpacing: 4.0,
          ),
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.3),
      IconButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return _buildDialog();
            }),
        icon: Icon(IconData(0xE903, fontFamily: "Feather")),
        iconSize: 32,
        color: Color(0xFFD93248),
      ),
    ];
  }

  Widget _buildDialog() {
    return NetworkGiffyDialog(
      image: Image.network(
        "https://media.tenor.com/images/ea197fb8a4894b65c5392987ac737ac6/tenor.gif",
        fit: BoxFit.cover,
      ),
      buttonOkText: Text(
        "DONE!",
        style: TextStyle(
          color: Color(0xFFD93248),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      title: Text(
        "We couldn't find who you were looking for",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        "Please set the kills as a tracker then try again. This will allow us to get the data we need from the official database.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16.0, color: Colors.black54),
      ),
      buttonOkColor: Colors.white,
      onlyOkButton: true,
      onOkButtonPressed: () {
        Navigator.of(context).pop();
        _getUserInfo();
      },
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
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserPage(user["aid"]),
              maintainState: true,
            ),
          ),
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
}
