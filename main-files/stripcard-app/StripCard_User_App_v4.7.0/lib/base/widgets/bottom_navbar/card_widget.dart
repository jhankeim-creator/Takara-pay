import 'package:google_fonts/google_fonts.dart';
import 'package:flip_card/flip_card.dart';
import "package:TAKARA PAY/base/utils/local_storage.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_network_image.dart";
// import 'dart:io' show Platform;

class CardWidget extends StatelessWidget {
  final String cardNumber, expiryDate, balance, validAt, cvv, logo;
  final String? availableBalance;
  final bool isNetworkImage;
  CardWidget({
    super.key,
    required this.cardNumber,
    this.availableBalance,
    required this.expiryDate,
    required this.balance,
    required this.validAt,
    required this.cvv,
    required this.logo,
    this.isNetworkImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      fill: Fill.fillFront,
      direction: FlipDirection.HORIZONTAL,
      front: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSize,
          vertical: Dimensions.paddingSize * 0.4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.3),
          image: DecorationImage(
            image: AssetImage(Assets.card.cards.path),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisSize: mainMin,
          crossAxisAlignment: crossStart,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: Dimensions.heightSize * 1.3,
                bottom: Dimensions.heightSize * 1.3,
              ),
              alignment: Alignment.topRight,
              child: Visibility(
                visible: isNetworkImage,
                child: SCNetworkImage(
                  url: logo,
                  fit: BoxFit.contain,
                  height: Dimensions.heightSize * 1.4,
                  color: CustomColor.whiteColor,
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),
            ),
            CustomTitleHeadingWidget(
              padding: EdgeInsets.only(
                  left: Dimensions.paddingSize * 2,
                  top: Dimensions.paddingSize * 0.5),
              text: cardNumber,
              textOverflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.outfit(
                fontSize: Dimensions.headingTextSize3 * 1,
                fontWeight: FontWeight.w800,
                color: CustomColor.whiteColor,
              ),
            ),
            verticalSpace(Dimensions.heightSize * 1.6),
            Row(
              mainAxisAlignment: mainSpaceBet,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: crossStart,
                    children: [
                      TitleHeading2Widget(
                        text: expiryDate,
                        fontSize: Dimensions.headingTextSize4,
                        color: CustomColor.whiteColor,
                      ),
                      TitleHeading4Widget(
                        color: CustomColor.whiteColor.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.headingTextSize5,
                        text: Strings.expiryDate,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: crossEnd,
                    children: [
                      TitleHeading2Widget(
                        text: balance,
                        fontSize: Dimensions.headingTextSize4,
                        color: CustomColor.whiteColor,
                      ),
                      TitleHeading4Widget(
                        color: CustomColor.whiteColor.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.headingTextSize5,
                        text: availableBalance ?? Strings.availabeBlance,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      back: Container(
        height: MediaQuery.of(context).size.height * 0.22,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSize,
          vertical: Dimensions.paddingSize * 0.2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.3),
          color: const Color(0xFF1E293B),
          image: scImageProvider(LocalStorage.getVirtualImage()) == null
              ? null
              : DecorationImage(
                  image: scImageProvider(LocalStorage.getVirtualImage())!,
                ),
        ),
        child: Column(
          crossAxisAlignment: crossEnd,
          children: [
            verticalSpace(Dimensions.heightSize * 1.3),
            CustomTitleHeadingWidget(
              padding: EdgeInsets.only(left: Dimensions.paddingSize * 2),
              text: "Valid: ${validAt}",
              textOverflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.outfit(
                fontSize: Dimensions.headingTextSize2 * 0.5,
                fontWeight: FontWeight.w500,
                color: CustomColor.whiteColor.withValues(alpha: 0.6),
              ),
            ),
            Container(
              height: Dimensions.heightSize * 1.2,
              width: Dimensions.widthSize * 3.1,
              margin: EdgeInsets.only(
                right: Dimensions.marginSizeHorizontal * 0.3,
                top: Dimensions.marginSizeVertical * 0.4,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CustomColor.primaryLightTextColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                  Dimensions.radius * 0.3,
                ),
              ),
              child: TitleHeading4Widget(
                text: cvv,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: CustomColor.whiteColor.withValues(alpha: 0.4),
              ),
            ),
            verticalSpace(Dimensions.heightSize * 2),
          ],
        ),
      ),
    );
  }
}
