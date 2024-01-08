import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/current_weather_model.dart';
import '../models/hourly_forecast_model.dart';

class ApiService {
  late String apiKey;
  String lang = "en";

  static String currentWeatherApiUrl =
      "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}&units=metric&lang={lang}";
  static String hourlyForecastApiUrl =
      "https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}&units=metric&lang={lang}";

  late final Dio dio;

  Future<HourlyForecastModel?> getHourlyForecast(double lat, double lon) async {
    final String url = hourlyForecastApiUrl
        .replaceAll('{lat}', lat.toString())
        .replaceAll('{lon}', lon.toString())
        .replaceAll('{API key}', apiKey)
        .replaceAll('{lang}', lang);

    final dynamic responseData;

    try {
      responseData = await _getData(url);
      return HourlyForecastModel.fromJson(responseData);
    } catch (e) {
      log(
        "Error occurred while getting hourly forecast data.",
        name: "ApiService.getHourlyForecast",
        stackTrace: StackTrace.current,
        error: e,
      );
      throw Exception(e);
    }
  }

  Future<CurrentWeatherModel?> getCurrentWeather(double lat, double lon) async {
    final String url = currentWeatherApiUrl
        .replaceAll('{lat}', lat.toString())
        .replaceAll('{lon}', lon.toString())
        .replaceAll('{API key}', apiKey)
        .replaceAll('{lang}', lang);

    final dynamic responseData;

    try {
      responseData = await _getData(url);
      return CurrentWeatherModel.fromJson(responseData);
    } catch (e) {
      log(
        "Error occurred while getting current weather data.",
        name: "ApiService.getCurrentWeather",
        stackTrace: StackTrace.current,
        error: e,
      );
      throw Exception(e);
    }
  }

  Future<dynamic> _getData(String url) async {
    final response = await dio.get(url);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  Future<String> loadApiKey() async {
    return await rootBundle.loadString('API_KEY.txt');
  }

  static Future<ApiService> init({String lang = "en"}) async {
    final ApiService apiService = ApiService();
    apiService.dio = Dio();
    apiService.apiKey = await apiService.loadApiKey();
    apiService.lang = lang;
    return apiService;
  }
}
