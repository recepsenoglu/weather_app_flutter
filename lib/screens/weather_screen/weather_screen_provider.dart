import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_flutter/models/current_weather_model.dart';
import 'package:weather_app_flutter/models/location_model.dart';
import 'package:weather_app_flutter/services/api_service.dart';
import 'package:weather_app_flutter/services/location_service.dart';

class WeatherScreenProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();
  late ApiService _apiService;

  CurrentWeatherModel? currentWeatherModel;

  LocationModel? _locationModel;
  String errText = '';

  bool loading = true;
  bool get locationCouldNotGet => _locationModel == null;

  WeatherScreenProvider() {
    _init();
  }

  Future<void> _init() async {
    _apiService = await ApiService.init();

    await _getLocation();
    await _getCurrentWeather();

    loading = false;
    notifyListeners();
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

    await _getLocation();

    loading = false;
    notifyListeners();
  }
}
