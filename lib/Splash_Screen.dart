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
  @override
  void initState(){
    animator();
  }
  var animate = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
              duration: Duration(microseconds: 2000),
              child: Image.asset(
                "assets/images/screen.jpeg",
                height: (animate)?size.height:0,
                width: size.width,
              ))
        ],
      ),
    );

  }
  Future animator() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      animate = true;
    });
    await Future.delayed(Duration(milliseconds: 3000));
    setState(() {
      animate =false;
    });
    await Future.delayed(Duration(milliseconds: 2000));
    setState(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => IntroPage()));
    });
  }


}
