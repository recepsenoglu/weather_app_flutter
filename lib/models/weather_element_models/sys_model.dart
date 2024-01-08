import '../../utils/extensions.dart';

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
  bool get isDayTime =>
      DateTime.now()
          .isAfter(DateTime.fromMillisecondsSinceEpoch(sunrise! * 1000)) &&
      DateTime.now()
          .isBefore(DateTime.fromMillisecondsSinceEpoch(sunset! * 1000));

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
