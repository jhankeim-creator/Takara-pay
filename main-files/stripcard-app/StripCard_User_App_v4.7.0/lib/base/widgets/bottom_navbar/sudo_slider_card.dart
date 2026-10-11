import 'package:carousel_slider/carousel_slider.dart';
import "package:stripcard/base/utils/language/language_controller.dart";

import "package:stripcard/views/virtual_card_sudo/controller/sudo_my_card_controller.dart";
import "package:stripcard/views/navbar/controller/dashboard_controller.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/bottom_navbar/card_widget.dart";

class SudoDashboardSlider extends StatelessWidget {
  final myCardController = Get.put(VirtualSudoCardController());

  SudoDashboardSlider({Key? key}) : super(key: key);

  final controller = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    var myCards = myCardController.sudoMyCardModel.data.myCard;
    return myCards.isNotEmpty
        ? Obx(() {
            return Column(
              children: [
                CarouselSlider(
                  items: myCards.map((card) {
                    return Builder(
                      builder: (BuildContext context) {
                        return CardWidget(
                          cardNumber: card.cardPan,
                          expiryDate: "${card.expiryMonth}/${card.expiryYear}",
                          balance: card.cardApiMode == "sandbox"
                              ? Get.find<LanguageController>()
                                  .getTranslation(Strings.testMode)
                              : card.amount.toString(),
                          validAt: "${card.expiryMonth}/${card.expiryYear}",
                          cvv: card.cvv,
                          logo: card.siteLogo,
                        );
                      },
                    );
                  }).toList(),
                  carouselController: controller.carouselController,
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      controller.current.value = index;
                      myCardController.cardId.value = myCards[index].cardId;
                      debugPrint(myCardController.cardId.value);
                      //! Custom Dot indicator State
                    },
                    height: MediaQuery.of(context).size.height * 0.23,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    autoPlay: false,
                    aspectRatio: 17 / 8,
                    autoPlayInterval: Duration(seconds: 5),
                    autoPlayAnimationDuration: Duration(seconds: 2),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: myCardController.sudoMyCardModel.data.myCard
                        .asMap()
                        .entries
                        .map((entry) {
                      return controller.current.value == entry.key
                          ? Container(
                              width: Dimensions.widthSize * 1,
                              height: Dimensions.heightSize * 0.6,
                              margin: EdgeInsets.symmetric(
                                  vertical: Dimensions.marginSizeVertical * 0.2,
                                  horizontal:
                                      Dimensions.marginSizeHorizontal * 0.2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Get.isDarkMode
                                    ? CustomColor.whiteColor
                                    : CustomColor.primaryLightColor,
                              ))
                          : Container(
                              width: Dimensions.widthSize * 0.7,
                              height: Dimensions.heightSize * 0.5,
                              margin: EdgeInsets.symmetric(
                                  vertical: Dimensions.marginSizeVertical * 0.2,
                                  horizontal:
                                      Dimensions.marginSizeHorizontal * 0.2),
                              decoration: BoxDecoration(
                                color: CustomColor.primaryLightColor
                                    .withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                            );
                    }).toList(),
                  ),
                ),
              ],
            );
          })
        : CardWidget(
            cardNumber: 'xxxx xxxx xxxx xxxx',
            expiryDate: 'xx/xx',
            balance: 'xx',
            validAt: 'xx',
            cvv: 'xxx',
            logo: Assets.logo.basicLogoLight.path,
            isNetworkImage: false,
          );
  }
}
