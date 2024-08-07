import 'dart:convert';
import 'package:http/http.dart' as http;
class ApiService1{
  final String apiKey = '8b4524d5b7e7a4334aa366129cae04b4';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(String cityName) async {
     final url = '$baseUrl?q=$cityName&appid=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}