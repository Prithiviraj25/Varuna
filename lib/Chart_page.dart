import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:google_fonts/google_fonts.dart';

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
    return SafeArea(child:Scaffold(
        backgroundColor: Color(0xFFE4F1FF),
        appBar: AppBar(
          backgroundColor: Colors.blue.shade100,
          automaticallyImplyLeading: false,
          title: Center(
              child: Text("DEVICE DETAILS",
                  style: GoogleFonts.breeSerif(
                      textStyle: TextStyle(
                          color: Color(0xDD000000),
                          fontWeight: FontWeight.w800)))),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    height: 400,
                    width: 800,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: charts.BarChart(
                        _createChartData(),
                        animate: true,

                          // layoutConfig: charts.LayoutConfig(
                          //   topMarginSpec: charts.MarginSpec.fixedPixel(10),
                          //   rightMarginSpec: charts.MarginSpec.fixedPixel(20),
                          //   bottomMarginSpec: charts.MarginSpec.fixedPixel(500),
                          //   leftMarginSpec: charts.MarginSpec.fixedPixel(30),
                          // ),

                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    final sensorData = chartData[index];
                    print(sensorData.name);
                    print(sensorData.value);

                    return ListTile(
                      leading: Text(sensorData.name,
                          style: GoogleFonts.breeSerif(
                            textStyle: TextStyle(color: Colors.black87),
                            fontWeight: FontWeight.w800,
                          )),
                      title: Text("${sensorData.value}",
                          style: GoogleFonts.breeSerif(
                              textStyle: TextStyle(color: Color(0xDD000000)),
                              fontWeight: FontWeight.w600)),
                    );
                  },
                  itemCount: 9,
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 20,
                      thickness: 1,
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Kindly Revisit to update values",
                  style: GoogleFonts.breeSerif(
                      textStyle: TextStyle(color: Color(0xDD000000)),
                      fontWeight: FontWeight.w600)),
            )
          ],
        )));
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
