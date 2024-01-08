import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/location_model.dart';
import '../utils/app_dialogs.dart';

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
      bool? openSettings = await AppDialogs.showConfirmationDialog(
        title: "locationServiceDisabled".tr(),
        message: "openSettingsDescription".tr(),
        positiveButtonText: "openSettings".tr(),
        negativeButtonText: "cancel".tr(),
      );
      if (openSettings == true) {
        await openLocationSettings();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          return Future.error(const LocationServiceDisabledException());
        }
        return getCurrentPosition();
      } else {
        return Future.error(const LocationServiceDisabledException());
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
            PermissionDeniedException("locationPermissionDenied".tr()));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      bool? openSettings = await AppDialogs.showConfirmationDialog(
        title: "permissionDenied".tr(),
        message: "openSettingsDescription".tr(),
        positiveButtonText: "openSettings".tr(),
        negativeButtonText: "cancel".tr(),
      );
      if (openSettings == true) {
        await openLocationSettings();
        permission = await Geolocator.checkPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            PermissionDeniedException("locationPermissionDeniedForever".tr()));
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

    await placemarkFromCoordinates(latitude, longitude,
            localeIdentifier: 'en_US')
        .then((placemarks) {
      place = placemarks[0];
    }).catchError((e) {
      debugPrint(e.toString());
    });
    return place;
  }
}
