import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_sizes.dart';

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
            backgroundColor: color,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.grey,
            padding: AppSizes.getSymmetricPadding(0.04, 0.015),
            shape: RoundedRectangleBorder(
              borderRadius: AppSizes.getRadius(radius),
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
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: AppSizes.getWidth(0.035),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
