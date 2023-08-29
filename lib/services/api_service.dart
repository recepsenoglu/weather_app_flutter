import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:weather_app_flutter/models/current_weather_model.dart';

class ApiService {
  late String apiKey;

  static const String weatherApiUrl =
      "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}";
  static const String hourlyForecastApiUrl =
      "https://pro.openweathermap.org/data/2.5/forecast/hourly?lat={lat}&lon={lon}&appid={API key}";
  static const String dailyForecastApiUrl =
      "api.openweathermap.org/data/2.5/forecast/daily?lat={lat}&lon={lon}&cnt={cnt}&appid={API key}";

  late final Dio dio;

  Future<CurrentWeatherModel?> getCurrentWeather(double lat, double lon) async {
    final String url = weatherApiUrl
        .replaceAll('{lat}', lat.toString())
        .replaceAll('{lon}', lon.toString())
        .replaceAll('{API key}', apiKey);

    final dynamic responseData;

    try {
      responseData = await _getData(url);
      return CurrentWeatherModel.fromJson(responseData);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<dynamic> _getData(String url) async {
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> loadApiKey() async {
    return await rootBundle.loadString('API_KEY.txt');
  }

  static Future<ApiService> init() async {
    final ApiService apiService = ApiService();
    apiService.dio = Dio();
    apiService.apiKey = await apiService.loadApiKey();
    return apiService;
  }
}
