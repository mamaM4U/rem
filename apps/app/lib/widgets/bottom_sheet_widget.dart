import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:arona/constants/colors.dart';

class BottomSheetWidget extends StatelessWidget {
  final Widget content;
  final String? title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final double? height;
  final double? width;
  final bool unFocus;
  final EdgeInsetsGeometry titlePadding;

  const BottomSheetWidget({
    super.key,
    required this.content,
    this.title,
    this.titleStyle = const TextStyle(fontSize: 16, color: FONT_SEMIDARK_COLOR, fontWeight: FontWeight.w700),
    this.subtitle,
    this.subtitleStyle = const TextStyle(fontSize: 12, color: FONT_LIGHT_COLOR),
    this.height,
    this.width,
    this.titlePadding = const EdgeInsets.fromLTRB(16, 16, 16, 0),
    this.unFocus = true,
  });

  @override
  Widget build(BuildContext context) {
    if (unFocus) FocusScope.of(context).unfocus();
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(12),
          Align(
            child: Container(
              width: 48.0,
              height: 4,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: BORDER_COLOR,
              ),
            ),
          ),
          Padding(
            padding: titlePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) Text(title ?? '', style: titleStyle),
                if (subtitle != null) const SizedBox(height: 4),
                if (subtitle != null) Text(subtitle ?? "", style: subtitleStyle),
                if (subtitle != null || title != null) const SizedBox(height: 12),
              ],
            ),
          ),
          Expanded(
            child: content,
          )
        ],
      ),
    );
  }
}
