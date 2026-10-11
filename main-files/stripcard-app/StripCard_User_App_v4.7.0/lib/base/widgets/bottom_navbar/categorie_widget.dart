import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

import "package:TAKARA PAY/base/widgets/others/custom_image_widget.dart";

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.color,
  });

  final String icon, text;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: mainMin,
        children: [
          CircleAvatar(
            radius: 13.r,
            backgroundColor: CustomColor.whiteColor.withValues(alpha: 0.06),
            child: CustomImageWidget(
              path: icon,
              height: screenWidth >= 600
                  ? Dimensions.heightSize * 1.2
                  : Dimensions.heightSize * 1.7,
              width: screenWidth >= 600
                  ? Dimensions.widthSize * 1.2
                  : Dimensions.widthSize * 1.7,
              color: color,
            ),
          ),
          Container(
            height: 20.h,
            width: 50.w,
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              right: Dimensions.marginSizeHorizontal * 0.1,
            ),
            decoration: BoxDecoration(
              color: CustomColor.primaryLightColor,
              borderRadius: BorderRadius.circular(Dimensions.radius),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.marginSizeHorizontal * 0.2,
              vertical: Dimensions.marginSizeVertical * 0.16,
            ),
            child: FittedBox(
              child: CustomTitleHeadingWidget(
                text: text,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomStyle.darkHeading5TextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: Dimensions.headingTextSize6 * 0.9,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
