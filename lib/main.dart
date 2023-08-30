import 'package:flutter/material.dart';
import 'package:weather_app_flutter/utils/app_colors.dart';
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
        colorScheme: const ColorScheme.light(
          background: AppColors.backgroundDay,
          surface: AppColors.containerDay,
          onBackground: AppColors.textDay,
          onSurface: AppColors.textDay,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: AppColors.textDay,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: AppColors.textDay,
            fontWeight: FontWeight.w500,
          ),
          headlineSmall: TextStyle(
            color: AppColors.textDay,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      navigatorKey: AppRoutes.navigatorKey,
      initialRoute: AppRoutes.initialRoute,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
