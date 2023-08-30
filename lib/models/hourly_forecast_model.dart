import 'package:weather_app_flutter/models/weather_element_models/_exports.dart';

class HourlyForecastModel {
  final int cnt;
  final List<HourlyForecastItemModel> list;
  final CityModel? city;
  final String? country;
  final int? population;
  final int? timezone;
  final int? sunrise;
  final int? sunset;

  HourlyForecastModel({
    required this.cnt,
    required this.list,
    required this.city,
    required this.country,
    required this.population,
    required this.timezone,
    required this.sunrise,
    required this.sunset,
  });

  factory HourlyForecastModel.fromJson(Map<String, dynamic> json) {
    return HourlyForecastModel(
      cnt: json['cnt'] as int,
      list: (json['list'] as List<dynamic>)
          .map((e) =>
              HourlyForecastItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      city: json['city'] != null
          ? CityModel.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      country: json['country'] as String?,
      population: json['population'] as int?,
      timezone: json['timezone'] as int?,
      sunrise: json['sunrise'] as int?,
      sunset: json['sunset'] as int?,
    );
  }

  @override
  String toString() {
    return 'HourlyForecastModel{\ncnt: $cnt, \nlist: $list, \ncity: $city\n}';
  }
}

class HourlyForecastItemModel {
  final int dt;
  final MainModel main;
  final WeatherModel weather;
  final CloudsModel clouds;
  final WindModel wind;
  final int visibility;
  final double pop;
  final RainModel? rain;
  final SnowModel? snow;
  final String? pod;
  final String? dtTxt;

  String get popPercent => "${(pop * 100).toStringAsFixed(0)}%";

  HourlyForecastItemModel({
    required this.dt,
    required this.main,
    required this.weather,
    required this.clouds,
    required this.wind,
    required this.visibility,
    required this.pop,
    required this.rain,
    required this.snow,
    required this.pod,
    required this.dtTxt,
  });

  factory HourlyForecastItemModel.fromJson(Map<String, dynamic> json) {
    return HourlyForecastItemModel(
      dt: json['dt'] as int,
      main: MainModel.fromJson(json['main'] as Map<String, dynamic>),
      weather: WeatherModel.fromJson(
          (json['weather'] as List<dynamic>).first as Map<String, dynamic>),
      clouds: CloudsModel.fromJson(json['clouds'] as Map<String, dynamic>),
      wind: WindModel.fromJson(json['wind'] as Map<String, dynamic>),
      visibility: json['visibility'] as int,
      pop: (json['pop'] as num).toDouble(),
      rain: json['rain'] != null
          ? RainModel.fromJson(json['rain'] as Map<String, dynamic>)
          : null,
      snow: json['snow'] != null
          ? SnowModel.fromJson(json['snow'] as Map<String, dynamic>)
          : null,
      pod: json['pod'] as String?,
      dtTxt: json['dt_txt'] as String?,
    );
  }

  @override
  String toString() {
    return 'HourlyForecastItemModel{\ndt: $dt, \nmain: ${main.toString()}, \nweather: ${weather.toString()}, \nclouds: ${clouds.toString()}, \nwind: ${wind.toString()}, \nvisibility: $visibility, \npop: $pop, \nrain: ${rain.toString()}, \nsnow: ${snow.toString()}, \npod: $pod, \ndtTxt: $dtTxt\n}';
  }
}

class CityModel {
  final int id;
  final String? name;
  final CoordModel coord;

  CityModel({
    required this.id,
    required this.name,
    required this.coord,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      coord: CoordModel.fromJson(json['coord'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() {
    return 'CityModel{\nid: $id, \nname: $name, \ncoord: ${coord.toString()}\n}';
  }
}
