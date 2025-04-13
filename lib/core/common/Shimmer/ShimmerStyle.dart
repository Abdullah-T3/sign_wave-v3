import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class customShimmer extends StatelessWidget {
  Widget childWidget;

  customShimmer({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      enabled: true,
      gradient: LinearGradient(
        tileMode: TileMode.clamp,
        colors: [
          Colors.grey.shade300,
          Colors.grey.shade400,
          Colors.grey.shade300,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,

        stops: const [0.2, 0.4, 0.5],
      ),
      period: const Duration(milliseconds: 1400),
      direction: ShimmerDirection.ltr,
      child: childWidget,
    );
  }
}
