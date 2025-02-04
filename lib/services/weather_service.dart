import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';

class WeatherService {
  final String apikey = 'ad8c5db167addf1bf419758585654f70';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String forecastUrl = 'https://api.openweathermap.org/data/2.5/forecast';

  Future<WeatherInfo> fetchWeather(String city) async {
    final url = Uri.parse('$baseUrl?q=$city&appid=$apikey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  Future<List<WeatherInfo>> fetchForecast(String city) async {
    final url = Uri.parse('$forecastUrl?q=$city&appid=$apikey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['list'] as List)
          .map((item) => WeatherInfo.fromJson({
                ...item,
                'name': data['city']['name'],
                'sys': {
                  'sunrise': data['city']['sunrise'],
                  'sunset': data['city']['sunset'],
                },
              }))
          .toList();
    } else {
      throw Exception('Failed to fetch forecast data');
    }
  }

  Future<WeatherInfo> fetchWeatherByCoords(double lat, double lon) async {
    final url =
        Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apikey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  Future<List<WeatherInfo>> fetchForecastByCoords(
      double lat, double lon) async {
    final url =
        Uri.parse('$forecastUrl?lat=$lat&lon=$lon&appid=$apikey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['list'] as List)
          .map((item) => WeatherInfo.fromJson({
                ...item,
                'name': data['city']['name'],
                'sys': {
                  'sunrise': data['city']['sunrise'],
                  'sunset': data['city']['sunset'],
                },
              }))
          .toList();
    } else {
      throw Exception('Failed to fetch forecast data');
    }
  }
}
