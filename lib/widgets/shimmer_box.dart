import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.height,
    this.width = double.infinity,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: isDarkMode
            ? Theme.of(context).colorScheme.surface.withOpacity(0.8)
            : Colors.grey.shade300,
        highlightColor: isDarkMode
            ? Theme.of(context).colorScheme.surface.withOpacity(0.1)
            : Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isDarkMode
                ? Theme.of(context).colorScheme.surface.withOpacity(0.8)
                : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
