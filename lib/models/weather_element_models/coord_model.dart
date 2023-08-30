class CoordModel {
  final double lon;
  final double lat;

  CoordModel({
    required this.lon,
    required this.lat,
  });

  factory CoordModel.fromJson(Map<String, dynamic> json) {
    return CoordModel(
      lon: json['lon'] as double,
      lat: json['lat'] as double,
    );
  }

  @override
  String toString() {
    return 'CoordModel{\nlon: $lon, \nlat: $lat\n}';
  }
}
