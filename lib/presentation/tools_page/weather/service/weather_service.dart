import 'dart:convert';
import 'package:gezify/presentation/tools_page/weather/widget/weather.dart';
import 'package:http/http.dart' as http;


class WeatherService {
  static const String apiKey = '95b606b86cb084f0f3155d08f832e3e3';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> getWeatherByCity(String city) async {
    final url = Uri.parse('$baseUrl/forecast?q=$city&appid=$apiKey&units=metric&lang=tr');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Weather.fromForecastJson(jsonDecode(response.body));
    } else {
      throw Exception('Şehir verisi alınamadı');
    }
  }

  Future<Weather> getWeatherByLocation(double lat, double lon) async {
    final url = Uri.parse('$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=tr');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Weather.fromForecastJson(jsonDecode(response.body));
    } else {
      throw Exception('Konum verisi alınamadı');
    }
  }
}