import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/base/utils/model/categories_model.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/views/virtual_card_stripe/controller/stripe_two_controller.dart";
import "package:stripcard/views/navbar/controller/navbar_controller.dart";

final myCardController = Get.put(StripeTwoController());
final controller = Get.put(NavbarController());

List<CategoriesModel> categoriesData = [
  CategoriesModel(Assets.icon.detailsCard, Strings.details, () {
    myCardController.getStripeCardData();
    if (myCardController.stripeCardModel.data.myCard.isNotEmpty) {
      Get.toNamed(Routes.stripeCardDetailsScreen);
    } else {
      CustomSnackBar.error(Strings.youDonNotBuyCard);
    }
  }),
  CategoriesModel(Assets.icon.transactionCard, Strings.transactions, () {
    myCardController.getStripeCardData();
    if (myCardController.stripeCardModel.data.myCard.isNotEmpty) {
      Get.toNamed(Routes.stripeTransactionHistoryScreen);
    } else {
      CustomSnackBar.error(
        Strings.youDonNotBuyCard,
      );
    }
  }),
];
