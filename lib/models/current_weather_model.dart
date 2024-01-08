import '../utils/app_images.dart';
import 'info_model.dart';
import 'weather_element_models/_exports.dart';

class CurrentWeatherModel {
  final CoordModel coord;
  final WeatherModel weather;
  final MainModel main;
  final int? visibility;
  final WindModel wind;
  final CloudsModel clouds;
  final RainModel? rain;
  final SnowModel? snow;
  final int? dt;
  final SysModel? sys;
  final int? timezone;
  final int? cod;

  List<InfoModel> get info {
    List<InfoModel> infoList = [
      InfoModel(
        title: "humidity",
        value: main.humidityString,
        image: AppImages.humidity.assetName,
      ),
      InfoModel(
        title: "wind",
        value: wind.speedString,
        image: AppImages.wind.assetName,
      ),
    ];

    if (rain?.rainVolume != null) {
      infoList.insert(
        0,
        InfoModel(
          title: "rain",
          value: rain!.rainVolume!,
          image: AppImages.rain.assetName,
        ),
      );
    }

    if (snow?.snowVolume != null) {
      infoList.insert(
        0,
        InfoModel(
          title: "snow",
          value: snow!.snowVolume!,
          image: AppImages.snow.assetName,
        ),
      );
    }

    if ((visibility ?? 10000) < 10000) {
      infoList.insert(
        0,
        InfoModel(
          title: "visibility",
          value: "${((visibility ?? 10000) / 1000).toStringAsFixed(0)} km",
          image: AppImages.visibility.assetName,
        ),
      );
    }

    return infoList;
  }

  CurrentWeatherModel({
    required this.coord,
    required this.weather,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    this.rain,
    this.snow,
    this.dt,
    this.sys,
    this.timezone,
    this.cod,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      coord: CoordModel.fromJson(json['coord'] as Map<String, dynamic>),
      weather:
          WeatherModel.fromJson(json['weather'][0] as Map<String, dynamic>),
      main: MainModel.fromJson(json['main'] as Map<String, dynamic>),
      visibility: (json['visibility'] as int?) ?? 10000,
      wind: WindModel.fromJson(json['wind'] as Map<String, dynamic>),
      clouds: CloudsModel.fromJson(json['clouds'] as Map<String, dynamic>),
      rain: json.containsKey('rain')
          ? RainModel.fromJson(json['rain'] as Map<String, dynamic>)
          : null,
      snow: json.containsKey('snow')
          ? SnowModel.fromJson(json['snow'] as Map<String, dynamic>)
          : null,
      dt: json['dt'] as int?,
      sys: json.containsKey('sys')
          ? SysModel.fromJson(json['sys'] as Map<String, dynamic>)
          : null,
      timezone: json['timezone'] as int?,
      cod: json['cod'] as int?,
    );
  }

  @override
  String toString() {
    return 'CurrentWeatherModel{\ncoord: ${coord.toString()}, \nweather: ${weather.toString()}, \nmain: ${main.toString()}, \nvisibility: $visibility, \nwind: ${wind.toString()}, \nclouds: ${clouds.toString()}, \nrain: ${rain.toString()}, \nsnow: ${snow.toString()}, \ndt: $dt, \nsys: ${sys.toString()}, \ntimezone: $timezone, \ncod: $cod\n}';
  }
}
