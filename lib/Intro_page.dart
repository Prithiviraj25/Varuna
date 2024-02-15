import 'package:flutter/material.dart';
import 'package:varuna/main.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFBBDEFB),
          title: Center(
              child: Text("VARUNA",
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(color: Color(0xDD000000)),
                      fontWeight: FontWeight.w800))),
        ),
        body:
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Color(0xFFE4F1FF),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    Text("Varuna is a real time water quality\n",
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          textStyle: TextStyle(color: Color(0xDD000000)),
                          fontWeight: FontWeight.w800,
                        ))
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  onLongPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  onDoubleTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  child: Text("CONTINUE",
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(color: Color(0xDD000000)),
                          fontWeight: FontWeight.w800)),
                )
              ],
            ),
          )
        );
  }
}
