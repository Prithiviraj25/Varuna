import "dart:async";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:varuna/Intro_page.dart';
import 'package:google_fonts/google_fonts.dart';


class splashscreen extends StatefulWidget {
  @override
  State<splashscreen> createState() => _splashscreenState();
}


class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => IntroPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: Image(
            image: AssetImage(
                "assets/images/screen.jpeg"),
          ),
        ),
      ),
    );
  }
}
