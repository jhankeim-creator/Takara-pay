import 'package:iconsax/iconsax.dart';
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/base/utils/custom_loading_api.dart";
import "package:TAKARA PAY/views/auth/controller/log_out/log_out.dart";
import "package:TAKARA PAY/base/utils/theme.dart";
import "package:TAKARA PAY/base/widgets/others/custom_image_widget.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_network_image.dart";

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);
  final controller = Get.put(DashBoardController());
  final logOutController = Get.put(LogOutController());
  final Themes themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Drawer(
        width: screenWidth >= 600
            ? MediaQuery.of(context).size.width / 1.6
            : MediaQuery.of(context).size.width / 1.34,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Dimensions.radius * 2),
          ),
        ),
        backgroundColor: Get.isDarkMode
            ? CustomColor.primaryDarkScaffoldBackgroundColor
            : CustomColor.whiteColor,
        child: ListView(
          children: [
            _backIcon(),
            _userImgWidget(context),
            _userTextwidget(context),
            _drawerWidget(context),
            // DarkModeWidget()
          ],
        ),
      ),
    );
  }

  _userImgWidget(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          top: Dimensions.paddingSize * 1,
          bottom: Dimensions.paddingSize,
        ),
        height: Dimensions.heightSize * 8.3,
        width: Dimensions.widthSize * 11.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
          color: CustomColor.primaryBGLightColor,
          border: Border.all(
            color: CustomColor.primaryBGLightColor,
            width: 5.w,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radius),
          child: Builder(
            builder: (context) {
              final userImage =
                  scImageProvider(controller.dashBoardModel.data.user.userImage);
              if (userImage == null) {
                return Image.asset(
                  Assets.clipart.user.path,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              }
              return FadeInImage(
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                image: userImage,
                placeholder: AssetImage(Assets.clipart.user.path),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    Assets.clipart.user.path,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  _userTextwidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.marginSizeHorizontal),
      child: Column(
        children: [
          TitleHeading3Widget(
            text:
                "${controller.firstNameController.text} ${controller.lastNameController.text}",
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
            color: Get.isDarkMode
                ? CustomColor.primaryLightTextColor
                : CustomColor.primaryDarkTextColor,
          ),
          TitleHeading4Widget(
            text: controller.emailController.text,
            maxLines: 1,
            color: Get.isDarkMode
                ? CustomColor.primaryLightTextColor
                : CustomColor.primaryDarkTextColor,
            textOverflow: TextOverflow.ellipsis,
          ),
          verticalSpace(Dimensions.heightSize * 2),
        ],
      ),
    );
  }

  _drawerWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      mainAxisAlignment: mainCenter,
      children: [
        controller.dashBoardModel.data.moduleAccess.giftCards == true
            ? _drawerTileWidget(
                icon: Assets.icon.giftCard,
                title: Strings.giftCard,
                onTap: () {
                  Get.toNamed(Routes.giftCardScreen);
                },
              )
            : Container(),
        _drawerTileWidget(
          icon: Assets.icon.transactionsLog,
          title: Strings.transactionLog,
          onTap: () {
            Get.toNamed(Routes.transactionLogScreen);
          },
        ),
        _drawerTileWidget(
          icon: Assets.icon.kycVerification,
          title: Strings.kycVerification,
          onTap: () {
            Get.toNamed(Routes.kycScreen);
          },
        ),
        _drawerTileWidget(
          icon: Assets.icon.changePassword,
          title: Strings.settings,
          onTap: () {
            Get.toNamed(Routes.settingsScreen);
          },
        ),
        _drawerTileWidget(
          icon: Assets.icon.helpCenter,
          title: Strings.helpCenter,
          onTap: () {
            Get.toNamed(Routes.helpCenter);
          },
        ),
        _drawerTileWidget(
          icon: Assets.icon.privacyPolicy,
          title: Strings.privacyPolicy,
          onTap: () {
            Get.toNamed(Routes.privacyPolicy);
          },
        ),
        _drawerTileWidget(
          icon: Assets.icon.aboutUs,
          title: Strings.aboutUs,
          onTap: () {
            Get.toNamed(Routes.aboutUs);
          },
        ),
        _drawerTileWidget(
          icon: Assets.icon.signOut,
          title: Strings.signOut,
          onTap: () {
            _logOutDialogueWidget(context);
          },
        ),
      ],
    );
  }

  _drawerTileWidget({
    required VoidCallback onTap,
    required String title,
    required String icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSize * 1,
          vertical: Dimensions.paddingSize * 0.2,
        ),
        child: Row(
          crossAxisAlignment: crossStart,
          mainAxisAlignment: mainStart,
          children: [
            Container(
              alignment: Alignment.center,
              height: Dimensions.heightSize * 2.5,
              width: Dimensions.widthSize * 3.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
                color: CustomColor.whiteColor.withValues(alpha: 0.2),
              ),
              child: Container(
                padding: EdgeInsets.all(Dimensions.paddingSize * 0.32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
                  color: CustomColor.primaryBGLightColor,
                ),
                child: CustomImageWidget(
                  path: icon,
                  height: Dimensions.heightSize * 1.9,
                  width: Dimensions.widthSize * 2.2,
                  color: CustomColor.whiteColor,
                ),
              ),
            ),
            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: Dimensions.paddingSize * 0.1),
                child: TitleHeading3Widget(
                  text: title,
                  color: Get.isDarkMode
                      ? CustomColor.primaryLightTextColor
                      : CustomColor.primaryDarkTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _logOutDialogueWidget(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,
          insetPadding: EdgeInsets.all(Dimensions.paddingSize * 0.3),
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Builder(
            builder: (context) {
              var width = MediaQuery.of(context).size.width;
              return Container(
                width: width * 0.84,
                margin: EdgeInsets.all(Dimensions.paddingSize * 0.5),
                padding: EdgeInsets.all(Dimensions.paddingSize * 0.9),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? CustomColor.primaryBGDarkColor
                      : CustomColor.whiteColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius * 1.4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: crossCenter,
                  children: [
                    SizedBox(height: Dimensions.heightSize * 2),
                    TitleHeading2Widget(
                      color: CustomColor.thirdLightTextColor,
                      text: Get.find<LanguageController>().getTranslation(Strings.signOutAlert),
                    ),
                    verticalSpace(Dimensions.heightSize * 1),
                    TitleHeading4Widget(
                      color: CustomColor.thirdLightTextColor,
                      text: Get.find<LanguageController>().getTranslation(Strings.doYouWant),
                    ),
                    verticalSpace(Dimensions.heightSize * 1),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .25,
                            child: PrimaryButton(
                              title: Get.find<LanguageController>().getTranslation(Strings.no),
                              onPressed: () {
                                Get.back();
                              },
                              borderColor: CustomColor.secondaryLightTextColor,
                              buttonColor: CustomColor.secondaryLightTextColor,
                            ),
                          ),
                        ),
                        horizontalSpace(Dimensions.widthSize),
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .25,
                            child: Obx(
                              () => logOutController.isLoading
                                  ? const CustomLoadingAPI(
                                      color: CustomColor.primaryLightColor,
                                    )
                                  : PrimaryButton(
                                      title: Get.find<LanguageController>().getTranslation(Strings.yes),
                                      onPressed: () {
                                        logOutController.logOutProcess();
                                      },
                                      borderColor: Theme.of(
                                        context,
                                      ).primaryColor,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

_backIcon() {
  return GestureDetector(
    onTap: () {
      Get.close(1);
    },
    child: Padding(
      padding: EdgeInsets.only(
        top: Dimensions.paddingSize * 0.4,
        left: Dimensions.paddingSize * 0.6,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Icon(
          Iconsax.arrow_left,
          color: CustomColor.primaryLightTextColor,
        ),
      ),
    ),
  );
}
