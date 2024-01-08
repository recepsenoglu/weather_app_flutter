enum AppImages {
  sun,
  wind,
  rain,
  snow,
  humidity,
  visibility,
  tr,
  en,
}

extension AppImagesExtension on AppImages {
  String get assetName {
    switch (this) {
      case AppImages.sun:
        return "assets/images/sun.png";
      case AppImages.wind:
        return "assets/images/wind.png";
      case AppImages.rain:
        return "assets/images/rain.png";
      case AppImages.snow:
        return "assets/images/snow.png";
      case AppImages.humidity:
        return "assets/images/humidity.png";
      case AppImages.visibility:
        return "assets/images/visibility.png";
      case AppImages.tr:
        return "assets/images/tr.png";
      case AppImages.en:
        return "assets/images/en.png";
    }
  }
}
