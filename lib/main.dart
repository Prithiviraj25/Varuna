import 'package:flutter/material.dart';
import 'package:varuna/Chart_page.dart';
import 'package:varuna/Splash_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:varuna/Chatbot.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          databaseURL: "https://varuna-ed693-default-rtdb.firebaseio.com",
          apiKey: "AIzaSyB4_HcX7LuXeq2ERot6BsnJJMg5BNSBtFE",
          appId: "1:702144630983:android:bf35db6fcd44ad158b2ee2",
          messagingSenderId: "702144630983",
          projectId: "varuna-ed693"));
  runApp(MyApp());
}

class SensorData {
  final String name;
  final double value;

  SensorData(this.name, this.value);
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
  final databaseReference = FirebaseDatabase.instance.reference();
  List<SensorData> chartData = [];
  var output = [];
  var localModelPath;
  @override
  void initState() {
    super.initState();
    _startListeningToFirebase();
    m_load();
  }

  void _startListeningToFirebase() {
    print("running value set");
    for (var key in [
      "pH",
      "Hardness",
      "Solids(by 100)",
      "Chloramines",
      "Sulfate",
      "Conductivity",
      "Organic Carbons",
      "Tri-halomethanes",
      "Turbidity"
    ]) {
      databaseReference.child('sensordata').child(key).onValue.listen((event) {
        dynamic data = event.snapshot.value;
        // List<SensorData> newChartData = [];
        if (data != null) {
          setState(() {
            chartData.add(SensorData(key, double.parse(data.toString())));
          });
        }
      });
    }
  }

  //----------------------------
  void m_load() async {
    await FirebaseModelDownloader.instance
        .getModel(
      "Potablilty-Detector",
      FirebaseModelDownloadType.localModel,
    )
        .then((customModel) async {
      localModelPath = customModel.file;
      final interpreter = await Interpreter.fromFile(localModelPath);
      final outputShape = interpreter.getOutputTensor(0).shape;
      final outputSize = outputShape.reduce((a, b) => a * b);
      setState(() {
        _startListeningToFirebase();
         // Initialize with zeros
        if (chartData.isNotEmpty) {
          List input=[];
          int count=0;
          for (var key in [
            "pH",
            "Hardness",
            "Solids(by 100)",
            "Chloramines",
            "Sulfate",
            "Conductivity",
            "Organic Carbons",
            "Tri-halomethanes",
            "Turbidity"
          ]){if(key=="Solids(by 100)")
            input.add((chartData[count].value)*100);
            else
            input.add((chartData[count].value));
            count++;
          }
          this.output = List<int>.filled(outputSize, 0);
            // Check if chartData is not empty
          interpreter.run(input, output[0]);

        } else {
          m_load();
        }

      });
    });
  }

  //-----------------------------------
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
                    (Device_names[index] != "chatbot"&&(output[0]==0)) ?("NOT POTABLE"):(Device_names[index] != "chatbot"&&(output[0]==1)?("POTABLE"):("")),
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
