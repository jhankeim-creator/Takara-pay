import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/views/virtual_card_flutterwave/controller/flutterwave_card_controller.dart";
import "package:stripcard/views/navbar/controller/navbar_controller.dart";
import "package:stripcard/base/utils/model/categories_model.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";

final myCardController = Get.put(FlutterWaveCardController());
final controller = Get.put(NavbarController());

List<CategoriesModel> flutterCategoriesData = [
  CategoriesModel(Assets.icon.detailsCard, Strings.details, () {
    myCardController.getCardData();
    if (myCardController.myCardModel?.data.myCards.isNotEmpty ?? false) {
      Get.toNamed(Routes.cardDetailsScreen);
    } else {
      CustomSnackBar.error(Strings.youDonNotBuyCard);
    }
  }),
  CategoriesModel(Assets.icon.fundCard, Strings.fund, () {
    myCardController.getCardData();
    if (myCardController.myCardModel?.data.myCards.isNotEmpty ?? false) {
      Get.toNamed(Routes.addFundScreen);
    } else {
      CustomSnackBar.error(
        Strings.youDonNotBuyCard,
      );
    }
  }),
  CategoriesModel(Assets.icon.transactionCard, Strings.transactions, () {
    myCardController.getCardData();
    if (myCardController.myCardModel?.data.myCards.isNotEmpty ?? false) {
      Get.toNamed(Routes.transactionHistoryScreen);
    } else {
      CustomSnackBar.error(
        Strings.youDonNotBuyCard,
      );
    }
  }),
];
