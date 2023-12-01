import 'package:flutter/material.dart';

import '../utils/app_sizes.dart';
import 'styled_box.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({
    super.key,
    required this.image,
    required this.title,
    required this.value,
  });

  final String image;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return StyledBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: AppSizes.getWidth(0.09),
            height: AppSizes.getWidth(0.09),
            color: Theme.of(context).colorScheme.onSurface,
          ),
          SizedBox(height: AppSizes.getHeight(0.015)),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontSize: AppSizes.getWidth(0.042),
                ),
          ),
          SizedBox(height: AppSizes.getHeight(0.005)),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontSize: AppSizes.getWidth(0.04),
                ),
          ),
        ],
      ),
    );
  }
}
