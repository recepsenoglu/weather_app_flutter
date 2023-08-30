import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_flutter/models/location_model.dart';
import 'package:weather_app_flutter/utils/app_dialogs.dart';
import 'package:weather_app_flutter/utils/app_strings.dart';

class LocationService {
  Future<LocationModel?> init() async {
    LocationModel? locationModel;

    final Position position = await getCurrentPosition();

    debugPrint('position: $position');
    final Placemark? place =
        await getPlacemarkFromLatLng(position.latitude, position.longitude);

    locationModel = LocationModel(
      position: position,
      placemark: place,
    );

    return locationModel;
  }

  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(const LocationServiceDisabledException());
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(const PermissionDeniedException(
            AppStrings.locationPermissionDenied));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      bool? openSettings = await AppDialogs.showConfirmationDialog(
        title: AppStrings.permissionDenied,
        message: AppStrings.openSettingsDescription,
        positiveButtonText: AppStrings.openSettings,
        negativeButtonText: AppStrings.cancel,
      );
      if (openSettings == true) {
        await openLocationSettings();
        permission = await Geolocator.checkPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error(const PermissionDeniedException(
            AppStrings.locationPermissionDeniedForever));
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  static Future<Placemark?> getPlacemarkFromLatLng(
      double latitude, double longitude) async {
    Placemark? place;

    await placemarkFromCoordinates(latitude, longitude, localeIdentifier: 'US')
        .then((placemarks) {
      place = placemarks[0];
    }).catchError((e) {
      debugPrint(e.toString());
    });
    return place;
  }
}
