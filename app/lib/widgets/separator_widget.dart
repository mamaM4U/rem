import 'package:flutter/material.dart';
import 'package:arona/constants/colors.dart';

class Separator extends StatelessWidget {
  const Separator(
    this.gap, {
    super.key,
    this.borderColor = SEMI_DARK_BACKGROUND_COLOR,
  });

  final Color? borderColor;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: gap),
      child: Container(
        height: 1.0,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: borderColor!),
          ),
        ),
      ),
    );
  }
}
