import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/current_weather_model.dart';
import '../../models/daily_forecast_model.dart';
import '../../models/hourly_forecast_model.dart';
import '../../models/location_model.dart';
import '../../services/api_service.dart';
import '../../services/localization_service.dart';
import '../../services/location_service.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_strings.dart';

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
  bool error = false;
  String get district => _locationModel!.district ?? 'Dimension C-137';

  bool get showLoading => loading && (!initialized || error);
  bool get locationCouldNotGet => _locationModel == null;
  bool get hasError => !hasCurrentWeather || error;

  bool get hasCurrentWeather => currentWeatherModel != null;
  bool get hasHourlyForecast => hourlyForecastModel != null;
  bool get hasDailyForecast => dailyForecastModel != null;

  WeatherScreenProvider() {
    _init(initApiService: true);
  }

  Future<void> changeLanguage(BuildContext context) async {
    _apiService.lang = context.locale.languageCode == 'en' ? 'tr' : 'en';
    refresh().then((value) => LocalizationManager.changeLanguage(context));
  }

  Future<void> _init({
    bool skipLocation = false,
    bool initApiService = false,
  }) async {
    if (initApiService) {
      _apiService = await ApiService.init(
          lang: LocalizationManager.currentLocale.languageCode);
    }
    if (!skipLocation || _locationModel == null) await _getLocation();
    await _getCurrentWeather();
    await _getHourlyForecast();
    await _getDailyForecast();
    if (!locationCouldNotGet) initialized = true;
    _setLoading(false);
  }

  Future<void> _getLocation() async {
    try {
      final LocationModel? locationModel = await _locationService.init();
      if (locationModel != null) _locationModel = locationModel;
    } catch (e) {
      log(
        'Error occurred while getting location data.',
        name: 'WeatherScreenProvider._getLocation',
        error: e,
      );
      errText = e.toString();
      notifyListeners();
    }
  }

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
      currentWeatherModel = null;
      _setError(true);
      _showSnackbar();
    }
  }

  void _hideSnackbar() {
    ScaffoldMessenger.of(AppRoutes.navigatorKey.currentContext!)
        .hideCurrentSnackBar();
  }

  void _showSnackbar() {
    _hideSnackbar();

    ScaffoldMessenger.of(AppRoutes.navigatorKey.currentContext!).showSnackBar(
      const SnackBar(
        content: Text(
          AppStrings.somethingWentWrong,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> refresh() async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    await _init(skipLocation: true);
    _setLoading(false);
    if (hasCurrentWeather) _setError(false);
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
    _setLoading(true);
    _init(skipLocation: true);
  }

  void _setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void _setError(bool value) {
    error = value;
    notifyListeners();
  }
}
