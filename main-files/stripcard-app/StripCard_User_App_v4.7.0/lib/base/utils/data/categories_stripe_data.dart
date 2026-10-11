import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/views/virtual_card_stripe/controller/stripe_two_controller.dart";
import "package:TAKARA PAY/views/navbar/controller/navbar_controller.dart";
import "package:TAKARA PAY/base/utils/model/categories_model.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

final stripeCardController = Get.put(StripeTwoController());
final controller = Get.put(NavbarController());

List<CategoriesModel> categoriesStripeData = [
  CategoriesModel(Assets.icon.detailsCard, Strings.details, () {
    stripeCardController.getStripeCardData();
    if (stripeCardController.stripeCardModel.data.myCard.isNotEmpty) {
      Get.toNamed(Routes.stripeCardDetailsScreen);



    } else {
      CustomSnackBar.error(Strings.youDonNotBuyCard);
    }
  }),
  CategoriesModel(Assets.icon.transactionCard, Strings.transactions, () {
    stripeCardController.getStripeCardData();
    if (stripeCardController.stripeCardModel.data.myCard.isNotEmpty) {
      Get.toNamed(Routes.stripeTransactionHistoryScreen);
    } else {
      CustomSnackBar.error(
        Strings.youDonNotBuyCard,
      );
    }
  }),
];
