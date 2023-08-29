import 'package:flutter/material.dart';
import 'package:weather_app_flutter/utils/app_routes.dart';
import 'package:weather_app_flutter/utils/app_sizes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return MaterialApp(
      title: 'Weather app flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: AppRoutes.navigatorKey,
      initialRoute: AppRoutes.initialRoute,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
