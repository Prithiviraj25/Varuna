import "dart:async";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:varuna/Intro_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:varuna/main.dart';

class splashscreen extends StatefulWidget {
  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  var opacity = 1.0;
  @override
  void initState() {
    opacitymanager();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
          child: AnimatedOpacity(
        opacity: opacity,
        duration: Duration(seconds: 3),
        child: Image.asset("assets/images/screen.jpeg"),
      )),
    );
  }

  void opacitymanager() async {
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {
      opacity = 0;
    });
    await Future.delayed(Duration(milliseconds: 2000));
    setState(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => IntroPage()));
    });
  }
}
