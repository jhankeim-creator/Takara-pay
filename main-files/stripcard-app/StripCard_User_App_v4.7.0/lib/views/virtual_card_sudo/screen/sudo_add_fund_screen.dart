import 'package:flutter/material.dart';
import 'package:get/get.dart';

import "package:stripcard/views/virtual_card_sudo/controller/sudo_adfund_controller.dart";
import "package:stripcard/base/utils/language/strings.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/widgets/inputs/sudo_add_fund_keybaord.dart";

class SudoAddFundScreen extends StatelessWidget {
  SudoAddFundScreen({super.key, required this.appBarTitle});

  final String appBarTitle;
  final controller = Get.put(SudoAddFundController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: Get.back,
        ),
        title: Text(
          appBarTitle,
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
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

  Widget _bodyWidget(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        SudoAddFundCustomAmountWidget(
          buttonText: appBarTitle,
          onTap: () {
            debugPrint(appBarTitle);
            if (appBarTitle == Strings.addFund) {
              controller.sudoAddFundProcess();
            } else {}
          },
        ),
      ],
    );
  }
}
