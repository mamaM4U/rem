import 'package:flutter/material.dart';
import 'package:arona/constants/colors.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.backgroundColor = PRIMARY_COLOR,
    required this.child,
    this.width = double.infinity,
    this.height = 42,
    this.onPressed,
    this.disabled = false,
    this.padding,
    this.elevation,
  });

  final Color backgroundColor;
  final Widget child;
  final double width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final Function? onPressed;
  final bool disabled;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: elevation,
            backgroundColor: disabled ? DISABLED_COLOR : backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: padding),
        onPressed: () {
          if (!disabled && onPressed != null) onPressed!();
        },
        child: child,
      ),
    );
  }
}
