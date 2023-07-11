import 'dart:convert';
import 'package:http/http.dart' as http;

import '../WeatherModel/weather model.dart';


class DataService {
  Future<WeatherResponse> getWeather(String city) async {
    // api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
    final queryParameters = {
      'q': city,
      'appid': 'a17c1d48df0e47e968f31a998ec25ab4',
      'units': 'imperial'
    };
    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);
    final response = await http.get(uri);
    print(response.body);
    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }
}