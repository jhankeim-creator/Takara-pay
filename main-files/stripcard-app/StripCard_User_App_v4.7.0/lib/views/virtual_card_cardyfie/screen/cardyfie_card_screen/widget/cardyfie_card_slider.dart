part of '../cardyfie_card_screen.dart';

class CardyfieCardSlider extends StatelessWidget {
  CardyfieCardSlider({super.key});

  final myCardController = Get.put(VirtualCardyfieCardController());
  final controller = Get.find<DashBoardController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    var myCards = myCardController.cardyfieCardList;
    return myCards.isNotEmpty
        ? Obx(() {
            return Column(
              children: [
                CarouselSlider(
                  items: myCards.map((card) {
                    return Builder(
                      builder: (BuildContext context) {
                        return CardWidget(
                          cardType: card.cardType,
                          cardNumber: card.maskedPan,
                          expiryDate: card.cardExpTime,
                          balance: card.amount.toString(),
                          validAt: card.cardExpTime,
                          cvv: card.cardType,
                          logo: myCardController
                              .cardyfieCardModel
                              .data
                              .cardBasicInfo
                              .siteLogo,
                          cardBgNetwork: myCardController
                              .cardyfieCardModel
                              .data
                              .cardBasicInfo
                              .cardBg,
                        );
                      },
                    );
                  }).toList(),
                  carouselController: controller.carouselController,
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      controller.current.value = index;
                      myCardController.cardyfieCardUIId.value =
                          myCards[index].ulid;
                      debugPrint(myCardController.cardyfieCardUIId.value);
                    },
                    height: screenWidth >= 600
                        ? MediaQuery.of(context).size.height * 0.24
                        : MediaQuery.of(context).size.height * 0.22,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: myCards.length > 1 ? true : false,
                    autoPlay: false,
                    aspectRatio: 17 / 9,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(seconds: 2),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                verticalSpace(Dimensions.heightSize),
                Row(
                  mainAxisAlignment: mainCenter,
                  children: [
                    Text(
                      Strings.myCard,
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${myCardController.cardyfieCardModel.data.myCards!.length}/${myCardController.cardyfieCardModel.data.cardBasicInfo.cardCreateLimit}',
                      style: AppTextStyles.numSm.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
                verticalSpace(Dimensions.heightSize),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: myCardController.cardyfieCardModel.data.myCards!
                      .asMap()
                      .entries
                      .map((entry) {
                        final bool active =
                            controller.current.value == entry.key;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: active ? 18 : 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppRadius.pill),
                            color: active
                                ? AppColors.accent
                                : AppColors.line,
                          ),
                        );
                      })
                      .toList(),
                ),
              ],
            );
          })
        : Column(
            children: [
              CardWidget(
                cardNumber: 'xxxx xxxx xxxx xxxx',
                expiryDate: 'xx/xx',
                balance: 'xx',
                validAt: 'xx',
                cvv: 'xxx',
                logo: Assets.logo.basicLogoLight.path,
                isNetworkImage: false,
                cardBgNetwork: myCardController.cardBgColor.value,
              ),
              verticalSpace(Dimensions.heightSize * 0.5),
              Row(
                mainAxisAlignment: mainCenter,
                children: [
                  Text(
                    Strings.myCard,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${myCardController.cardyfieCardList.length}/${myCardController.cardCreateLimit.value}',
                    style: AppTextStyles.numSm.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
