import "package:TAKARA PAY/base/api/model/common/common_success_model.dart";
import "package:TAKARA PAY/base/api/model/transfer_money/transfer_exist_model.dart";
import "package:TAKARA PAY/base/api/services/api_services.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_success_screen.dart";
import "package:TAKARA PAY/views/remaining_balance/controller/remaing_balance_controller.dart";
import "package:TAKARA PAY/views/money_transfer/controller/money_transfer_info_controller.dart";

class MoneyTransferController extends GetxController {
  final receiverEmailController = TextEditingController();
  final amountController = TextEditingController();
  final remainingController = Get.put(RemainingBalanceController());
  final moneyInfoController = Get.put(MoneyTransferInfoController());

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  ///  >>>>>> Start check user  process
  var amount = 0.0.obs; // Observable variable
  List<double> presetAmounts = [10, 20, 50, 100, 200];

  @override
  void onInit() {
    super.onInit();
    amountController.text = amount.value.toStringAsFixed(2);
  }

  @override
  void onClose() {
    receiverEmailController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void setAmount(double value) {
    amount.value = value;
    amountController.text = value.toStringAsFixed(2);
  }

  void increment() {
    amount.value += 1;
    amountController.text = amount.value.toStringAsFixed(2);
  }

  void decrement() {
    if (amount.value > 0) {
      amount.value -= 1;
      amountController.text = amount.value.toStringAsFixed(2);
    }
  }

  // Instant recipient verification. Holds the verified user (for showing their
  // name) and any verify error. Does NOT navigate — verification is inline so
  // the user confirms the recipient before continuing.
  final Rxn<ExistUser> verifiedUser = Rxn<ExistUser>();
  final RxString verifyError = ''.obs;
  final _isVerifying = false.obs;
  bool get isVerifying => _isVerifying.value;
  bool get isVerified => verifiedUser.value != null;

  /// Clears the verified state — call when the email field changes so a stale
  /// verification can't be carried into the summary.
  void clearVerification() {
    if (verifiedUser.value != null || verifyError.value.isNotEmpty) {
      verifiedUser.value = null;
      verifyError.value = '';
    }
  }

  Future<void> verifyRecipient() async {
    final email = receiverEmailController.text.trim();
    if (email.isEmpty) return;
    _isVerifying.value = true;
    verifyError.value = '';
    verifiedUser.value = null;
    update();

    final model = await ApiServices.transferMoneyCheckUserApi(
      body: {"email": email},
    );
    if (model?.existUser != null) {
      verifiedUser.value = model!.existUser;
    } else {
      // ApiMethod already surfaces the backend reason (e.g. "User not found")
      // as a snackbar; keep an inline message too.
      verifyError.value = 'No TAKARA PAY user found with this email.';
    }

    _isVerifying.value = false;
    update();
  }

  // ── Transfer limits / charge (from the /info model, fail-safe) ──────────
  double get minLimit => _chargeNum((c) => c.minLimit);
  double get maxLimit => _chargeNum((c) => c.maxLimit);
  double get fixedCharge => _chargeNum((c) => c.fixedCharge);
  double get percentCharge => _chargeNum((c) => c.percentCharge);

  double _chargeNum(dynamic Function(dynamic charge) pick) {
    try {
      final charge =
          moneyInfoController.transferMoneyInfoModel.data.transferMoneyCharge;
      final v = pick(charge);
      return v is num ? v.toDouble() : double.tryParse('$v') ?? 0;
    } catch (_) {
      return 0;
    }
  }

  //transfer confirm
  final _isConfirmLoading = false.obs;

  bool get isConfirmLoading => _isConfirmLoading.value;
  // Was `late CommonSuccessModel _transferConfirmModel;` — same crash
  // risk on insufficient-balance / over-limit 400 responses.
  CommonSuccessModel? _transferConfirmModel;

  CommonSuccessModel? get transferConfirmModel => _transferConfirmModel;
  // Legacy alias kept for backward compat — nothing else in the codebase
  // reads `buyCardModel` (verified via project-wide grep), but preserving
  // the symbol in case external code does.
  CommonSuccessModel? get buyCardModel => _transferConfirmModel;
  bool get hasTransferConfirmData => _transferConfirmModel != null;

  Future<CommonSuccessModel?> transferMoneyConfirmProcess(context) async {
    _isConfirmLoading.value = true;
    update();
    Map<String, dynamic> inputBody = {
      "email": receiverEmailController.text,
      "amount": amountController.text,
    };
    await ApiServices.transferMoneyConfirmApi(body: inputBody)
        .then((value) {
          _transferConfirmModel = value!;
          update();

          final amount = double.tryParse(amountController.text) ?? 0;
          final fee = _resolveFee(amount);
          final total = amount + fee;
          final email = receiverEmailController.text.trim();

          Get.offAll(
            () => SCSuccessScreen(
              title: 'Money sent',
              subtitle: '\$${amount.toStringAsFixed(2)} to $email',
              details: [
                SCSuccessDetail(
                  label: 'To',
                  value: email,
                  copyable: true,
                ),
                SCSuccessDetail(
                  label: 'Amount',
                  value: '\$${amount.toStringAsFixed(2)}',
                  isMono: true,
                ),
                SCSuccessDetail(
                  label: 'Fee',
                  value: '\$${fee.toStringAsFixed(2)}',
                  isMono: true,
                ),
                SCSuccessDetail(
                  label: 'Total',
                  value: '\$${total.toStringAsFixed(2)}',
                  isMono: true,
                ),
              ],
              activityRoute: Routes.transactionLogScreen,
            ),
          );
          update();
        })
        .catchError((onError) {
          log.e(onError);
          update();
        });

    _isConfirmLoading.value = false;
    update();
    return _transferConfirmModel;
  }

  /// Computes the transfer fee for [amount] from
  /// `MoneyTransferInfoController.transferMoneyInfoModel.data.transferMoneyCharge`
  /// (`fixedCharge` + `percentCharge`%). The info model is `late` on its
  /// own controller — wrap in try/catch so a failed /info fetch falls
  /// back to 0 instead of crashing this method.
  double _resolveFee(double amount) {
    try {
      final charge =
          moneyInfoController.transferMoneyInfoModel.data.transferMoneyCharge;
      final fixed = (charge.fixedCharge as num).toDouble();
      final percent = (charge.percentCharge as num).toDouble();
      return fixed + (amount * percent / 100);
    } catch (_) {
      return 0.0;
    }
  }
}
