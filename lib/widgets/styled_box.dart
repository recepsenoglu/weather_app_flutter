
import 'package:flutter/material.dart';

import '../utils/app_sizes.dart';

class StyledBox extends StatelessWidget {
  const StyledBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: AppSizes.getVerticalPadding(0.01),
      padding: AppSizes.getSymmetricPadding(0.04, 0.015),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: child,
    );
  }
}
