import 'package:flutter/material.dart';
import 'package:weather_app_flutter/utils/app_routes.dart';

class AppDialogs {
  static Future<bool?>? showConfirmationDialog({
    required String title,
    required String message,
    required String positiveButtonText,
    required String negativeButtonText,
  }) async {
    return await showDialog(
      context: AppRoutes.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
          ),
          content: Text(
            message,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                AppRoutes.pop(returnDialog: false);
              },
              child: Text(
                negativeButtonText,
              ),
            ),
            TextButton(
              onPressed: () {
                AppRoutes.pop(returnDialog: true);
              },
              child: Text(
                positiveButtonText,
              ),
            ),
          ],
        );
      },
    );
  }
}
