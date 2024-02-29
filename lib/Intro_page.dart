import 'package:flutter/material.dart';
import 'package:varuna/main.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPage();
}

class _IntroPage extends State<IntroPage> {
  var animate = false;

  @override
  void initState() {
    animator();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFFBBDEFB),
              title: Center(
                  child: Text("VARUNA",
                      style: GoogleFonts.breeSerif(
                          textStyle: TextStyle(color: Color(0xDD000000)),
                          fontWeight: FontWeight.w800))),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                width: size.width,
                height: size.height,
                color: Color(0xFFE4F1FF),
                child: Column(
                  children: [
                    Text(
                        "Varuna is a real time water quality\nmonitoring app that enables us to\nmonitor the watersource that we\n"
                        "consume water from.\n"
                        "The app measures various values \nlike pH, solids, sulfates and many more\nand provides us with the information on\n"
                        "the potability of the source that water is \nconsumed from.\n\nPlease use our chatbot for   \nmore information\n",
                        style: GoogleFonts.breeSerif(
                          fontSize: 20,
                          textStyle: TextStyle(color: Color(0xDD000000)),
                          fontWeight:
                              (animate) ? FontWeight.w800 : FontWeight.w100,
                        )),
                    Positioned(
                        child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                      ),
                      child: Text("CONTINUE",
                          style: GoogleFonts.breeSerif(
                            textStyle: TextStyle(color: Color(0xDD000000)),
                            fontWeight:
                                (animate) ? FontWeight.w800 : FontWeight.w100,
                          )),
                    ))
                  ],
                ),
              ),
            )));
  }

  Future animator() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      animate = true;
    });
  }
}
