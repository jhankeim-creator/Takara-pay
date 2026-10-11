import "package:stripcard/base/utils/basic_widget_import.dart";
import "package:stripcard/base/widgets/appbar/back_button.dart";

class TransactionAppBarWidget extends AppBar {
  final String text;
  final VoidCallback? onTapLeading;
  final bool homeButtonShow;
  final PreferredSizeWidget? bottomBar;

  TransactionAppBarWidget(
      {required this.text,
      this.onTapLeading,
      this.homeButtonShow = false,
      this.bottomBar,
      super.key})
      : super(
          title: TitleHeading1Widget(
            text: text,
            fontWeight: FontWeight.w500,
            color: CustomColor.primaryLightColor,
          ),
          elevation: 0,
          backgroundColor: Get.isDarkMode
              ? CustomColor.primaryLightScaffoldBackgroundColor
              : CustomColor.bgLightColor,
          actions: [
            Visibility(
              visible: homeButtonShow,
              child: IconButton(
                  onPressed: onTapLeading,
                  icon: const Icon(
                    Icons.home,
                    color: CustomColor.primaryLightColor,
                  )),
            )
          ],
          bottom: bottomBar,
          leading: BackButtonWidget(
            onTap: onTapLeading ??
                () {
                  Get.close(1);
                },
          ),
        );
}
