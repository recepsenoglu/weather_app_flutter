import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weather_app_flutter/utils/app_routes.dart';

class LocalizationManager {
  static String get path => 'assets/translations';
  static List<Locale> get supportedLocales => const [
        Locale('en', 'US'),
        Locale('tr', 'TR'),
      ];
  static Locale get fallbackLocale => supportedLocales.last;

  static Locale get currentLocale =>
      EasyLocalization.of(AppRoutes.navigatorKey.currentContext!)!.locale;

  static void changeLanguage(BuildContext context) {
    final Locale newLocale = currentLocale == supportedLocales.first
        ? supportedLocales.last
        : supportedLocales.first;

    EasyLocalization.of(context)!.setLocale(newLocale);
  }
}
