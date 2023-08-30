import 'package:flutter/material.dart';
import 'package:weather_app_flutter/screens/weather_screen/weather_screen.dart';

class AppRoutes {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const String initialRoute = '/';
  static const String splashScreen = '/splash_screen';
  static const String weatherScreen = '/weather_screen';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (_) => const WeatherScreen());

      case weatherScreen:
        return MaterialPageRoute(builder: (_) => const WeatherScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }

  static Future<dynamic> goTo(String routeName,
      {bool enableBack = false, Object? arguments}) async {
    return await Navigator.of(navigatorKey.currentContext!)
        .pushNamedAndRemoveUntil(
      routeName,
      arguments: arguments,
      (route) => enableBack,
    );
  }

  static Future<dynamic> pop({bool returnDialog = false}) async {
    return Navigator.of(navigatorKey.currentContext!).pop(returnDialog);
  }
}
