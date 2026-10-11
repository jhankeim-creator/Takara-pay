import "package:stripcard/base/utils/custom_loading_api.dart";

import "package:stripcard/base/utils/local_storage.dart";
import "package:stripcard/base/api/model/gift_card/gift_details_model.dart";
import "package:stripcard/views/gift_card/controller/create_gift_card_controller.dart";
import "package:stripcard/views/remaining_balance/controller/remaing_balance_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/widgets/design_system/error_state_widget.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_text_field.dart";
import "package:stripcard/base/widgets/others/limit_information_widget (1).dart";

class CreateGiftCardScreen extends StatelessWidget {
  CreateGiftCardScreen({super.key});

  final controller = Get.put(CreateGiftCardController());
  final remainingController = Get.put(RemainingBalanceController());

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
          Get.find<LanguageController>()
              .getTranslation(Strings.giftCardDetails),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : controller.isLoaded
                  ? _bodyWidget(context)
                  : _errorState(),
        ),
      ),
    );
  }

  // Shown when the details fetch failed or returned no data — keeps the
  // screen from reading the uninitialised model (no more red error screen).
  Widget _errorState() {
    return ErrorStateWidget(
      icon: Icons.error_outline_rounded,
      title: Get.find<LanguageController>()
          .getTranslation(Strings.couldntLoadGiftCard),
      message: Get.find<LanguageController>()
          .getTranslation(Strings.pleaseCheckConnectionTryAgain),
      retryLabel: Get.find<LanguageController>().getTranslation(Strings.retry),
      onRetry: controller.getGiftCardDetailsInfo,
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        _amountWidget(context),
        const SizedBox(height: 16),
        SCTextField(
          controller: controller.receiverEmailController,
          label: Get.find<LanguageController>()
              .getTranslation(Strings.recipientEmailLabel),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _label(Get.find<LanguageController>().getTranslation(Strings.country)),
        const SizedBox(height: 6),
        Obx(
          () => _SelectorField(
            value: controller.selectedCountry.value,
            hint:
                Get.find<LanguageController>().getTranslation(Strings.country),
            icon: Icons.public,
            onTap: () => _openCountrySheet(context),
          ),
        ),
        const SizedBox(height: 16),
        _phoneNumberWidget(context),
        const SizedBox(height: 16),
        SCTextField(
          controller: controller.fromNameController,
          label: Get.find<LanguageController>()
              .getTranslation(Strings.fromYourName),
        ),
        const SizedBox(height: 16),
        SCTextField(
          controller: controller.quantityController,
          label:
              Get.find<LanguageController>().getTranslation(Strings.quantity),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _label(Get.find<LanguageController>().getTranslation(Strings.wallet)),
        const SizedBox(height: 6),
        Obx(
          () => _SelectorField(
            value: controller.selectedWalletName.value,
            hint:
                Get.find<LanguageController>().getTranslation(Strings.wallet),
            icon: Icons.account_balance_wallet_outlined,
            onTap: () => _openWalletSheet(context),
          ),
        ),
        const SizedBox(height: 16),
        LimitInformationWidget(
          transactionLimit: '',
          dailyLimit: controller.dailyLimit.value.toStringAsFixed(
              remainingController.dashboardController.precision.value),
          remainingDailyLimit:
              '${remainingController.remainingDailyLimit.value.toStringAsFixed(remainingController.dashboardController.precision.value)} ${LocalStorage.getBaseCurrency()}',
          monthlyLimit: controller.monthlyLimit.value.toStringAsFixed(
              remainingController.dashboardController.precision.value),
          remainingMonthLimit:
              '${remainingController.remainingMonthLyLimit.value.toStringAsFixed(remainingController.dashboardController.precision.value)} ${LocalStorage.getBaseCurrency()}',
        ),
        const SizedBox(height: 16),
        _buttonWidget(context),
      ],
    );
  }

  Widget _label(String text) => Text(
        text,
        style: AppTextStyles.label.copyWith(color: AppColors.text2),
      );

  Widget _phoneNumberWidget(BuildContext context) {
    return Obx(
      () => SCTextField(
        controller: controller.phoneNumberController,
        label: Get.find<LanguageController>()
            .getTranslation(Strings.phoneNumber),
        keyboardType: TextInputType.phone,
        prefixIcon: Text(
          controller.mobileCode.value,
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text2),
        ),
      ),
    );
  }

  Widget _amountWidget(BuildContext context) {
    // The body is only built once the model is loaded, so reading it directly
    // is safe. denominationType is a plain (non-observable) field, so the
    // variable-amount branch must NOT be wrapped in Obx — only the selectable
    // chips below observe `selectedIndex`.
    final isFixed =
        controller.giftCardDetailsModel.data.product.denominationType ==
            'FIXED';
    if (!isFixed) {
      return SCTextField(
        controller: controller.amountController,
        label: Get.find<LanguageController>().getTranslation(Strings.amount),
        keyboardType: TextInputType.number,
        onChanged: (v) => controller.selectedAmount.value = v,
      );
    }
    final denominations =
        controller.giftCardDetailsModel.data.product.fixedRecipientDenominations;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(Get.find<LanguageController>().getTranslation(Strings.amount)),
        const SizedBox(height: 8),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(denominations.length, (index) {
              final selected = controller.selectedIndex.value == index;
              return InkWell(
                onTap: () => controller.selectedIndex.value = index,
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.accent : AppColors.surface2,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: selected ? AppColors.accent : AppColors.line2,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${denominations[index]} ${LocalStorage.getBaseCurrency()}',
                    style: AppTextStyles.numMd.copyWith(
                      color: selected ? AppColors.accentInk : AppColors.text,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  void _openCountrySheet(BuildContext context) {
    _openSelectionSheet<CountryElement>(
      title: Get.find<LanguageController>().getTranslation(Strings.country),
      items: controller.countryList,
      labelOf: (c) => c.name,
      selectedLabel: controller.selectedCountry.value,
      onSelected: (value) {
        controller.selectedCountry.value = value.name;
        controller.selectedCountryCode.value = value.iso2;
        controller.mobileCode.value = value.mobileCode;
      },
    );
  }

  void _openWalletSheet(BuildContext context) {
    _openSelectionSheet<UserWallet>(
      title: Get.find<LanguageController>().getTranslation(Strings.wallet),
      items: controller.userWalletList,
      labelOf: (w) => w.name,
      selectedLabel: controller.selectedWalletName.value,
      onSelected: (value) {
        controller.selectedWalletName.value = value.name;
        controller.selectedCountryCode.value = value.currencyCode;
      },
    );
  }

  void _openSelectionSheet<T>({
    required String title,
    required List<T> items,
    required String Function(T) labelOf,
    required String selectedLabel,
    required void Function(T) onSelected,
  }) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.7),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: AppTextStyles.h2.copyWith(color: AppColors.text),
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final item = items[i];
                  final label = labelOf(item);
                  final selected = label == selectedLabel;
                  return ListTile(
                    onTap: () {
                      onSelected(item);
                      Get.back();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    title: Text(
                      label,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check, color: AppColors.accent)
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buttonWidget(BuildContext context) {
    return Obx(
      () => SCPrimaryButton(
        label: Get.find<LanguageController>().getTranslation(Strings.confirm),
        loading: controller.isBuyLoading,
        onPressed: () {
          controller.calculation();
          Get.toNamed(Routes.gifCardPreviewScreen);
        },
      ),
    );
  }
}

class _SelectorField extends StatelessWidget {
  const _SelectorField({
    required this.value,
    required this.hint,
    required this.icon,
    required this.onTap,
  });

  final String value;
  final String hint;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.line2, width: 1),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.text3),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value.isEmpty ? hint : value,
                  style: AppTextStyles.bodyMed.copyWith(
                    color: value.isEmpty ? AppColors.text3 : AppColors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.expand_more, size: 20, color: AppColors.text3),
            ],
          ),
        ),
      ),
    );
  }
}
