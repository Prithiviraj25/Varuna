import 'package:flutter/material.dart';
import 'package:varuna/Chart_page.dart';
import 'package:varuna/Splash_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:varuna/Chatbot.dart';

import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          databaseURL: "https://varuna-ed693-default-rtdb.firebaseio.com",
          apiKey: "AIzaSyB4_HcX7LuXeq2ERot6BsnJJMg5BNSBtFE",
          appId: "varuna-ed693",
          messagingSenderId: "702144630983",
          projectId: "varuna-ed693"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: splashscreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var Device_names = ["DEVICE1", "DEVICE2", "chatbot"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE4F1FF),
      appBar: AppBar(
          backgroundColor: Color(0xFFBBDEFB),
          title: Text("USERS SCREEN",
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(color: Color(0xDD000000)),
                  fontWeight: FontWeight.w800))),
      body: Container(
        child: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    "${index + 1}",
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            color: Color(0xDD000000),
                            fontWeight: FontWeight.w600)),
                  ),
                  backgroundColor: Color(0xFF0277bd),
                ),
                title: Text(Device_names[index],
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(color: Color(0xDD000000)),
                        fontWeight: FontWeight.w600)),
                subtitle: Text(
                    (Device_names[index] != "chatbot") ? ("0000") : (""),
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(color: Color(0xDD000000)),
                        fontWeight: FontWeight.w600)),
                trailing: InkWell(
                    onTap: () async {
                      if (Device_names[index] != "chatbot") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RealTimeChart()));
                      } else {
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Chatbot()));
                      }
                    },
                    child: Icon(Icons.arrow_back)),
              );
            },
            itemCount: Device_names.length,
            separatorBuilder: (context, index) {
              return Divider(
                height: 20,
                thickness: 1,
              );
            }),
      ),
    );
  }
}
