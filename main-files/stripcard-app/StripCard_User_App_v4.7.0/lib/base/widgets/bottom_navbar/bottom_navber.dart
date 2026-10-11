// ignore_for_file: deprecated_member_use

import 'package:flutter_svg/svg.dart';
import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

Widget buildBottomNavigationMenu(
  BuildContext context,
  bottomNavBarController,
  DashBoardController dashBoardController,
) {
  return Container(
    // height: Dimensions.appBarHeight,
    decoration: BoxDecoration(
      color: Get.isDarkMode
          ? CustomColor.primaryLightScaffoldBackgroundColor
          : CustomColor.whiteColor,
    ),
    child: BottomNavigationBar(
      showUnselectedLabels: false,
      showSelectedLabels: false,
      backgroundColor: Colors.transparent, 
      elevation: 0,
      type: BottomNavigationBarType.fixed, 
      selectedItemColor: CustomColor.primaryLightColor, 
      unselectedItemColor: CustomColor.grayColor.withOpacity(0.4),
      currentIndex: bottomNavBarController.selectedIndex.value,
      onTap: (index) {
        bottomNavBarController.selectedIndex.value = index;
      },
      items: [
        bottomNavItem(Assets.icon.home, 0, bottomNavBarController),
        bottomNavItem(Assets.icon.deposit, 1, bottomNavBarController),
        if (dashBoardController.dashBoardModel.data.moduleAccess.transferMoney)
          bottomNavItem(
            Assets.icon.send,
            2,
            bottomNavBarController,
            isFloating: true,
          ),
        bottomNavItem(Assets.icon.myGift, 3, bottomNavBarController),
        bottomNavItem(Assets.icon.messagetext, 4, bottomNavBarController),
      ],
    ),
  );
}

BottomNavigationBarItem bottomNavItem(
  String icon,
  int page,
  var bottomNavBarController, {
  bool isFloating = false,
}) {
  bool isSelected = bottomNavBarController.selectedIndex.value == page;

  return BottomNavigationBarItem(
    
    icon: CircleAvatar(
      radius: isFloating ? 18.r : 20.r, // Slightly smaller icons
      backgroundColor: isFloating
          ? CustomColor.whiteColor.withOpacity(0.1)
          : CustomColor.transparent,
      child: SvgPicture.asset(
        icon,
        color: isSelected
            ? CustomColor.primaryLightColor
            : CustomColor.grayColor.withOpacity(0.4),
        height: Dimensions.heightSize * 1.7, // Smaller height for icons
      ),
    ),
    label: "",

    // Keeps it clean and minimal
  );
}
