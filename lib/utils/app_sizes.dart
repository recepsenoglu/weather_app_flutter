import 'package:flutter/material.dart';
import 'package:weather_app_flutter/utils/app_routes.dart';

class AppSizes {
  static late double _screenWidth;
  static late double _screenHeight;
  static late EdgeInsets _padding;

  static void init(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    _screenWidth = size.width;
    _screenHeight = size.height;

    _padding = MediaQuery.paddingOf(context);

    WidgetsBinding.instance.addObserver(_AppSizesObserver());
  }

  static double get width => _screenWidth;
  static double get height => _screenHeight;
  static double get bottomPadding => _padding.bottom;
  static double get topPadding => _padding.top;

  static double getWidth(double percent) {
    return _screenWidth * percent;
  }

  static double getHeight(double percent) {
    return _screenHeight * percent;
  }

  static EdgeInsets getPadding(double percent) {
    return EdgeInsets.all(getWidth(percent));
  }

  static EdgeInsets getHorizontalPadding(double percent) {
    return EdgeInsets.symmetric(horizontal: getWidth(percent));
  }

  static EdgeInsets getVerticalPadding(double percent) {
    return EdgeInsets.symmetric(vertical: getHeight(percent));
  }

  static EdgeInsets getSymmetricPadding(double horizontal, double vertical) {
    return EdgeInsets.symmetric(
      horizontal: getWidth(horizontal),
      vertical: getHeight(vertical),
    );
  }
}

class _AppSizesObserver extends WidgetsBindingObserver {
  @override
  void didChangeMetrics() {
    // Update screen dimensions on screen size changes.
    final size = MediaQuery.sizeOf(AppRoutes.navigatorKey.currentContext!);
    AppSizes._screenWidth = size.width;
    AppSizes._screenHeight = size.height;
  }
}
