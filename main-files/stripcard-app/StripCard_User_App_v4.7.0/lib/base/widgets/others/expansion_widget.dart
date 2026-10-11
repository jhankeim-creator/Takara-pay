// ignore_for_file: prefer_null_aware_operators

import 'package:flutter/material.dart';
import "package:stripcard/base/utils/custom_color.dart";
import "package:stripcard/base/utils/custom_style.dart";
import "package:stripcard/base/utils/dimensions.dart";
import "package:stripcard/base/utils/size.dart";
import "package:stripcard/base/widgets/text_labels/custom_title_heading_widget.dart";

class TransactionItemTileWidget extends StatelessWidget {
  const TransactionItemTileWidget(
      {super.key,
      required this.title,
      this.value = "",
      this.richText = "",
      this.statusText = "",
      this.color,
      this.richText2 = "",
      this.onTap,
      this.valueColor,
      this.textWrap = false});

  final String title, value, richText, richText2, statusText;
  final Color? color;
  final Color? valueColor;
  final VoidCallback? onTap;
  final bool textWrap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainSpaceBet,
      crossAxisAlignment: crossCenter,
      children: [
        Expanded(
          child: CustomTitleHeadingWidget(
              text: title,
              maxLines: 2,
              textOverflow: TextOverflow.ellipsis,
              style: CustomStyle.lightHeading4TextStyle.copyWith(
                  color: CustomColor.whiteColor.withValues(alpha:.4),
                  fontSize: Dimensions.headingTextSize4,
                  fontWeight: FontWeight.w400)),
        ),
        Row(
          crossAxisAlignment: crossCenter,
          mainAxisAlignment: mainEnd,
          mainAxisSize: mainMin,
          children: [
            CustomTitleHeadingWidget(
                text: richText,
                style: CustomStyle.lightHeading4TextStyle.copyWith(
                    fontSize: Dimensions.headingTextSize4,
                    fontWeight: FontWeight.w500)),
            value.isNotEmpty
                ? GestureDetector(
                    onTap: onTap,
                    child: textWrap
                        ? Expanded(
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.6,
                              child: CustomTitleHeadingWidget(
                                text: value,
                                textAlign: TextAlign.right,
                                style: CustomStyle.lightHeading3TextStyle
                                    .copyWith(
                                        color: valueColor ??
                                            CustomColor.whiteColor
                                                .withValues(alpha:.6),
                                        fontSize: Dimensions.headingTextSize5,
                                        fontWeight: FontWeight.w600),
                                maxLines: 3,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.5,
                            child: CustomTitleHeadingWidget(
                              text: value,
                              textAlign: TextAlign.right,
                              style: CustomStyle.lightHeading3TextStyle
                                  .copyWith(
                                      color: valueColor ??
                                          CustomColor.whiteColor
                                              .withValues(alpha:.6),
                                      fontSize: Dimensions.headingTextSize5,
                                      fontWeight: FontWeight.w600),
                              maxLines: 2,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.widthSize * .5,
                      vertical: Dimensions.heightSize * .2,
                    ),
                    decoration: BoxDecoration(
                        color: color != null ? color!.withValues(alpha:.15) : null,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius * .4)),
                    child: CustomTitleHeadingWidget(
                      text: statusText,
                      style: CustomStyle.darkHeading5TextStyle,
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
