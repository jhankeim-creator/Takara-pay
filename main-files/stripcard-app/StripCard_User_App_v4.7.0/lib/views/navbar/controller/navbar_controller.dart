import "package:stripcard/views/navbar/screen/dashboard_screen.dart";
import "package:stripcard/views/navbar/screen/notification_screen.dart";
import "package:stripcard/views/profile/screen/my_card_screen.dart";
import 'package:get/get.dart';
import "package:stripcard/views/my_wallet/screen/my_wallet_screen.dart";
import "package:stripcard/views/drawer/screen/settings_screen.dart";
import "package:stripcard/views/money_transfer/screen/money_transfer_screen.dart";

class NavbarController extends GetxController {
  RxInt selectedIndex = 0.obs;
  List page = [
    DashboardScreen(),
    MyWalletScreen(),
    MonetTransferScreen(),
    MyCardScreen(),
    NotificationScreen(),
    SettingsScreen(), // 5 — "You" tab destination (replaces drawer)
  ];
  void selectedPage(int index) {
    selectedIndex.value = index;
  }

  void goToWalletScreen() {
    selectedPage(1);
  }
}
