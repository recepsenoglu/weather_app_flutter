

extension StringExtension on String {
  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension IntExtension on int {
  String temperature() {
    return "${toStringAsFixed(0)}°";
  }

  String getHourFromTimestamp() {
    return DateTime.fromMillisecondsSinceEpoch(this * 1000).time();
  }
}

extension DateTimeExtension on DateTime {
  String time() {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  String getWeekday() {
    if (weekday == DateTime.now().weekday) return 'today';

    return [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ][weekday - 1];
  }
}
