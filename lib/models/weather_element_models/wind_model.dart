class WindModel {
  final double speed;
  final int deg;
  final double? gust;

  WindModel({
    required this.speed,
    required this.deg,
     this.gust,
  });

  factory WindModel.fromJson(Map<String, dynamic> json) {
    return WindModel(
      speed: json['speed'] as double,
      deg: json['deg'] as int,
      gust: json['gust'] as double?,
    );
  }

  @override
  String toString() {
    return 'WindModel{\nspeed: $speed, \ndeg: $deg, \ngust: $gust\n}';
  }
}