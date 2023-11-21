import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_flutter/models/current_weather_model.dart';
import 'package:weather_app_flutter/models/daily_forecast_model.dart';
import 'package:weather_app_flutter/models/hourly_forecast_model.dart';
import 'package:weather_app_flutter/models/location_model.dart';
import 'package:weather_app_flutter/services/api_service.dart';
import 'package:weather_app_flutter/services/location_service.dart';

class WeatherScreenProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();
  late ApiService _apiService;

  CurrentWeatherModel? currentWeatherModel;
  HourlyForecastModel? hourlyForecastModel;
  DailyForecastModel? dailyForecastModel;

  LocationModel? _locationModel;
  String errText = '';

  bool loading = true;
  bool initialized = false;
  String get district => _locationModel!.district ?? 'World';
  bool get locationCouldNotGet => _locationModel == null;

  bool get hasCurrentWeather => currentWeatherModel != null;
  bool get hasHourlyForecast => hourlyForecastModel != null;
  bool get hasDailyForecast => dailyForecastModel != null;

  Future<void> _getDailyForecast() async {
    try {
      if (hourlyForecastModel != null) {
        dailyForecastModel =
            DailyForecastModel.fromHourlyForecastModel(hourlyForecastModel!);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _getHourlyForecast() async {
    try {
      hourlyForecastModel = await _apiService.getHourlyForecast(
        _locationModel!.position.latitude,
        _locationModel!.position.longitude,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _getCurrentWeather() async {
    try {
      currentWeatherModel = await _apiService.getCurrentWeather(
        _locationModel!.position.latitude,
        _locationModel!.position.longitude,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _getLocation() async {
    try {
      _locationModel = await _locationService.init();
    } catch (e) {
      log('error runtime type: ${e.runtimeType}'); // String
      log(e.toString()); // LocationServiceDisabledException

      if (e.runtimeType == LocationServiceDisabledException) {
        errText = 'Location service disabled';
      } else if (e.runtimeType == PermissionDeniedException) {
        errText = (e as PermissionDeniedException).message ?? '';
      } else {
        errText = 'Unknown error';
      }
      log(errText);
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    loading = true;
    notifyListeners();

    await _init();

    loading = false;
    notifyListeners();
  }

  Future<void> changeLocation() async {
    List<double> latitudes =
        List.generate(180 * 1000, (index) => -90 + (index + 1) * 0.001);
    List<double> longitudes =
        List.generate(360 * 1000, (index) => -180 + (index + 1) * 0.001);

    latitudes.shuffle();
    longitudes.shuffle();

    double latitude = latitudes.first;
    double longitude = longitudes.first;

    _locationModel!.position = Position(
      longitude: longitude,
      latitude: latitude,
      timestamp: _locationModel!.position.timestamp,
      accuracy: _locationModel!.position.accuracy,
      altitude: _locationModel!.position.altitude,
      heading: _locationModel!.position.heading,
      speed: _locationModel!.position.speed,
      speedAccuracy: _locationModel!.position.speedAccuracy,
      altitudeAccuracy: _locationModel!.position.altitudeAccuracy,
      headingAccuracy: _locationModel!.position.headingAccuracy,
    );

    _locationModel!.placemark =
        await LocationService.getPlacemarkFromLatLng(latitude, longitude);

    loading = true;
    notifyListeners();

    _init(customLocation: true);
  }

  WeatherScreenProvider() {
    _init(first: true);
  }

  Future<void> _init({bool customLocation = false, bool first = false}) async {
    notifyListeners();
    if (first) _apiService = await ApiService.init();

    if (!customLocation) await _getLocation();
    await _getCurrentWeather();
    await _getHourlyForecast();
    await _getDailyForecast();

    loading = false;
    initialized = true;
    notifyListeners();
  }
}
