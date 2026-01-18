import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String apiKey = "fdffa22c8e1b4d708b2125948260301";

class WeatherApiService {
  final String _baseurl = "https://api.weatherapi.com/v1";

  /// Fetch current weather + past 7-day forecast
  Future<Map<String, dynamic>> getHourlyForecast(String location) async {
    final url = Uri.parse(
      "$_baseurl/forecast.json?key=$apiKey&q=${Uri.encodeComponent(location)}&days=7",
    );

    try {
      final res = await http.get(url);

      if (res.statusCode != 200) {
        throw Exception("API Error: ${res.body}");
      }

      final data = json.decode(res.body);
      if (data.containsKey('error')) {
        throw Exception(data['error']['message'] ?? 'Invalid location');
      }

      return data;
    } catch (e) {
      debugPrint("Error fetching forecast: $e");
      rethrow;
    }
  }

  /// Fetch last 7 days weather history
  Future<List<Map<String, dynamic>>> getLastSevenDaysWeather(
      String location) async {
    final List<Map<String, dynamic>> pastWeather = [];
    final today = DateTime.now();

    for (int i = 1; i <= 7; i++) {
      final date = today.subtract(Duration(days: i));
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final url = Uri.parse(
        "$_baseurl/history.json?key=$apiKey&q=${Uri.encodeComponent(location)}&dt=$formattedDate",
      );

      try {
        final res = await http.get(url);

        if (res.statusCode == 200) {
          final data = json.decode(res.body);

          if (data.containsKey('error')) {
            debugPrint(
                "Error fetching past data for $formattedDate: ${data['error']['message']}");
            continue; // skip this day
          }

          if (data['forecast'] != null &&
              data['forecast']['forecastday'] != null) {
            pastWeather.add(data);
          }
        } else {
          debugPrint(
              "Failed to fetch past data for $formattedDate: ${res.body}");
        }
      } catch (e) {
        debugPrint("Exception fetching past data for $formattedDate: $e");
      }
    }

    return pastWeather;
  }
}
