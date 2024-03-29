import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final bool isCircle;

  const ShimmerWidget.rectangular({
    super.key, 
    this.width = double.infinity,
    required this.height,
    this.isCircle = false,
  });

  const ShimmerWidget.circular({
    super.key, 
    required this.width,
    required this.height,
    this.isCircle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.white60,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(6),
        ),
      ),
    );
  }
}