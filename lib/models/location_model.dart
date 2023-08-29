import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationModel {
  Position position;
  Placemark? placemark;

  LocationModel({
    required this.position,
    this.placemark,
  });

  String? get city => placemark?.administrativeArea;

  
}
