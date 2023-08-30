class WindModel {
  final double speed;
  final int? deg;
  final double? gust;

  String get speedString => "${speed.toStringAsFixed(1)} m/s";

  WindModel({
    required this.speed,
    required this.deg,
    this.gust,
  });

  factory WindModel.fromJson(Map<String, dynamic> json) {
    return WindModel(
      speed: json['speed'] * 1.0,
      deg: json['deg'] as int?,
      gust: json['gust'] != null ? json['gust'] * 1.0 : null,
    );
  }

  @override
  String toString() {
    return 'WindModel{\nspeed: $speed, \ndeg: $deg, \ngust: $gust\n}';
  }
}
