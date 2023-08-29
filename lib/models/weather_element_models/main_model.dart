class MainModel {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final int? seaLevel;
  final int? grndLevel;

  MainModel({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
     this.seaLevel,
     this.grndLevel,
  });

  factory MainModel.fromJson(Map<String, dynamic> json) {
    return MainModel(
      temp: json['temp'] as double,
      feelsLike: json['feels_like'] as double,
      tempMin: json['temp_min'] as double,
      tempMax: json['temp_max'] as double,
      pressure: json['pressure'] as int,
      humidity: json['humidity'] as int,
      seaLevel: json['sea_level'] as int?,
      grndLevel: json['grnd_level'] as int?,
    );
  }

  @override
  String toString() {
    return 'Main{\ntemp: $temp, \nfeelsLike: $feelsLike, \ntempMin: $tempMin, \ntempMax: $tempMax, \npressure: $pressure, \nhumidity: $humidity, \nseaLevel: $seaLevel, \ngrndLevel: $grndLevel\n}';
  }
}