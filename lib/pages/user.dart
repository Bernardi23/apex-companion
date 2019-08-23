// PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

// THIRD PARTY PACKAGES
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';

// PAGES

const URL = "https://apextab.com/api/player.php";

class UserPage extends StatefulWidget {
  UserPage(this.userID);

  final String userID;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  var _json;
  bool _isLoading = true;

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
    _getUserInfo();
  }

  _getUserInfo() async {
    await _transitionController.forward();
    setState(() => _isLoading = true);
    await _transitionController.reverse();
    final String finalURL = "$URL?aid=${widget.userID}";
    final response = await http.get(finalURL);
    await _transitionController.forward();
    if (response.statusCode == 200) {
      final json = await jsonDecode(response.body);
      setState(() {
        _json = json;
        _isLoading = false;
      });
    } else {}
    _transitionController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );
    final device = MediaQuery.of(context).size;
    return Scaffold(
      body: AnimatedBuilder(
          animation: _opacity,
          builder: (context, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 60),
                _buildNavIcons(),
                SizedBox(height: 45),
                if (_isLoading)
                  ..._buildLoadingWidget(device, _opacity.value)
                else
                  ..._buildAfterLoadingWidgets(device, _opacity.value)
              ],
            );
          }),
    );
  }

  Widget _buildNavIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(IconData(0xE88F, fontFamily: "Feather")),
          Icon(IconData(0xE8C3, fontFamily: "Feather")),
        ],
      ),
    );
  }

  Widget _buildUsername(opacity) {
    return Opacity(
      opacity: opacity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Text(
          _json["name"],
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF161924),
          ),
        ),
      ),
    );
  }

  Widget _buildCards(opacity, device) {
    return Opacity(
      opacity: opacity,
      child: CarouselSlider(
        height: 500,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        viewportFraction: 0.75,
        items: <Widget>[
          _statCard(
            device,
            title: "General Stats",
            description: "Rank: ${_json["globalrank"]}",
            image: _json["legend"] != 'Caustic'
                ? "https://trackercdn.com/cdn/apex.tracker.gg/legends/caustic-tall.png"
                : "https://trackercdn.com/cdn/apex.tracker.gg/legends/bloodhound-tall.png",
          ),
          _statCard(
            device,
            title: "Main Legend",
            description: _json["legend"],
            image: _json["legend"] != 'Unknown'
                ? "https://trackercdn.com/cdn/apex.tracker.gg/legends/${_json["legend"].toLowerCase()}-tall.png"
                : "https://trackercdn.com/cdn/apex.tracker.gg/legends/lifeline-tall.png",
          ),
          _statCard(
            device,
            title: "Other Heroes",
            description: "something",
            image: _json["legend"] != 'Gibraltar'
                ? "https://trackercdn.com/cdn/apex.tracker.gg/legends/gibraltar-tall.png"
                : "https://trackercdn.com/cdn/apex.tracker.gg/legends/wattson-tall.png",
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    Size device, {
    String title,
    String description,
    String image,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 35.0, top: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFED4E64).withOpacity(0.3),
            spreadRadius: 10.0,
            blurRadius: 15.0,
            offset: Offset(0.0, 10.0),
          )
        ],
        gradient: LinearGradient(
          colors: [Color(0xFFED4E64), Color(0xFFD93248)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      width: device.width * 0.65,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            top: -30.0,
            left: device.width * 0.65 / 4.5,
            child: Container(
              height: 330,
              // child: Image(
              //   image: NetworkImage(image),
              //   fit: BoxFit.fitHeight,
              // ),
              child: Center(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: image,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 80),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 50),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: Colors.white70,
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildAfterLoadingWidgets(device, opacity) {
    return [
      _buildUsername(opacity),
      SizedBox(height: 25),
      _buildCards(opacity, device),
    ];
  }

  List<Widget> _buildLoadingWidget(device, opacity) {
    return [
      SizedBox(height: device.height * 0.2),
      Opacity(
        opacity: opacity,
        child: Center(
          child: Opacity(
            opacity: _opacity.value,
            child: SpinKitRipple(
              color: Color(0xFFD93248),
              size: 200.0,
            ),
          ),
        ),
      )
    ];
  }
}
