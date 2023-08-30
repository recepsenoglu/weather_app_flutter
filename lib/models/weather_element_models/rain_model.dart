class RainModel {
  final double? oneHour;
  final double? threeHours;

  String? get rainVolume => oneHour != null
      ? "${oneHour!.toStringAsFixed(1)} mm"
      : threeHours != null
          ? "${threeHours!.toStringAsFixed(1)} mm"
          : null;

  RainModel({
    required this.oneHour,
    required this.threeHours,
  });

  factory RainModel.fromJson(Map<String, dynamic> json) {
    return RainModel(
      oneHour: json['1h'] as double?,
      threeHours: json['3h'] as double?,
    );
  }

  @override
  String toString() {
    return 'RainModel{\noneHour: $oneHour, \nthreeHours: $threeHours\n}';
  }
}
