part of '../cardyfie_withdraw_screen.dart';

class CardyfieWithdrawFundWidget extends StatelessWidget {
  CardyfieWithdrawFundWidget({Key? key, required this.buttonText})
    : super(key: key);
  final String buttonText;
  final controller = Get.put(CardyfieWithdrawFundController());
  final walletController = Get.put(VirtualCardyfieCardController());

  // ── Numpad rules — preserves the original totalAmount/append logic ──────
  void _onKey(String value) {
    if (value == '.' && controller.totalAmount.contains('.')) {
      return;
    }
    controller.totalAmount.add(value);
    controller.amountTextController.text = controller.totalAmount.join('');
  }

  void _onBackspace() {
    if (controller.totalAmount.isNotEmpty) {
      controller.totalAmount.removeLast();
      controller.amountTextController.text = controller.totalAmount.join('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _amountWidget(context),
          const SizedBox(height: 12),
          _limitWidget(context),
          const SizedBox(height: 20),
          _walletDropDownWidget(context),
          const SizedBox(height: 8),
          SCNumpad(onKey: _onKey, onBackspace: _onBackspace),
          const SizedBox(height: 24),
          _buttonWidget(context),
        ],
      ),
    );
  }

  Widget _amountWidget(BuildContext context) {
    return Column(
      children: [
        SCAmountInput(
          controller: controller.amountTextController,
          currencySymbol: r'$',
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            'USD',
            style: AppTextStyles.numSm.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }

  Widget _buttonWidget(BuildContext context) {
    return SCPrimaryButton(
      label: buttonText,
      onPressed: () {
        Get.toNamed(Routes.cardyfieWithdrawPreviewScreen);
      },
    );
  }

  Widget _walletDropDownWidget(BuildContext context) {
    return Obx(
      () => SCSurfaceCard(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        color: AppColors.surface2,
        child: CustomDropDown<UserWallet>(
          dropDownHeight: 52,
          items: walletController.walletsList,
          customBorderRadius: BorderRadius.circular(AppRadius.lg),
          hint: walletController.selectMainWallet.value!.title,
          onChanged: (value) {
            walletController.selectMainWallet.value = value!;
            walletController.fromCurrency.value =
                value.currency.code.toString();
            print(walletController.fromCurrency.value);
          },
          padding: const EdgeInsets.symmetric(horizontal: 10),
          titleTextColor: AppColors.text,
          borderEnable: false,
          dropDownFieldColor: Colors.transparent,
          dropDownIconColor: AppColors.text3,
        ),
      ),
    );
  }

  Widget _limitWidget(BuildContext context) {
    Widget row(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                value,
                style: AppTextStyles.numSm.copyWith(color: AppColors.text2),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        row(
          Strings.limit,
          "${walletController.cardyfieCardModel.data.cardCharge.minLimit} - ${walletController.cardyfieCardModel.data.cardCharge.maxLimit} ${walletController.fromCurrency.value}",
        ),
        row(
          Strings.exchangeRate,
          "1 ${walletController.fromCurrency.value} = 1.00 ${walletController.fromCurrency.value}",
        ),
        row(
          Strings.remainingDailyLimit,
          ": ${walletController.remainingController.remainingDailyLimit.value.toStringAsFixed(2)} ${walletController.fromCurrency.value}",
        ),
        row(
          Strings.remainingMonthlyLimit,
          ": ${walletController.remainingController.remainingMonthLyLimit.value.toStringAsFixed(2)} ${walletController.fromCurrency.value}",
        ),
      ],
    );
  }
}
