import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:transparent_image/transparent_image.dart';

import 'home.dart';
import 'results.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  String _selectedPlatform;
  String _nextPlatform;

  Map<String, List> platformData = {
    "psn": [
      Colors.lightBlueAccent[200],
      "https://cdn3.iconfinder.com/data/icons/social-1/100/playstation-512.png",
    ],
    "pc": [
      Colors.orangeAccent[200],
      "https://cdn4.iconfinder.com/data/icons/logos-brands-5/24/origin-512.png"
    ],
    "xbl": [
      Colors.lightGreenAccent[400],
      "https://cdn4.iconfinder.com/data/icons/materia-social-free/24/038_025_xbox_game_network_android_material-512.png"
    ],
  };

  AnimationController _animationController;
  Animation _nextBtnAnimation;
  Animation _previousBtnAnimation;
  bool _isAnimating;

  Animation _startOpacityAnimation;
  Animation _startMoveAnimation;
  bool _hasStarted;

  @override
  void initState() {
    _selectedPlatform = 'psn';
    _isAnimating = false;
    _hasStarted = false;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _startOpacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    ));
    _startMoveAnimation =
        Tween<double>(begin: 20.0, end: 0.0).animate(CurvedAnimation(
      curve: Curves.easeOut,
      parent: _animationController,
    ));
    super.initState();
    displayStartingAnimation();
  }

  void displayStartingAnimation() async {
    await _animationController.forward();
    _hasStarted = true;
    _animationController.value = 0;
    _animationController.duration = Duration(milliseconds: 300);
  }

  void _animateButtons(String nextPlatform) async {
    if (nextPlatform != _selectedPlatform) {
      setState(() {
        _isAnimating = true;
        _nextPlatform = nextPlatform;
        _nextBtnAnimation =
            ColorTween(begin: Colors.white, end: platformData[nextPlatform][0])
                .animate(
          CurvedAnimation(
            curve: Curves.easeInOut,
            parent: _animationController,
          ),
        );
        _previousBtnAnimation = ColorTween(
                begin: platformData[_selectedPlatform][0], end: Colors.white)
            .animate(
          CurvedAnimation(
            curve: Curves.easeInOut,
            parent: _animationController,
          ),
        );
      });
      await _animationController.forward();
      setState(() {
        _isAnimating = false;
        _selectedPlatform = nextPlatform;
        _nextPlatform = '';
      });
      _animationController.value = 0;
    }
  }

  void _searchUser(String input) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Results(
          username: input,
          platform: _selectedPlatform,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
    );

    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Scaffold(
              // resizeToAvoidBottomPadding: false,
              backgroundColor: Color(0xffCD3333),
              body: Opacity(
                opacity: !_hasStarted ? _startOpacityAnimation.value : 1.0,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      SizedBox(
                        height: !_hasStarted ? _startMoveAnimation.value : 0.0,
                      ),
                      _buildLogo(context),
                      SizedBox(height: 120.0),
                      _buildUserInput(),
                      SizedBox(height: 60.0),
                      _buildPlatformButtons(_animationController)
                    ],
                  ),
                ),
              ));
        });
  }

  Widget _buildPlatformButtons(var animation) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _platformButton('psn'),
              SizedBox(width: 40.0),
              _platformButton('xbl'),
              SizedBox(width: 40.0),
              _platformButton('pc')
            ],
          );
        });
  }

  Widget _platformButton(String platform) {
    return GestureDetector(
      onTap: () => _animateButtons(platform),
      child: Image.network(
        platformData[platform][1],
        width: 40,
        color: !_isAnimating
            ? _selectedPlatform == platform
                ? platformData[platform][0]
                : Colors.white
            : _selectedPlatform == platform
                ? _previousBtnAnimation.value
                : _nextPlatform == platform
                    ? _nextBtnAnimation.value
                    : Colors.white,
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (input) => _searchUser(input),
        style: TextStyle(color: Colors.white, fontSize: 20.0),
        cursorColor: platformData[_selectedPlatform][0],
        cursorWidth: 2.0,
        decoration: InputDecoration(
          suffix: GestureDetector(
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          labelText: "Player name",
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: Colors.white, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: Colors.white, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          child: Center(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              width: 220.0,
              image:
                  "https://logodownload.org/wp-content/uploads/2019/02/apex-legends-logo-9.png",
            ),
          ),
        ),
        Positioned(
          top: 185.0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "COMPANION",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 5.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
