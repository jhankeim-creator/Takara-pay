import "package:stripcard/routes/route_pages.dart";

class Routes {
  // Page List
  static var list = RoutePageList.list;

  // Route Names
  //!auth
  static const String splashScreen = '/splashScreen';
  static const String onboardScreen = '/onboardScreen';
  static const String signInScreen = '/signInScreen';
  static const String resetOtpScreen = '/resetOtpScreen';
  static const String resetPasswordScreen = '/resetPasswordScreen';
  static const String emailOtpScreen = '/emailOtpScreen';
  static const String registrationScreen = '/registrationScreen';

  //!dashboard
  static const String bottomNavBarScreen = '/bottomNavBarScreen';
  static const String dashboardScreen = '/dashboardScreen';
  static const String stripCardPreview = '/stripCardPreview';

  static const String notificationScreen = '/notificationScreen';

  static const String moneyReceiveScreen = '/moneyReceiveScreen';

  //virtual card

  static const String cardDetailsScreen = '/cardDetailsScreen';
  static const String addFundScreen = '/addFundScreen';
  static const String addFundPreviewScreen = '/addFundPreviewScreen';
  static const String transactionHistoryScreen = '/transactionHistoryScreen';

  //deposit profile

  static const String depositScreen = '/depositScreen';
  static const String webViewScreen = '/webViewScreen';
  static const String depositPreviewScreen = '/depositPreviewScreen';
  static const String manualPaymentScreen = '/manualPaymentScreen';
  static const String webPaymentScreen = '/webPaymentScreen';
  static const String stripeAnimatedScreen = '/stripeAnimatedScreen';

  static const String withdrawScreen = '/withdrawScreen';
  static const String withdrawPreviewScreen = '/withdrawPreviewScreen';
  static const String createNewScreen = '/CreateNewScreen';
  static const String gifCardPreviewScreen = '/gifCardPreviewScreen';
  static const String createNewCardPreviewScreen =
      '/CreateNewCardPreviewScreen';

  static const String changePasswordScreen = '/changePasswordScreen';
  static const String transactionLogScreen = '/transactionLogScreen';

  //!profile

  static const String updateProfileScreen = '/updateProfileScreen';
  static const String mygiftCardScreen = '/mygiftCardScreen';
  static const String kycScreen = '/kycScreen';

  ///>>>>>>> stripe card
  static const String stripeCardDetailsScreen = '/stripeCardDetailsScreen';
  static const String stripeCreateCardScreen = '/stripeCreateCardScreen';

  static const String stripeTransactionHistoryScreen =
      '/stripeTransactionHistoryScreen';

  ///>>>>>> transfer money (P2P)
  static const String moneyTransferScreen = "/moneyTransferScreen";

  ///>>>>>> transfer money preview
  static const String moneyTransferPreviewScreen =
      "/moneyTransferPreviewScreen";

  //link
  static const String privacyPolicy = '/privacyPolicy';
  static const String aboutUs = '/aboutUs';
  static const String helpCenter = '/helpCenter';
  static const String stripeWebPaymentScreen = '/stripeWebPaymentScreen';

  //money out
  static const String moneyOutScreen = '/moneyOutScreen';
  static const String moneyOutManualPaymentScreen =
      '/moneyOutManualPaymentScreen';
  static const String moneyOutPreviewScreen = '/moneyOutPreviewScreen';

  //webview screen
  static const String flutterWebPaymentScreen = '/flutterWebPaymentScreen';
  static const String sslCommerzWebPaymentScreen =
      '/sslCommerzWebPaymentScreen';
  static const String bkashWebPaymentScreen = '/bkashWebPaymentScreen';
  static const String razorPayWebPaymentScreen = '/razorPayWebPaymentScreen';

  ///  Sudo card
  static const String sudoCreateNewScreen = '/sudoCreateNewScreen';
  static const String sudoAddFundScreen = '/sudoAddFundScreen';
  static const String sudoCreateNewCardPreviewScreen =
      '/sudoCreateNewCardPreviewScreen';
  static const String sudoCardDetailsScreen = '/sudoCardDetailsScreen';
  static const String sudoTransactionHistoryScreen =
      '/sudoTransactionHistoryScreen';
  static const String qrPayWebPaymentScreen = '/qrPayWebPaymentScreen';
  static const String coinWebPaymentScreen = '/coinWebPaymentScreen';
  static const String settingsScreen = '/settingsScreen';
  static const String tatumPaymentScreen = '/tatumPaymentScreen';

  // Strowallet screen
  static const String strowalletCardDetailsScreen =
      '/strowalletCardDetailsScreen';
  static const String strowalletTransactionHistoryScreen =
      '/strowalletTransactionHistoryScreen';
  static const String strowalletAddFundScreen = '/strowalletAddFundScreen';
  static const String strowalletWithdrawScreen = '/strowalletWithdrawScreen';
  static const String crateStrowalletScreen = '/crateStrowalletScreen';

  //gift card
  static const String giftCardScreen = '/giftCardScreen';
  static const String allGiftCardScreen = '/allGiftCardScreen';
  static const String createGiftCardScreen = '/createGiftCardScreen';
  static const String updateCustomerKycScreen = '/updateCustomerKycScreen';

  //two fa
  static const String enable2FaScreen = '/enable2FaScreen';
  static const String otp2FaScreen = '/otp2FaScreen';
  static const String webhookLogsScreen = '/webhookLogsScreen';

  // cardyfie card screen
  static const String crateCardyfieScreen = '/crateCardyfieScreen';
  static const String cardyfieTransactionHistoryScreen =
      '/cardyfieTransactionHistoryScreen';
  static const String cardyfieAddFundScreen = '/cardyfieAddFundScreen';
  static const String cardyfieDetailsScreen = '/cardyfieDetailsScreen';

  static const String cardyfieWithdrawScreen = '/cardyfieWithdrawScreen';
    static const String cardyfieUpdateCustomerScreen = '/cardyfieUpdateCustomerScreen';
    static const String addFundCardyfiePreviewScreen = '/addFundCardyfiePreviewScreen';
    static const String cardyfieWithdrawPreviewScreen = '/cardyfieWithdrawPreviewScreen';
}
