import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/views/virtual_card_stripe/controller/stripe_two_controller.dart";
import "package:stripcard/views/navbar/controller/navbar_controller.dart";
import "package:stripcard/base/utils/model/categories_model.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";

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
