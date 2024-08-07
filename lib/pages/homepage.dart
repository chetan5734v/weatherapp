// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weatherapp2/api/api_service.dart';
import 'package:weatherapp2/pages/explore.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String city = "";
  String temp = "";
  String? min;
  String? max;
  String? min_max;
  String? clouds;
  String? humidity;
  var lottiesunny = Lottie.asset('animation/sunny.json');
  var lottierain = Lottie.asset('animation/rain.json', fit: BoxFit.fill);
  var animation;
  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    takePermission();
  }

  Future<void> takePermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      // Permission is already granted
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      fetchWeatherData(position);
    } else if (status.isDenied ||
        status.isRestricted ||
        status.isPermanentlyDenied) {
      // Request permission
      if (await Permission.location.request().isGranted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        fetchWeatherData(position);
      } else {
        // Handle permission denial
        print("Location permission denied");
      }
    }
  }

  Future<void> fetchWeatherData(Position position1) async {
    ApiService apiService = ApiService();
    try {
      weatherData = await apiService.fetchWeather(position1);
      double tempi = weatherData?['main']['temp'];
      min = weatherData?['main']['temp_min'].toString();
      max = weatherData?['main']['temp_max'].toString();
      String? hum = weatherData?['main']['humidity'].toString();
      String? cl = weatherData?['clouds']['all'];

      min_max = "${min!}/${max!}";

      temp = tempi.toString();

      setState(() {
        city = weatherData?['name'];
        humidity = hum;
        clouds = cl;
        temp = "${tempi.toStringAsFixed(0)}°";
        if (weatherData?['weather'][0]['main'] == 'sunny') {
          animation = Lottie.asset('animation/sunny.json');
        } else if (weatherData?['weather'][0]['main'] == 'Clouds') {
          animation = Lottie.asset(
            'animation/clouds.json',
            fit: BoxFit.fill,
          );
        }
      }); // Update the UI after fetching the weather data
    } catch (e) {
      print(e);
    }
  }

  double kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  @override
  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          title: Center(
              child: Text(
            "W E A T H E R  A P P",
            style: TextStyle(color: Colors.white),
          )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => explorepage()));
          },
          child: Icon(Icons.explore),
        ),
        backgroundColor: Colors.blue,
        body: Column(children: [
          Expanded(
            child: Container(
              color: Colors.blue,
              width: ScreenSize.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: Row(
                  children: [
                    Text(
                      city.toUpperCase(),
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontFamily: 'Roboto'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    Icon(
                      Icons.settings,
                      size: 40,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 150,
            width: ScreenSize.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: Row(
                children: [
                  Text(
                    temp,
                    style: TextStyle(fontSize: 100, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                    child: Text(
                      weatherData?['weather'][0]['main'],
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
                    child: Text(
                      min_max!,
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 200,
              width: 200,
              child: animation,
            ),
          ),
          Expanded(
            child: Container(
              height: 180,
              width: 280,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 95, 176, 243)),
              child: Column(
                children: [
                  Center(
                      child: Text(
                    " Humidity:$humidity",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  )),
                  Center(
                      child: Text(
                    "Clouds:$clouds%",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ))
                ],
              ),
            ),
          ),
        ]));
  }
}
