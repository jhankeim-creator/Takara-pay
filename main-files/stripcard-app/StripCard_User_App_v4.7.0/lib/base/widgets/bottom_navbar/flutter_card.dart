import 'package:carousel_slider/carousel_slider.dart';

import "package:stripcard/views/virtual_card_flutterwave/controller/flutterwave_card_controller.dart";
import "package:stripcard/views/navbar/controller/dashboard_controller.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/bottom_navbar/card_widget.dart";

class FlutterWaveSlider extends StatelessWidget {
  FlutterWaveSlider({Key? key}) : super(key: key);
  final myCardController = Get.put(FlutterWaveCardController());
  final controller = Get.put(DashBoardController());
  @override
  Widget build(BuildContext context) {
    // myCardModel is nullable on the controller — render an empty box
    // when the FlutterWave myCard fetch hasn't populated it (e.g. user
    // is on a different active virtual system).
    final model = myCardController.myCardModel;
    if (model == null) return const SizedBox.shrink();
    var myCards = model.data.myCards;
    return myCards.isNotEmpty
        ? Obx(
            () {
              return Column(
                children: [
                  CarouselSlider(
                    items: myCards.map((card) {
                      return Builder(
                        builder: (BuildContext context) {
                          return CardWidget(
                            cardNumber: card.cardPan,
                            expiryDate: card.expiration,
                            balance: card.amount.toString(),
                            validAt: card.expiration,
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
                      height: MediaQuery.of(context).size.height * 0.24,
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
                      children: model.data.myCards
                          .asMap()
                          .entries
                          .map(
                        (entry) {
                          return controller.current.value == entry.key
                              ? Container(
                                  width: Dimensions.widthSize * 1,
                                  height: Dimensions.heightSize * 0.6,
                                  margin: EdgeInsets.symmetric(
                                      vertical:
                                          Dimensions.marginSizeVertical * 0.2,
                                      horizontal:
                                          Dimensions.marginSizeHorizontal *
                                              0.2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: CustomColor.whiteColor,
                                  ),
                                )
                              : Container(
                                  width: Dimensions.widthSize * 0.7,
                                  height: Dimensions.heightSize * 0.5,
                                  margin: EdgeInsets.symmetric(
                                      vertical:
                                          Dimensions.marginSizeVertical * 0.2,
                                      horizontal:
                                          Dimensions.marginSizeHorizontal *
                                              0.2),
                                  decoration: BoxDecoration(
                                    color:
                                        CustomColor.whiteColor.withValues(alpha:0.3),
                                    shape: BoxShape.circle,
                                  ),
                                );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              );
            },
          )
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
