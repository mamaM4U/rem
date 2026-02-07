import 'package:flutter/material.dart';
import 'package:arona/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    this.width = double.infinity,
    this.height = 12,
    this.borderRadius = 8,
    this.withBottomMargin = true,
    this.withTopMargin = false,
    this.dark = false,
  });

  final double width;
  final double height;
  final double borderRadius;
  final bool withBottomMargin;
  final bool withTopMargin;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return GreyShimmerContainer(
      dark: dark,
      child: Container(
        margin: EdgeInsets.only(top: withTopMargin ? 10 : 0, bottom: withBottomMargin ? 10 : 0),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: GRID_TILE_GREY_COLOR,
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

class GreyShimmerContainer extends StatelessWidget {
  const GreyShimmerContainer({
    super.key,
    required this.child,
    this.dark = false,
  });

  final Widget child;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: child,
      baseColor: dark ? Colors.grey[500]! : Colors.grey[300]!,
      highlightColor: dark ? Colors.grey[400]! : Colors.grey[200]!,
    );
  }
}
