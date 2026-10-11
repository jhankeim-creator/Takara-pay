import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/bottom_navbar/stripe_slider_card.dart";
import "package:stripcard/views/virtual_card_cardyfie/screen/cardyfie_card_screen/cardyfie_card_screen.dart";
import "package:stripcard/views/virtual_card_strowallet/screen/strowallet_slider.dart";

class CardyfieCardWidget extends StatelessWidget {
  const CardyfieCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius * 2),
        color: Get.isDarkMode
            ? CustomColor.primaryLightScaffoldBackgroundColor
            : CustomColor.whiteColor,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.8,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSize * 0.8,
        vertical: Dimensions.paddingSize * 0.2,
      ),
      child: Column(
        mainAxisAlignment: mainCenter,
        mainAxisSize: mainMin,
        children: [ CardyfieCardSlider(), CardyfieCategoryWidget()],
      ),
    );
  }
}
