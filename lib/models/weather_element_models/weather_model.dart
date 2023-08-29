class WeatherModel {
  final int id;
  final String main;
  final String description;
  final String icon;

  WeatherModel({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  String get iconUrl => 'http://openweathermap.org/img/w/$icon.png';
  
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      id: json['id'] as int,
      main: json['main'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );
  }

  @override
  String toString() {
    return 'WeatherModel{\nid: $id, \nmain: $main, \ndescription: $description, \nicon: $icon\n}';
  }
}