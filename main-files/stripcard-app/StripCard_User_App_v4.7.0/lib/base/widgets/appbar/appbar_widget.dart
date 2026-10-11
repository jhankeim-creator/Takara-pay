import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/appbar/back_button.dart";

class AppBarWidget extends AppBar {
  final String text;

  final VoidCallback? onTap;
  final List<Widget>? actions;

  AppBarWidget({
    required this.text,
    this.onTap,
    this.actions,
    super.key,
  }) : super(
          title: TitleHeading1Widget(
            text: text,
            fontWeight: FontWeight.w500,
            color: Get.isDarkMode
                ? CustomColor.primaryLightTextColor
                : CustomColor.primaryDarkTextColor,
          ),
          elevation: 0,
          backgroundColor: Get.isDarkMode
              ? CustomColor.primaryDarkScaffoldBackgroundColor
              : CustomColor.bgLightColor,
          leading: BackButtonWidget(),
          actions: actions,
        );
}
