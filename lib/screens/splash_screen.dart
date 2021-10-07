import 'package:flutter/material.dart';

import 'webview/web.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then((value) => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => WebviewDemo())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Image.asset(
              "assets/images/logo.png",
              height: 300,
              width: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
