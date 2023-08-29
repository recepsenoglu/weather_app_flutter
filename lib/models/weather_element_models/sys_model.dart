class SysModel {
  final int type;
  final int id;
  final String country;
  final int sunrise;
  final int sunset;

  SysModel({
    required this.type,
    required this.id,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  factory SysModel.fromJson(Map<String, dynamic> json) {
    return SysModel(
      type: json['type'] as int,
      id: json['id'] as int,
      country: json['country'] as String,
      sunrise: json['sunrise'] as int,
      sunset: json['sunset'] as int,
    );
  }

  @override
  String toString() {
    return 'SysModel{\ntype: $type, \nid: $id, \ncountry: $country, \nsunrise: $sunrise, \nsunset: $sunset\n}';
  }
}
