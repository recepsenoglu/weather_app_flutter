class MainModel {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final int? seaLevel;
  final int? grndLevel;
  final double? tempKf;

  String get humidityString => "$humidity%";
  String get temperature => "${temp.toStringAsFixed(1)}°";
  String get temperatureFixed => "${temp.toStringAsFixed(0)}°";
  String get minMaxTemperature =>
      "${tempMin.toStringAsFixed(0)}° / ${tempMax.toStringAsFixed(0)}°";
  String get feelsLikeTemperature =>
      "Feels like ${feelsLike.toStringAsFixed(0)}°";
  String get lowestTemperature => "Low ${tempMin.toStringAsFixed(0)}°";

  MainModel({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    this.seaLevel,
    this.grndLevel,
    this.tempKf,
  });

  factory MainModel.fromJson(Map<String, dynamic> json) {
    return MainModel(
      temp: (json['temp'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      tempMin: (json['temp_min'] as num).toDouble(),
      tempMax: (json['temp_max'] as num).toDouble(),
      pressure: json['pressure'] as int,
      humidity: json['humidity'] as int,
      seaLevel: json['sea_level'] as int?,
      grndLevel: json['grnd_level'] as int?,
      tempKf: json['temp_kf'] != null ? json['temp_kf'] * 1.0 : null,
    );
  }

  @override
  String toString() {
    return 'Main{\ntemp: $temp, \nfeelsLike: $feelsLike, \ntempMin: $tempMin, \ntempMax: $tempMax, \npressure: $pressure, \nhumidity: $humidity, \nseaLevel: $seaLevel, \ngrndLevel: $grndLevel, \ntempKf: $tempKf\n}';
  }
}
