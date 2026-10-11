import "package:TAKARA PAY/views/navbar/controller/navbar_controller.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_bottom_nav.dart";

class BottomNavBarScreen extends StatelessWidget {
  BottomNavBarScreen({super.key});

  final bottomNavBarController = Get.put(NavbarController(), permanent: false);
  final DashBoardController dashBoardController = Get.put(
    DashBoardController(),
  );

  // Maps the 4 nav slots to the controller's page list.
  // Send (controller idx 2) is intentionally absent from the nav — reachable
  // via the Wallet ("You") screen's Send action. The drawer is gone — its
  // home (settings) is now the "You" tab destination at idx 5.
  //
  //   nav 0 Home     → 0 Dashboard
  //   nav 1 Cards    → 3 MyCard
  //   nav 2 Activity → 4 Notifications
  //   nav 3 You      → 5 Settings
  static const List<int> _navToTab = [0, 3, 4, 5];

  int _tabToNav(int tab) {
    final i = _navToTab.indexOf(tab);
    return i == -1 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = bottomNavBarController.selectedIndex.value;
      final initialLoading = dashBoardController.isLoading &&
          !dashBoardController.hasLoadedOnce.value;

      return Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            // Active tab content — preserves the controller's page list.
            bottomNavBarController.page[selected],
            // Floating bottom nav — hidden during the very first dashboard
            // load so it doesn't render over a half-empty screen.
            if (!initialLoading)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SCBottomNav(
                  currentIndex: _tabToNav(selected),
                  onChanged: (navIdx) {
                    bottomNavBarController.selectedIndex.value =
                        _navToTab[navIdx];
                  },
                ),
              ),
          ],
        ),
      );
    });
  }
}
