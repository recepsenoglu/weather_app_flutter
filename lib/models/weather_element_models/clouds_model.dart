class CloudsModel {
  final int all;

  CloudsModel({
    required this.all,
  });

  factory CloudsModel.fromJson(Map<String, dynamic> json) {
    return CloudsModel(
      all: json['all'] as int,
    );
  }

  @override
  String toString() {
    return 'CloudsModel{\nall: $all\n}';
  }
}