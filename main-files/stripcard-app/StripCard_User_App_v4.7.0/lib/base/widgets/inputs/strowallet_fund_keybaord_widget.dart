import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/controller/add_fund_strowallet_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_amount_input.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_numpad.dart";

class StrowalletAddFundWidget extends StatelessWidget {
  StrowalletAddFundWidget({
    Key? key,
    required this.buttonText,
    this.isWithdraw = false,
  }) : super(key: key);
  final String buttonText;

  /// When true the submit hits the withdraw endpoint instead of add-fund.
  final bool isWithdraw;
  final controller = Get.put(StrowalletAddFundController());
  final dashBoardController = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return _bodyWidget(context);
  }

  _bodyWidget(BuildContext context) {
    var data = controller.cardChargesModel.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        _inputFieldWidget(context),
        const SizedBox(height: 16),
        limitWidget(
            fee:
                "${dashBoardController.fixedCharge.value} ${data.baseCurr} + ${dashBoardController.percentCharge.value} %",
            limit:
                "${dashBoardController.limitMin.value} ${data.baseCurr} - ${dashBoardController.limitMax.value} ${data.baseCurr}"),
        const SizedBox(height: 16),
        _customNumKeyBoardWidget(context),
        const SizedBox(height: 20),
        _buttonWidget(context),
      ],
    );
  }

  // Renders the amount + currency suffix. SCAmountInput is read-only display
  // bound to the same amountTextController the original used.
  _inputFieldWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            Strings.amount,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: SCAmountInput(
                  controller: controller.amountTextController,
                  currencySymbol: '',
                ),
              ),
              const SizedBox(width: 8),
              Text(
                controller.cardChargesModel.data.baseCurr,
                style: AppTextStyles.numMd.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Numpad — mirrors the original inputItem rules: append digit/dot, prevent a
  // second dot, and the backspace removes the last char. All mutations go
  // through the same controller.totalAmount + amountTextController pair the
  // original keyboard used, so the submit body is byte-for-byte compatible.
  _customNumKeyBoardWidget(BuildContext context) {
    void setText() {
      controller.amountTextController.text = controller.totalAmount.join('');
    }

    void onKey(String key) {
      if (key == '.') {
        if (controller.totalAmount.contains('.')) return;
      }
      controller.totalAmount.add(key);
      setText();
    }

    void onBackspace() {
      if (controller.totalAmount.isNotEmpty) {
        controller.totalAmount.removeLast();
        setText();
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SCNumpad(onKey: onKey, onBackspace: onBackspace),
    );
  }

  _buttonWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(
        () => SCPrimaryButton(
          label: buttonText,
          loading: controller.isLoading,
          onPressed: () {
            if (controller.amountTextController.text.isNotEmpty) {
              if (isWithdraw) {
                controller.withdrawProcess(context);
              } else {
                controller.addFundProcess(context);
              }
            } else {
              CustomSnackBar.error("Strings.plzEnterAmount");
            }
          },
        ),
      ),
    );
  }
}

Widget limitWidget({required fee, required limit}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: crossStart,
      children: [
        Row(
          children: [
            Text(
              Strings.transferFee,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                ": $fee",
                style: AppTextStyles.caption.copyWith(color: AppColors.text),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              Strings.limit,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                ": $limit",
                style: AppTextStyles.caption.copyWith(color: AppColors.text),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
