import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

class WeatherService {
  static const String apiKey = '####';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/onecall';

  Future<List<Weather>> getWeatherForecast(double latitude, double longitude) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?lat=$latitude&lon=$longitude&exclude=current,minutely,daily,alerts&appid=$apiKey'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> hourlyForecasts = data['hourly'];
        return hourlyForecasts.map((json) => Weather.fromHourlyJson(json)).toList();
      } else {
        throw Exception('API request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during API request: $e');
    }
  }
}

