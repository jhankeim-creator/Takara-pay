import 'package:carousel_slider/carousel_slider.dart';
import "package:stripcard/views/virtual_card_strowallet/controller/strowallelt_info_controller.dart";
import "package:stripcard/views/navbar/controller/dashboard_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/views/virtual_card_strowallet/screen/card_widget.dart";

class StrowalletSlider extends StatelessWidget {
  StrowalletSlider({
    super.key,
  });

  final myCardController = Get.put(VirtualStrowalletCardController());
  final controller = Get.find<DashBoardController>();

  @override
  Widget build(BuildContext context) {
    var myCards = myCardController.strowalletCardModel.data.myCards;
    return myCards.isNotEmpty
        ? Obx(() {
            return Column(
              children: [
                CarouselSlider(
                  items: myCards.map((card) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: CardWidget(
                            cardNumber: card.cardNumber,
                            expiryDate: card.expiry,
                            balance: card.balance.toString(),
                            validAt: card.expiry,
                            cvv: card.cvv,
                            logo: card.siteLogo,
                            cardBgNetwork: myCardController
                                .strowalletCardModel.data.cardBasicInfo.cardBg,
                          ),
                        );
                      },
                    );
                  }).toList(),
                  carouselController: controller.carouselController,
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      controller.current.value = index;
                      myCardController.strowalletCardId.value =
                          myCards[index].cardId;
                      debugPrint(myCardController.strowalletCardId.value);
                    },
                    height: 210,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: myCards.length > 1 ? true : false,
                    autoPlay: false,
                    aspectRatio: 17 / 9,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(seconds: 2),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const SizedBox(height: 16),
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
                      '${myCardController.strowalletCardModel.data.myCards.length}/${myCardController.strowalletCardModel.data.cardBasicInfo.cardCreateLimit}',
                      style: AppTextStyles.numSm.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: myCardController.strowalletCardModel.data.myCards
                      .asMap()
                      .entries
                      .map((entry) {
                    final isActive = controller.current.value == entry.key;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isActive ? 18 : 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.accent
                            : AppColors.line,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          })
        : Column(
            children: [
              const CardWidget(
                cardNumber: 'xxxx xxxx xxxx xxxx',
                expiryDate: 'xx/xx',
                balance: 'xx',
                validAt: 'xx',
                cvv: 'xxx',
                logo: '',
                isNetworkImage: false,
              ),
              const SizedBox(height: 12),
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
                    '${myCardController.strowalletCardModel.data.myCards.length}/${myCardController.strowalletCardModel.data.cardBasicInfo.cardCreateLimit}',
                    style: AppTextStyles.numSm.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
