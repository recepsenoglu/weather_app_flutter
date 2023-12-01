import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app_flutter/utils/app_sizes.dart';

import '../utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.disabled = false,
    this.radius = 28,
    this.elevation = 0,
    this.color = AppColors.primary,
    this.textColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.width,
    this.height,
    super.key,
  });

  final String text;
  final Function() onPressed;
  final IconData? icon;
  final bool loading;
  final bool disabled;
  final double elevation;
  final double radius;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? AppSizes.getWidth(0.8),
      height: height,
      child: IgnorePointer(
        ignoring: loading || disabled,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            backgroundColor: color,
            disabledBackgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            // maximumSize: Size(double.infinity, AppSizes.getWidth(0.14)),
            // minimumSize: Size(double.infinity, AppSizes.getWidth(0.13)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(color: borderColor),
            ),
            elevation: elevation,
            foregroundColor: textColor,
          ),
          child: loading
              ? const CupertinoActivityIndicator(color: Colors.white)
              : Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
        ),
      ),
    );
  }
}
