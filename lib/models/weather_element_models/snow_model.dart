class SnowModel {
  final double? oneHour;
  final double? threeHours;

  String? get snowVolume => oneHour != null
      ? "${oneHour!.toStringAsFixed(1)} mm"
      : threeHours != null
          ? "${threeHours!.toStringAsFixed(1)} mm"
          : null;

  SnowModel({
    required this.oneHour,
    required this.threeHours,
  });

  factory SnowModel.fromJson(Map<String, dynamic> json) {
    return SnowModel(
      oneHour: json['1h'] as double?,
      threeHours: json['3h'] as double?,
    );
  }

  @override
  String toString() {
    return 'SnowModel{\noneHour: $oneHour, \nthreeHours: $threeHours\n}';
  }
}
