import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/views/virtual_card_stripe/controller/stripe_two_controller.dart";
import "package:TAKARA PAY/views/remaining_balance/controller/remaing_balance_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_spacing.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_section_header.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_surface_card.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_text_field.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_virtual_card.dart";
import "package:TAKARA PAY/base/widgets/others/all_supported_currency_widget/supported_currecny_dropdown.dart";

class StripeCreateCardScreen extends StatelessWidget {
  StripeCreateCardScreen({super.key, required this.controller});

  final StripeTwoController controller;

  final remainingController = Get.put(RemainingBalanceController());

  @override
  Widget build(BuildContext context) {
    controller.percentCharge.value =
        controller.stripeCardModel.data.cardCharge.percentCharge.toDouble();
    controller.updateLimits();
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
          Strings.confirm,
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: SCPrimaryButton(
            label: Strings.confirm,
            onPressed: () {
              if (controller.fundAmountController.text.isNotEmpty) {
                controller.calculation();
                Get.toNamed(Routes.stripCardPreview);
              } else {
                CustomSnackBar.error(Strings.plzEnterAmount);
              }
            },
          ),
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
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      physics: const BouncingScrollPhysics(),
      children: [
        _imageWidget(context),
        const SizedBox(height: AppSpacing.xxl),
        const SCSectionHeader(label: 'CURRENCY'),
        StripSupportedCurrency(
          itemsList: controller.supportedCurrencyList,
          selectMethod: controller.selectedSupportedCurrency,
          onChanged: (type) {
            controller.selectedSupportedCurrency.value = type!.currencyCode;
            controller.code.value = type.currencyCode;
            controller.selectedSupportedCurrencyRate.value =
                type.rate.toDouble();
            controller.updateLimits();
          },
        ),
        const SizedBox(height: AppSpacing.xl),
        SCTextField(
          controller: controller.fundAmountController,
          label: Strings.cardAmount,
          hint: Strings.amount,
          keyboardType: TextInputType.number,
          onChanged: (p0) {
            controller.calculation();
          },
        ),
        const SizedBox(height: AppSpacing.xl),
        const SCSectionHeader(label: 'LIMITS'),
        _limitInformation(),
      ],
    );
  }

  Widget _imageWidget(BuildContext context) {
    return const SCVirtualCard(
      cardName: Strings.cardHolder,
      last4: '••••',
      expiry: '••/••',
    );
  }

  Widget _limitInformation() {
    return Obx(() {
      final precision = remainingController.dashboardController.precision.value;
      final code = controller.code.value;

      final transactionLimit =
          '${controller.getLimitMin.value.toStringAsFixed(precision)} $code - '
          '${controller.getLimitMax.value.toStringAsFixed(controller.remainingController.dashboardController.precision.value)} $code';
      final dailyLimit =
          '${controller.getDallyLimit.value.toStringAsFixed(precision)} $code';
      final remainingDailyLimit =
          '${controller.getRemainingDailyLimit.value.toStringAsFixed(controller.remainingController.dashboardController.precision.value)} $code';
      final monthlyLimit =
          '${controller.getMonthlyLimit.value.toStringAsFixed(precision)} $code';
      final remainingMonthLimit =
          '${controller.getRemainingMonthLyLimit.value.toStringAsFixed(precision)} $code';

      return SCSurfaceCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _LimitRow(label: Strings.transactionLimit, value: transactionLimit),
            const _RowDivider(),
            _LimitRow(label: Strings.dailyLimit, value: dailyLimit),
            const _RowDivider(),
            _LimitRow(
                label: Strings.remainingDailyLimit, value: remainingDailyLimit),
            const _RowDivider(),
            _LimitRow(label: Strings.monthlyLimit, value: monthlyLimit),
            const _RowDivider(),
            _LimitRow(
                label: Strings.remainingMonthlyLimit,
                value: remainingMonthLimit),
          ],
        ),
      );
    });
  }
}

class _LimitRow extends StatelessWidget {
  const _LimitRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.numSm.copyWith(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 0.5,
      thickness: 0.5,
      color: AppColors.line,
    );
  }
}
