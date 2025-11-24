import 'package:flutter/material.dart';
import 'package:arona/constants/colors.dart';

class Label extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool? isRequired;
  final Widget? labelSuffixIcon;

  /// Creates a Text Label
  ///
  /// [text] param is required
  ///
  /// if [isRequired] is true will create star symbol with red color
  ///
  /// [style] for styling [text] Label
  ///
  /// [labelSuffixIcon] for icon in right label
  ///
  /// {@tool snippet}
  /// ```dart
  /// const Label(
  ///   isRequired: true,
  ///   text: 'Wajib diisi',
  /// )
  /// ```
  /// {@end-tool}
  const Label({
    super.key,
    required this.text,
    this.isRequired = false,
    this.style,
    this.labelSuffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text),
          TextSpan(
            text: isRequired! ? '*' : '',
            style: const TextStyle(color: DANGER_COLOR),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: labelSuffixIcon != null ? labelSuffixIcon! : const Offstage(),
          ),
        ],
        style: style ??
            const TextStyle(
              fontWeight: FontWeight.w500,
              color: FONT_LIGHT_COLOR,
              fontSize: 14.0,
            ),
      ),
    );
  }
}
