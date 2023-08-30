import 'package:weather_app_flutter/models/hourly_forecast_model.dart';
import 'package:weather_app_flutter/utils/extensions.dart';

class DailyForecastModel {
  final List<DailyForecastItemModel> list;

  DailyForecastModel({required this.list});

  factory DailyForecastModel.fromHourlyForecastModel(
      HourlyForecastModel hourlyForecast) {
    Map<String, List<HourlyForecastItemModel>> hourlyItemList = {};

    for (var item in hourlyForecast.list) {
      String day = item.dtTxt!.split(' ')[0].split('-').last;

      if (hourlyItemList.containsKey(day)) {
        hourlyItemList[day]!.add(item);
      } else {
        hourlyItemList[day] = [item];
      }
    }

    return DailyForecastModel(
      list: (hourlyItemList.values.toList())
          .map((e) => DailyForecastItemModel.fromHourlyItemModelList(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'DailyForecastModel{\nlist: $list\n}';
  }
}

class DailyForecastItemModel {
  final String day;
  final int pop;
  final double minTemp;
  final double maxTemp;
  final String dayIcon;
  final String nightIcon;

  String get minTempString => '${minTemp.toStringAsFixed(0)}°';
  String get maxTempString => '${maxTemp.toStringAsFixed(0)}°';

  String get popPercent => '$pop%';

  String get dayIconUrl => 'http://openweathermap.org/img/wn/$dayIcon.png';
  String get nightIconUrl => 'http://openweathermap.org/img/wn/$nightIcon.png';

  DailyForecastItemModel({
    required this.day,
    required this.pop,
    required this.minTemp,
    required this.maxTemp,
    required this.dayIcon,
    required this.nightIcon,
  });

  factory DailyForecastItemModel.fromHourlyItemModelList(
      List<HourlyForecastItemModel> hourlyItemList) {
    final String day = DateTime.parse(hourlyItemList.first.dtTxt!).getWeekday();
  
    /// get minimum temperature among all
    final double minTemp = hourlyItemList
        .map((e) => e.main.tempMin)
        .reduce((value, element) => value < element ? value : element);

    /// get maximum temperature among all
    final double maxTemp = hourlyItemList
        .map((e) => e.main.tempMax)
        .reduce((value, element) => value > element ? value : element);

    /// get maximum pop among all. just the pop as double
    final double pop = hourlyItemList
        .map((e) => e.pop)
        .reduce((value, element) => value > element ? value : element);

    /// get the daytime iconUrl among all
    final String dayIcon = hourlyItemList
        .map((e) => e.weather.icon)
        .reduce((value, element) => value.contains('d') ? value : element);

    /// get the nighttime iconUrl among all
    final String nightIcon = hourlyItemList
        .map((e) => e.weather.icon)
        .reduce((value, element) => value.contains('n') ? value : element);

    return DailyForecastItemModel(
      day: day,
      pop: (pop * 100).toInt(),
      minTemp: minTemp,
      maxTemp: maxTemp,
      dayIcon: dayIcon,
      nightIcon: nightIcon,
    );
  }

  @override
  String toString() {
    return 'DailyForecastItemModel{\nday: $day, \npop: $pop, \nminTemp: $minTemp, \nmaxTemp: $maxTemp, \ndayIcon: $dayIcon, \nnightIcon: $nightIcon\n}';
  }
}
