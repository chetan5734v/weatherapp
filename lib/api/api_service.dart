import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = '8b4524d5b7e7a4334aa366129cae04b4';
  final String apiUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(Position positon) async {
    String latitude = positon.latitude.toString();
    String longitude = positon.longitude.toString();
    final response = await http.get(
      Uri.parse(
          '$apiUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
