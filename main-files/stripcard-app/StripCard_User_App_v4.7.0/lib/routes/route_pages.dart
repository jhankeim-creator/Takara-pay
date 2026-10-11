import "package:TAKARA PAY/views/deposit/screen/bkash_webview_screen.dart";
import "package:TAKARA PAY/views/gift_card/screen/gif_card_preview_screen.dart";
import "package:TAKARA PAY/bindings/dashboard_binding.dart";
import "package:TAKARA PAY/views/two_fa/screen/enable_2fa_screen.dart";
import "package:TAKARA PAY/views/two_fa/screen/two_fa_otp_screen.dart";
import "package:TAKARA PAY/views/virtual_card_cardyfie/screen/cardyfie_add_fund/cardyfie_add_fund_screen.dart";
import "package:TAKARA PAY/views/virtual_card_cardyfie/screen/cardyfie_add_fund/preview_screen.dart";
import "package:TAKARA PAY/views/virtual_card_cardyfie/screen/cardyfie_create_card_screen/cardyfie_create_card_screen.dart";
import "package:TAKARA PAY/views/virtual_card_cardyfie/screen/cardyfie_details/cardyfie_details_screen.dart";
import "package:TAKARA PAY/views/virtual_card_cardyfie/screen/cardyfie_transaction/cardyfie_transaction_screen.dart";
import "package:TAKARA PAY/views/virtual_card_cardyfie/screen/cardyfie_update_customer_screen.dart/update_customer_screen.dart";
import "package:TAKARA PAY/views/virtual_card_cardyfie/screen/cardyfie_withdraw/cardyfie_withdraw_screen.dart";
import "package:TAKARA PAY/views/virtual_card_cardyfie/screen/cardyfie_withdraw/widget/withdraw_preview_screen.dart";
import "package:TAKARA PAY/views/virtual_card_stripe/screen/strip_card_preview.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/screen/strowallet_webhook_screen.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/screen/update_customer_screen.dart";
import "package:TAKARA PAY/views/gift_card/screen/create_gift_card_screen.dart";
import "package:TAKARA PAY/routes/routes.dart";
import "package:TAKARA PAY/views/auth/screen/login/otp_verification_screen.dart";
import "package:TAKARA PAY/views/auth/screen/registration/email_otp_screen.dart";
import "package:TAKARA PAY/views/auth/screen/registration/sign_up_screen.dart";
import "package:TAKARA PAY/views/deposit/screen/web_payment_screen.dart";
import "package:TAKARA PAY/views/withdraw/screen/withdraw_manual_payment_screen.dart";
import "package:TAKARA PAY/views/withdraw/screen/withdraw_preview_screen.dart";
import "package:TAKARA PAY/views/drawer/screen/change_password_screen.dart";
import "package:TAKARA PAY/views/navbar/screen/bottom_navbar_screen.dart";
import "package:TAKARA PAY/views/navbar/screen/dashboard_screen.dart";
import "package:TAKARA PAY/views/navbar/screen/notification_screen.dart";
import "package:TAKARA PAY/views/onboard/screen/onboard_screen.dart";
import "package:TAKARA PAY/views/profile/screen/my_card_screen.dart";
import "package:TAKARA PAY/views/profile/screen/update_profile_screen.dart";
import 'package:get/get.dart';
import "package:TAKARA PAY/base/api/endpoint/api_endpoint.dart";
import "package:TAKARA PAY/bindings/splash_screen_binding.dart";
import "package:TAKARA PAY/base/utils/language/strings.dart";
import "package:TAKARA PAY/views/auth/screen/login/reset_password_screen.dart";
import "package:TAKARA PAY/views/auth/screen/login/signin_screen.dart";
import "package:TAKARA PAY/views/deposit/screen/coingate_webview_screen.dart";
import "package:TAKARA PAY/views/deposit/screen/deposit_preview_screen.dart";
import "package:TAKARA PAY/views/deposit/screen/deposit_screen.dart";
import "package:TAKARA PAY/views/deposit/screen/flutterwave_webview_screen.dart";
import "package:TAKARA PAY/views/deposit/screen/manual_payment_screen.dart";
import "package:TAKARA PAY/views/deposit/screen/qrpay_webview_screen.dart";
import "package:TAKARA PAY/views/deposit/screen/razorpay_webview_screen.dart";
import "package:TAKARA PAY/views/deposit/screen/sslcommerz_webview_screen.dart";
import "package:TAKARA PAY/views/deposit/screen/stripe_web_view_screen.dart";
import "package:TAKARA PAY/views/deposit/screen/tatum/tatum_screen.dart";
import "package:TAKARA PAY/views/virtual_card_flutterwave/screen/add_fund_screen.dart";
import "package:TAKARA PAY/views/virtual_card_flutterwave/screen/card_details_screen.dart";
import "package:TAKARA PAY/views/virtual_card_flutterwave/screen/create_newcard_preview_screen.dart";
import "package:TAKARA PAY/views/virtual_card_flutterwave/screen/create_newcard_screen.dart";
import "package:TAKARA PAY/views/virtual_card_flutterwave/screen/fund_preview_screen.dart";
import "package:TAKARA PAY/views/virtual_card_flutterwave/screen/transaction_history_screen.dart";
import "package:TAKARA PAY/views/virtual_card_stripe/screen/stripe_card_details_screen.dart";
import "package:TAKARA PAY/views/virtual_card_stripe/screen/stripe_transaction_screen.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/screen/adfund_strowallet_screen.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/screen/withdraw_strowallet_screen.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/screen/strowallet_details_screen.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/screen/strowallet_new_card_screen.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/screen/strowallet_transacton.dart";
import "package:TAKARA PAY/views/virtual_card_sudo/screen/create_new_card/sudo_card_preview.dart";
import "package:TAKARA PAY/views/virtual_card_sudo/screen/create_new_card/sudo_new_card.dart";
import "package:TAKARA PAY/views/virtual_card_sudo/screen/sudo_card_details_screen.dart";
import "package:TAKARA PAY/views/virtual_card_sudo/screen/sudo_transaction_history_screen.dart";
import "package:TAKARA PAY/views/withdraw/screen/withdraw_screen.dart";
import "package:TAKARA PAY/views/drawer/screen/settings_screen.dart";
import "package:TAKARA PAY/views/drawer/screen/transaction_log_screen.dart";
import "package:TAKARA PAY/views/drawer/screen/web_view_screen.dart";
import "package:TAKARA PAY/views/gift_card/screen/all_gift_card_screen.dart";
import "package:TAKARA PAY/views/gift_card/screen/gift_card_screen.dart";
import "package:TAKARA PAY/views/kyc/screen/kyc_screen.dart";
import "package:TAKARA PAY/views/money_transfer/screen/money_transfer_screen.dart";
import "package:TAKARA PAY/views/money_transfer/screen/transfer_preview_screen.dart";
import "package:TAKARA PAY/views/splash/screen/splash_screen.dart";

class RoutePageList {
  static var list = [
    //!auth
    GetPage(
      name: Routes.splashScreen,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(name: Routes.onboardScreen, page: () => OnboardScreen()),

    GetPage(name: Routes.signInScreen, page: () => SignInScreen()),
    GetPage(name: Routes.resetOtpScreen, page: () => ResetOtpScreen()),
    GetPage(
      name: Routes.resetPasswordScreen,
      page: () => ResetPasswordScreen(),
    ),
    GetPage(
      name: Routes.gifCardPreviewScreen,
      page: () => GifCardPreviewScreen(),
    ),
    GetPage(name: Routes.registrationScreen, page: () => RegistrationScreen()),
    GetPage(name: Routes.emailOtpScreen, page: () => EmailOtpScreen()),

    //!categories
    GetPage(
      name: Routes.bottomNavBarScreen,
      page: () => BottomNavBarScreen(),
      binding: NavbarBinding(),
    ),
    GetPage(name: Routes.dashboardScreen, page: () => DashboardScreen()),
    GetPage(name: Routes.notificationScreen, page: () => NotificationScreen()),

    GetPage(name: Routes.depositScreen, page: () => DepositScreen()),
    GetPage(
      name: Routes.depositPreviewScreen,
      page: () => DepositPreviewScreen(),
    ),

    //help center
    GetPage(
      name: Routes.helpCenter,
      page: () => WebViewScreen(
        title: Strings.helpCenter,
        url: "${ApiEndpoint.mainDomain}/contact",
      ),
    ),

    //privacy policy
    GetPage(
      name: Routes.privacyPolicy,
      page: () => WebViewScreen(
        title: Strings.privacyAndPolicy,
        url: "${ApiEndpoint.mainDomain}/page/privacy-policy",
      ),
    ),

    //about us
    GetPage(
      name: Routes.aboutUs,
      page: () => WebViewScreen(
        title: Strings.aboutUs,
        url: "${ApiEndpoint.mainDomain}/about",
      ),
    ),

    //!drawer screens
    GetPage(
      name: Routes.transactionLogScreen,
      page: () => TransactionLogScreen(),
    ),

    GetPage(
      name: Routes.changePasswordScreen,
      page: () => ChangePasswordScreen(),
    ),

    //!profile screen
    GetPage(name: Routes.mygiftCardScreen, page: () => MyCardScreen()),
    GetPage(
      name: Routes.updateProfileScreen,
      page: () => UpdateProfileScreen(),
    ),
    GetPage(
      name: Routes.manualPaymentScreen,
      page: () => ManualPaymentScreen(),
    ),
    GetPage(name: Routes.webPaymentScreen, page: () => WebPaymentScreen()),

    GetPage(name: Routes.kycScreen, page: () => KycScreen()),

    ///>>>>>>>>>>>> stripe card screen
    GetPage(
      name: Routes.stripeCardDetailsScreen,
      page: () => StripeCardDetailsScreen(),
    ),
    GetPage(
      name: Routes.stripeTransactionHistoryScreen,
      page: () => StripeTransactionHistoryScreen(),
    ),
    GetPage(
      name: Routes.moneyTransferScreen,
      page: () => const MonetTransferScreen(),
    ),
    GetPage(
      name: Routes.moneyTransferPreviewScreen,
      page: () => MoneyTransferPreviewScreen(),
    ),

    GetPage(
      name: Routes.stripeWebPaymentScreen,
      page: () => StripeWebPaymentScreen(),
    ),
    //money out
    GetPage(name: Routes.moneyOutScreen, page: () => MoneyOutScreen()),
    GetPage(
      name: Routes.moneyOutManualPaymentScreen,
      page: () => MoneyOutManualPaymentScreen(),
    ),
    GetPage(
      name: Routes.moneyOutPreviewScreen,
      page: () => MoneyOutPreviewScreen(),
    ),
    // Aliases — Dashboard and other call sites use the `withdraw*` naming.
    // These resolve to the same screens as `moneyOut*` so both naming
    // conventions work.
    GetPage(name: Routes.withdrawScreen, page: () => MoneyOutScreen()),
    GetPage(
      name: Routes.withdrawPreviewScreen,
      page: () => MoneyOutPreviewScreen(),
    ),
    GetPage(
      name: Routes.flutterWebPaymentScreen,
      page: () => FlutterWebPaymentScreen(),
    ),
    GetPage(
      name: Routes.sslCommerzWebPaymentScreen,
      page: () => SslCommerzWebPaymentScreen(),
    ),
    GetPage(
      name: Routes.bkashWebPaymentScreen,
      page: () => BkashWebViewScreen(),
    ),
    GetPage(
      name: Routes.razorPayWebPaymentScreen,
      page: () => RazorPayWebPaymentScreen(),
    ),
    GetPage(
      name: Routes.qrPayWebPaymentScreen,
      page: () => QrPayWebPaymentScreen(),
    ),
    GetPage(
      name: Routes.coinWebPaymentScreen,
      page: () => CoinWebPaymentScreen(),
    ),
    GetPage(name: Routes.stripCardPreview, page: () => StripCardPreview()),

    // sudo card pages
    GetPage(
      name: Routes.sudoCreateNewScreen,
      page: () => SudoCreateNewScreen(),
    ),
    GetPage(
      name: Routes.sudoCreateNewCardPreviewScreen,
      page: () => SudoCreateNewCardPreviewScreen(),
    ),
    GetPage(
      name: Routes.createNewCardPreviewScreen,
      page: () => CreateNewCardPreviewScreen(),
    ),
    GetPage(
      name: Routes.sudoCardDetailsScreen,
      page: () => SudoCardDetailsScreen(),
    ),

    GetPage(name: Routes.createNewScreen, page: () => CreateNewScreen()),
    GetPage(name: Routes.settingsScreen, page: () => SettingsScreen()),
    GetPage(name: Routes.addFundScreen, page: () => AddFundScreen()),
    GetPage(name: Routes.cardDetailsScreen, page: () => CardDetailsScreen()),
    GetPage(
      name: Routes.transactionHistoryScreen,
      page: () => TransactionHistoryScreen(),
    ),
    GetPage(
      name: Routes.addFundPreviewScreen,
      page: () => AddFundPreviewScreen(),
    ),
    GetPage(
      name: Routes.sudoTransactionHistoryScreen,
      page: () => SudoTransactionHistoryScreen(),
    ),
    GetPage(name: Routes.tatumPaymentScreen, page: () => TatumPaymentScreen()),

    GetPage(
      name: Routes.strowalletCardDetailsScreen,
      page: () => StrowalletCardDetailsScreen(),
    ),
    GetPage(
      name: Routes.strowalletTransactionHistoryScreen,
      page: () => StrowalletTransactionHistoryScreen(),
    ),
    GetPage(
      name: Routes.strowalletAddFundScreen,
      page: () => StrowalletAddFundScreen(),
    ),
    GetPage(
      name: Routes.strowalletWithdrawScreen,
      page: () => StrowalletWithdrawScreen(),
    ),
    GetPage(
      name: Routes.crateStrowalletScreen,
      page: () => CrateStrowalletScreen(),
    ),

    // GetPage(
    //   name:  Routes.sudoAddFundScreen,
    //   page:  () => SudoAddFundScreen(),
    //        ) ,

    //>>>>>>>>>> gift card
    GetPage(name: Routes.giftCardScreen, page: () => GiftCardScreen()),
    GetPage(name: Routes.allGiftCardScreen, page: () => AllGiftCardScreen()),
    GetPage(
      name: Routes.createGiftCardScreen,
      page: () => CreateGiftCardScreen(),
    ),

    GetPage(
      name: Routes.updateCustomerKycScreen,
      page: () => UpdateCustomerKycScreen(),
    ),

    //two fa
    GetPage(name: Routes.enable2FaScreen, page: () => Enable2FaScreen()),
    GetPage(name: Routes.otp2FaScreen, page: () => Otp2FaScreen()),
    GetPage(name: Routes.webhookLogsScreen, page: () => WebhookLogsScreen()),
    GetPage(
      name: Routes.cardyfieAddFundScreen,
      page: () => CardyfieDepositScreen(),
    ),
    // cardyfie card
    GetPage(
      name: Routes.cardyfieDetailsScreen,
      page: () => CardyfieDetailsScreen(),
    ),

    GetPage(
      name: Routes.crateCardyfieScreen,
      page: () => CrateCardyfieScreen(),
    ),
    GetPage(
      name: Routes.cardyfieTransactionHistoryScreen,
      page: () => CardyfieTransactionLogScreen(),
    ),

    GetPage(
      name: Routes.cardyfieWithdrawScreen,
      page: () => CardyfieWithdrawScreen(),
    ),

    GetPage(
      name: Routes.cardyfieUpdateCustomerScreen,
      page: () => UpdateCustomerScreen(),
    ),
    GetPage(
      name: Routes.addFundCardyfiePreviewScreen,
      page: () => AddFundCardyfiePreviewScreen(),
    ),

    GetPage(
      name: Routes.addFundCardyfiePreviewScreen,
      page: () => AddFundCardyfiePreviewScreen(),
    ),

    GetPage(
      name: Routes.cardyfieWithdrawPreviewScreen,
      page: () => CardyfieWithdrawPreviewScreen(),
    ),
  ];
}
