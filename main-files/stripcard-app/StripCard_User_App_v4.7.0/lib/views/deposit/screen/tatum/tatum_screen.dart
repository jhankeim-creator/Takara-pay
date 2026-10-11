import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/views/deposit/controller/deposit_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_section_header.dart";
import "package:stripcard/base/widgets/design_system/sc_shimmer.dart";
import "package:stripcard/base/widgets/design_system/sc_surface_card.dart";

class TatumPaymentScreen extends StatelessWidget {
  TatumPaymentScreen({super.key});
  final controller = Get.put(DepositController());
  final formKey = GlobalKey<FormState>();

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
          Strings.tatumPayment,
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading
              ? const SCDetailSkeleton()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          _amountWidget(context),
          const SizedBox(height: 24),
          _qrCodeWidget(),
          const SizedBox(height: 24),
          // Dynamic input fields are constructed in the controller — render
          // them as-is to preserve their controller bindings.
          ...controller.inputFields.map((element) => element).toList(),
          _copyAddressWidget(context),
          const SizedBox(height: 24),
          _buttonWidget(context),
        ],
      ),
    );
  }

  Widget _buttonWidget(BuildContext context) {
    return Obx(
      () => SCPrimaryButton(
        label: Strings.proceed,
        loading: controller.isTatumConfirmLoading,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            controller.tatumConfirmProcess(context);
          }
        },
      ),
    );
  }

  Widget _copyAddressWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SCSectionHeader(label: Strings.payWithThisAddress),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.line2, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => Text(
                    controller.qrAddress.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.numSm.copyWith(color: AppColors.text),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: controller.qrAddress.value),
                    ).then((_) {
                      CustomSnackBar.success(Strings.addressCopyTo);
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.copy,
                      size: 18,
                      color: AppColors.accentInk,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _qrCodeWidget() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          color: Colors.white,
          border: Border.all(color: AppColors.line2, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => QrImageView(
            data: controller.qrAddress.value,
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
      ),
    );
  }

  Widget _amountWidget(BuildContext context) {
    return SCSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Strings.totalPayable.toUpperCase(),
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 10),
          Text(
            controller.tatumGatewayModel.data.paymentInfo.payableAmount,
            textAlign: TextAlign.center,
            style: AppTextStyles.numDisplay.copyWith(color: AppColors.text),
          ),
        ],
      ),
    );
  }
}
