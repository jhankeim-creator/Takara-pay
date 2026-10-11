import "package:stripcard/views/deposit/controller/deposit_controller.dart";
import "package:stripcard/base/utils/language/strings.dart";
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/routes/routes.dart";
import "package:stripcard/base/widgets/others/congratulation_widget.dart";

class SslCommerzWebPaymentScreen extends StatelessWidget {
  SslCommerzWebPaymentScreen({
    super.key,
  });

  final controller = Get.put(DepositController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () {
            Get.offAllNamed(Routes.bottomNavBarScreen);
          },
        ),
        title: Text(
          Get.find<LanguageController>()
              .getTranslation(Strings.sslcommerzPayment),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.offAllNamed(Routes.bottomNavBarScreen);
              },
              icon: const Icon(
                Icons.home,
                color: AppColors.text,
              ))
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                )
              : _bodyWidget(context),
        ),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    var paymentUrl = controller.automaticPaymentSslcommerzModel.data.url;

    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(paymentUrl)),
      onWebViewCreated: (InAppWebViewController controller) {},
      onProgressChanged: (InAppWebViewController controller, int progress) {},
      onLoadStop: (controller, url) {
        // Handle page load stop, e.g., hide loading indicator

        if (url.toString().contains('sslcommerz/payment/success/')) {
          StatusScreen.show(
              context: context,
              subTitle: Strings.yourMoneyAddedSucces.tr,
              onPressed: () {
                Get.offAllNamed(Routes.bottomNavBarScreen);
              });
        }
      },
    );
  }
}
