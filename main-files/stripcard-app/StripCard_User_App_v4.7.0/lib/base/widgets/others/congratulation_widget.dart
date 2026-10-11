import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";

import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/widgets/text_labels/title_subtitle_widget.dart";

class StatusScreen {
  static show(
      {required BuildContext context,
      required String subTitle,
      required VoidCallback onPressed,
      bool ifSuccess = true}) {
    var widget = PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didpop, pop) {
        onPressed;
      },
      child: Scaffold(
        backgroundColor: Get.isDarkMode ? AppColorsDark.bg : AppColors.bg,
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Dimensions.marginSizeHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Design-system status badge (accent for success, danger for error).
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ifSuccess
                      ? AppColors.accentSoft
                      : AppColors.dangerSoft,
                  border: Border.all(
                    color: ifSuccess ? AppColors.accent : AppColors.danger,
                    width: 2.5,
                  ),
                ),
                child: Icon(
                  ifSuccess ? Icons.check_rounded : Icons.close_rounded,
                  size: 48,
                  color: ifSuccess ? AppColors.accentInk : AppColors.danger,
                ),
              ),
              verticalSpace(18),
              TitleSubTitleWidget(
                title: ifSuccess ? Get.find<LanguageController>().getTranslation(Strings.congratulations) : Get.find<LanguageController>().getTranslation(Strings.opps),
                subtitle: subTitle,
                crossAxisAlignment: crossCenter,
              ),
              verticalSpace(32),
              PrimaryButton(
                title: Get.find<LanguageController>().getTranslation(Strings.okay),
                onPressed: onPressed,
              )
            ],
          ),
        ),
      ),
    );

    showDialog(
        context: context,
        builder: (context) {
          return widget;
        });
  }
}
