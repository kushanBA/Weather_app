import 'dart:convert';

import 'package:weath_app/models/weath_model.dart';
import 'package:http/http.dart' as http;

class WeathServices {
  Future<Weath> getCurrentWeath(String cityName) async {
    final response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=53dac4f7dea847ce834114604240609&q=$cityName&aqi=yes'));
    if (response.statusCode == 200) {
      print("Data fetched");
      return Weath.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error in weather loading");
    }
  }

  // Fetch hourly forecast data
  Future<HourlyForecastData> getHourlyForecast(String cityName) async {
    final response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=53dac4f7dea847ce834114604240609&q=$cityName&days=2'));

    if (response.statusCode == 200) {
      print("Hourly data fetched");
      return HourlyForecastData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error in fetching hourly forecast");
    }
  }
}
