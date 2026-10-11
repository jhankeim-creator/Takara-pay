import 'package:flutter/material.dart';
import "package:stripcard/base/utils/custom_color.dart";
import "package:stripcard/base/utils/custom_style.dart";
import "package:stripcard/base/utils/dimensions.dart";
import "package:stripcard/base/utils/size.dart";
import "package:stripcard/base/widgets/text_labels/custom_title_heading_widget.dart";

class DetailsRowWidget extends StatelessWidget {
  DetailsRowWidget({super.key, required this.variable, required this.value});
  final String variable, value;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.paddingSize * 0.4),
      child: Row(
        mainAxisAlignment: mainSpaceBet,
        children: [
          Expanded(
            child: CustomTitleHeadingWidget(
              text: variable,
              style: CustomStyle.darkHeading4TextStyle.copyWith(
                color: CustomColor.primaryLightTextColor,
                fontSize: screenWidth >= 600
                    ? Dimensions.headingTextSize5
                    : Dimensions.headingTextSize4,
              ),
            ),
          ),
          Expanded(
            child: CustomTitleHeadingWidget(
              text: value,
              maxLines: 2,
              textOverflow: TextOverflow.ellipsis,
              style: CustomStyle.darkHeading4TextStyle.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: screenWidth >= 600
                    ? Dimensions.headingTextSize5
                    : Dimensions.headingTextSize3,
                color: CustomColor.primaryLightTextColor.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
