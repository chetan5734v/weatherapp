// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weatherapp2/api/api_service1.dart';
import 'package:weatherapp2/components/mytextcontroller.dart';

class explorepage extends StatefulWidget {
  const explorepage({super.key});

  @override
  State<explorepage> createState() => _explorepageState();
}

class _explorepageState extends State<explorepage> {
  @override
   void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<String, dynamic>? weatherData;
  TextEditingController _controller = TextEditingController();
  String? temp = "unknown";
  String mainweather = "unknown";
  double? tempi;
  String? humidity;

  Future<void> fetchweatherdata() async {
    
    ApiService1 apiService1 = ApiService1();
    weatherData = await apiService1.fetchWeather(_controller.text);
    tempi = weatherData?['main']['temp'];
    String? hum = weatherData?['main']['humidity'].toString();

    tempi = kelvinToCelsius(tempi);
    setState(() {
      temp = tempi?.toStringAsFixed(1);
      mainweather = weatherData!['weather'][0]['main'];
      humidity = hum;
    });
  }

  
 
  double kelvinToCelsius(double? kelvin) {
    return kelvin! - 273.15;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Search Different Cities Weather"),
        ),
        body: Column(
          children: [
            Row(
              children: [
                SizedBox(
                    width: 310,
                    child: Mytextcontroller(
                      cntroller: _controller,
                    )),
                GestureDetector(
                    onTap: () => fetchweatherdata(),
                    child: Icon(
                      Icons.search,
                      size: 30,
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
              child: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue),
                  height: 150,
                  width: 500,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Current Temprature: $temp°C",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Weather: $mainweather",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Humidity: $humidity",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ));
  }
}
