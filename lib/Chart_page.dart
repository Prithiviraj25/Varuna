import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:google_fonts/google_fonts.dart';
import 'package:varuna/main.dart';

class SensorData {
  final String name;
  final double value;

  SensorData(this.name, this.value);
}

class RealTimeChart extends StatefulWidget {

  @override
  _RealTimeChartState createState() => _RealTimeChartState();
}

class _RealTimeChartState extends State<RealTimeChart> {

  final databaseReference = FirebaseDatabase.instance.reference();
  List<SensorData> chartData = [];


  @override
  void initState() {
    super.initState();
    _startListeningToFirebase();
  }

  void _startListeningToFirebase() {
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

  @override
  Widget build(BuildContext context) {
    int i = -1;
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xFFE4F1FF),
            appBar: AppBar(
              backgroundColor: Colors.blue.shade200,
              automaticallyImplyLeading: false,
              title: Center(
                  child: Text("DEVICE DETAILS",
                      style: GoogleFonts.breeSerif(
                          textStyle: TextStyle(
                              color: Color(0xDD000000),
                              fontWeight: FontWeight.w800)))),
            ),
            body: Hero(
                tag: "chart",
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            color: Colors.blue.shade100,
                            height: size.height * 0.5,
                            width: 800,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: charts.BarChart(
                                _createChartData(),
                                animate: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(2),
                        height: 30,
                        width: size.width,
                        color: Colors.blue.shade100,
                        child: Center(child:Text(
                          "PARAMETER VALUES",
                          style: GoogleFonts.breeSerif(textStyle:TextStyle(fontSize: 20)),
                        ))
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.blue.shade100,
                      height: 200,
                      child: ListWheelScrollView(
                          itemExtent: 100,
                          children: chartData
                              .map((value) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blue,
                                    ),
                                    child: Center(
                                        child: Text(
                                      "${chartData[++i].name} : ${chartData[i].value}",
                                      style: GoogleFonts.breeSerif(
                                          textStyle: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white)),
                                    )),
                                    height: 100,
                                    width: 500,
                                  ))
                              .toList()),
                    ),
                    Container(
                      height: size.height*0.1,child: Center(
                      child: Text("Kindly Revisit to update values",
                          style: GoogleFonts.breeSerif(
                              textStyle: TextStyle(color: Color(0xDD000000),
                              fontWeight: FontWeight.w600)))
                    ),
                    )
                  ],
                ))));
  }

  List<charts.Series<SensorData, String>> _createChartData() {
    return [
      charts.Series<SensorData, String>(
        id: 'Sensor Values',
        domainFn: (SensorData sensorData, _) => sensorData.name,
        measureFn: (SensorData sensorData, _) => sensorData.value,
        data: chartData,
      ),
    ];
  }
}
