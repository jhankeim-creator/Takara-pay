import 'dart:convert';

import "package:stripcard/views/deposit/controller/deposit_controller.dart";
import "package:stripcard/base/utils/language/strings.dart";
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/routes/routes.dart";
import "package:stripcard/base/widgets/others/congratulation_widget.dart";

class BkashWebViewScreen extends StatelessWidget {
  BkashWebViewScreen({
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
          Get.find<LanguageController>().getTranslation(Strings.bkashPayment),
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
    var paymentUrl = controller.automaticBkashModel.data.url;

    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(paymentUrl)),
      onWebViewCreated: (InAppWebViewController inAppWebViewController) {},
      onWindowFocus: (controller) {
        print('object');
      },
      onProgressChanged:
          (InAppWebViewController inAppWebViewController, int progress) {},
      onLoadStop: (InAppWebViewController inAppWebViewController, url) async {
        if (url != null) {
          String? pageContent = await inAppWebViewController.evaluateJavascript(
            source: "document.body.innerText",
          );
          print("Page Content: $pageContent"); // Debugging

          if (pageContent != null && pageContent.isNotEmpty) {
            try {
              Map<String, dynamic> parsedJson = json.decode(pageContent);

              if (parsedJson.containsKey('type')) {
                if (parsedJson['type'] == 'success') {
                  Get.offAll(
                    () => StatusScreen(),
                  );
                } else if (parsedJson['type'] == 'error') {
                  Get.close(1);
                  CustomSnackBar.error(
                    parsedJson['message']['error'].first,
                  );
                }
              } else {
                print("Error: 'type' key not found in JSON.");
              }
            } catch (e) {
              print("Error parsing JSON: $e");
            }
          }
        }
      },
    );
  }
}
