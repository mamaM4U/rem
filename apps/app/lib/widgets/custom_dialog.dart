import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arona/constants/colors.dart';
import 'package:arona/widgets/button_widget.dart';
import 'package:arona/widgets/label.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final Widget? content;
  final String? primaryTextButton;
  final String? optionalTextButton;
  final double? buttonTextSize;
  final VoidCallback? onPressedPrimaryButton;
  final VoidCallback? onPressedSecondaryButton;
  final AsyncCallback? onPressedAsyncPrimaryButton;
  final String? iconType;
  final bool isPop;
  final double? buttonWidth;
  final bool disablePrimaryButton;
  final bool? fullWidthButton;
  final int? secondaryButtonFlex;
  final int? primaryButtonFlex;
  final bool canClose;
  final bool isRequired;
  final TextStyle? titleStyle;
  final bool showCloseButton;

  const CustomDialog({
    super.key,
    this.title,
    this.content,
    this.primaryTextButton,
    this.optionalTextButton,
    this.buttonTextSize = 14,
    this.onPressedPrimaryButton,
    this.onPressedSecondaryButton,
    this.onPressedAsyncPrimaryButton,
    this.iconType,
    this.buttonWidth = 100,
    this.isPop = true,
    this.disablePrimaryButton = false,
    this.fullWidthButton = false,
    this.secondaryButtonFlex = 6,
    this.primaryButtonFlex = 6,
    this.canClose = true,
    this.isRequired = false,
    this.showCloseButton = false,
    this.titleStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: DARK_PRIMARY_COLOR),
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: FONT_WHITE_COLOR,
          ),
          child: Wrap(children: [
            title != null && title!.trim().isNotEmpty
                ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(
                      flex: 4,
                      child: Label(
                        text: title ?? '',
                        style: titleStyle,
                        isRequired: isRequired,
                      ),
                    ),
                    if (showCloseButton)
                      InkWell(
                        child: const Icon(
                          Icons.close,
                          color: FONT_SEMIDARK_COLOR,
                        ),
                        onTap: () => Get.back(),
                      ),
                  ])
                : const Offstage(),
            Container(
              margin: EdgeInsets.only(
                top: title != null && title!.trim().isNotEmpty ? 10.0 : 0.0,
              ),
              width: double.infinity,
              child: content,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  optionalTextButton != null
                      ? Expanded(
                          flex: fullWidthButton! ? secondaryButtonFlex! : 0,
                          child: Button(
                            elevation: 0,
                            backgroundColor: FONT_WHITE_COLOR,
                            width: buttonWidth ?? double.infinity,
                            onPressed: () {
                              if (isPop) Navigator.pop(context, false);

                              if (onPressedSecondaryButton != null) {
                                onPressedSecondaryButton!();
                              }
                            },
                            child: Text(
                              optionalTextButton!,
                              style: const TextStyle(
                                color: PRIMARY_COLOR,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : const Offstage(),
                  const SizedBox(width: 10),
                  if (primaryTextButton != null)
                    Expanded(
                      flex: fullWidthButton! ? primaryButtonFlex! : 0,
                      child: Button(
                        disabled: disablePrimaryButton,
                        width: buttonWidth ?? double.infinity,
                        onPressed: () async {
                          if (onPressedPrimaryButton != null) {
                            onPressedPrimaryButton!();
                          } else if (onPressedAsyncPrimaryButton != null) {
                            await onPressedAsyncPrimaryButton!();
                          }

                          if (isPop) Navigator.pop(context, true);
                        },
                        child: Text(
                          primaryTextButton!,
                          style: TextStyle(
                            color: FONT_WHITE_COLOR,
                            fontWeight: FontWeight.w500,
                            fontSize: buttonTextSize,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ]),
        ),
      ),
      canPop: canClose,
    );
  }
}
