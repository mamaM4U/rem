import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:arona/constants/colors.dart';

class ListviewWidget extends StatelessWidget {
  const ListviewWidget({
    super.key,
    this.prefixWidget,
    required this.title,
    this.subtitle,
    this.showIcon = true,
    this.onTap,
    this.titleStyle,
    this.subtitleStyle,
    this.horizontalGap = 0,
  });

  final Widget? prefixWidget;
  final String title;
  final String? subtitle;
  final bool showIcon;
  final Function? onTap;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double horizontalGap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) onTap!();
      },
      child: Row(
        children: [
          Gap(horizontalGap),
          if (prefixWidget != null) prefixWidget!,
          const Gap(14),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: titleStyle ?? const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        subtitle ?? '',
                        style: subtitleStyle ?? const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                if (showIcon)
                  const Icon(
                    Icons.chevron_right,
                    color: FONT_LIGHT_COLOR,
                    size: 34.0,
                  )
              ],
            ),
          ),
          Gap(horizontalGap),
        ],
      ),
    );
  }
}
