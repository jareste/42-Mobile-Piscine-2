import 'dart:convert';
import 'package:http/http.dart' as http;

class apiCalls {
  static const String weatherApiKey = '';

  static Future<Map<String, dynamic>> fetchWeather(String cityName) async {
    final response = await http.get(Uri.parse('http://api.weatherapi.com/v1/current.json?key=$weatherApiKey&q=$cityName'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(response.body);
      print('------------------------------');
      print(jsonResponse['current']);
      return jsonResponse['current']; 
    } else {
      throw Exception('Failed to load weather from API');
    }
  }

  static const String locationIqApiKey = ''; 

  static Future<String> fetchLocation(double latitude, double longitude) async {
    final response = await http.get(Uri.parse('https://us1.locationiq.com/v1/reverse.php?key=$locationIqApiKey&lat=$latitude&lon=$longitude&format=json'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse['display_name']; 
    } else {
      throw Exception('Failed to load location from API');
    }
  }
  }
/*
  static Future<String> fetchWeather(String geocode) async {
    final response = await http.get(Uri.parse('https://api.example.com/weather?geocode=$geocode'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Weather.fromJson(jsonResponse); // assuming you have a Weather class that can parse the JSON response
    } else {
      throw Exception('Failed to load weather from API');
    }
  }
*/
