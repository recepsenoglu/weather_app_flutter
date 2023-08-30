import 'package:weather_app_flutter/utils/app_strings.dart';
import 'package:weather_app_flutter/utils/extensions.dart';

class SysModel {
  final int? type;
  final int? id;
  final String? country;
  final int? sunrise;
  final int? sunset;

  SysModel({
    required this.type,
    required this.id,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  String get sunriseTime =>
      DateTime.fromMillisecondsSinceEpoch(sunrise! * 1000).time();
  String get sunsetTime =>
      DateTime.fromMillisecondsSinceEpoch(sunset! * 1000).time();

  String get getSunTitle => DateTime.now()
          .isAfter(DateTime.fromMillisecondsSinceEpoch(sunrise! * 1000))
      ? AppStrings.dontMissTheSunset
      : AppStrings.riseAndShine;

  String get getSunTime => DateTime.now()
          .isAfter(DateTime.fromMillisecondsSinceEpoch(sunrise! * 1000))
      ? "Sunset will be at $sunsetTime"
      : "Sunrise will be at $sunriseTime";

  factory SysModel.fromJson(Map<String, dynamic> json) {
    return SysModel(
      type: json['type'] as int?,
      id: json['id'] as int?,
      country: json['country'] as String?,
      sunrise: json['sunrise'] as int?,
      sunset: json['sunset'] as int?,
    );
  }

  @override
  String toString() {
    return 'SysModel{\ntype: $type, \nid: $id, \ncountry: $country, \nsunrise: $sunrise, \nsunset: $sunset\n}';
  }
}
