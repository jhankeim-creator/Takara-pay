import 'package:flutter/services.dart';
import "package:TAKARA PAY/base/widgets/others/date_picker.dart";
import "package:TAKARA PAY/base/widgets/supported_currency_widget.dart";
import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/views/virtual_card_sudo/controller/create_card/sudo_create_card_controller.dart";
import "package:TAKARA PAY/views/virtual_card_sudo/controller/sudo_my_card_controller.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_chip.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_surface_card.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_text_field.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_virtual_card.dart";
import "package:TAKARA PAY/base/widgets/identity_type_dropdown.dart";

/// Body of the Sudo "create new card" flow.
///
/// This widget owns ALL of the controller logic (text controllers, dropdowns,
/// onChanged handlers, limits, and the submit handler). The screen
/// (`SudoCreateNewScreen`) pins the CTA footer at the bottom and calls
/// [submit] — the original button behaviour is preserved verbatim inside it.
class SudoCreateCardWidget extends StatefulWidget {
  SudoCreateCardWidget({
    Key? key,
    required this.buttonText,
  }) : super(key: key);

  final String buttonText;

  // Preserved controller registrations — these own the API-bound state.
  final controller = Get.put(SudoCreateCardController());
  final sudoCardController = Get.put(VirtualSudoCardController());

  /// Submit — preserves the original button onPressed body verbatim.
  void submit(BuildContext context) {
    if (controller.amountTextController.text.isNotEmpty) {
      sudoCardController.calculation();
      controller.goToCreateNewCardPreviewScreen();
    } else {
      CustomSnackBar.error(Strings.plzEnterAmount);
    }
  }

  @override
  State<SudoCreateCardWidget> createState() => _SudoCreateCardWidgetState();
}

class _SudoCreateCardWidgetState extends State<SudoCreateCardWidget> {
  final createCardKey = GlobalKey<FormState>();

  SudoCreateCardController get controller => widget.controller;
  VirtualSudoCardController get sudoCardController => widget.sudoCardController;

  @override
  void initState() {
    super.initState();
    controller.amountTextController.addListener(_rebuild);
    controller.selectedDateOfBirth.listen((_) => _rebuild());
  }

  @override
  void dispose() {
    controller.amountTextController.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  // Translate a Strings key through the app's LanguageController (the app
  // does NOT use GetX `.tr`; keys are resolved here and fall back to the key).
  String _t(String key) => Get.find<LanguageController>().getTranslation(key);

  // ─── Live-preview helpers ───────────────────────────────────────────
  String get _currencyCode {
    final code = sudoCardController.selectedSupportedCurrencyCode.value;
    if (code.isNotEmpty) return code;
    final base = sudoCardController.baseCurrency.value;
    return base.isEmpty ? 'USD' : base;
  }

  String get _previewBalance {
    final raw = controller.amountTextController.text.trim();
    final amount = double.tryParse(raw) ?? 0;
    return '$_currencyCode ${amount.toStringAsFixed(2)}';
  }

  double get _availableBalance {
    try {
      final wallets =
          sudoCardController.dashboardController.dashBoardModel.data.userWallet;
      if (wallets.isEmpty) return 0;
      return wallets.first.balance;
    } catch (_) {
      return 0;
    }
  }

  bool _isAmountPreset(double v) =>
      (double.tryParse(controller.amountTextController.text) ?? -1) == v;

  void _setAmount(double v) {
    final text = v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
    controller.amountTextController.text = text;
    controller.amountTextController.selection =
        TextSelection.collapsed(offset: text.length);
  }

  @override
  Widget build(BuildContext context) {
    // Preserved: seed the remaining-limit observables from the controller.
    sudoCardController.getRemainingMonthlyLimit.value =
        sudoCardController.remainingController.remainingMonthLyLimit.value;
    sudoCardController.getRemainingDailyLimit.value =
        sudoCardController.remainingController.remainingDailyLimit.value;

    final dark = Theme.of(context).brightness == Brightness.dark;
    final text = dark ? AppColorsDark.text : AppColors.text;
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;

    return Form(
      key: createCardKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Intro headline + subtitle.
          Text(
            _t(Strings.createANewCard),
            style: AppTextStyles.h1.copyWith(color: text),
          ),
          const SizedBox(height: 8),
          Text(
            'Set the amount and details, then review before you create.',
            style: AppTextStyles.body.copyWith(color: text2),
          ),
          const SizedBox(height: 24),

          // Live preview hero — reflects the entered amount + currency.
          Obx(
            () => SCVirtualCard(
              cardName: _t(Strings.createANewCard),
              last4: '••••',
              balance: _previewBalance,
              expiry: '••/••',
            ),
          ),
          const SizedBox(height: 28),

          // Form fields — branch preserved exactly from the original.
          if (sudoCardController.isExtraField == true) ...[
            _firstTimeCreate(dark),
          ] else ...[
            _inputFieldWidget(context, dark),
          ],

          const SizedBox(height: 20),
          _limitInfoShow(),
        ],
      ),
    );
  }

  // ─── Limits card (preserved data bindings) ──────────────────────────
  Widget _limitInfoShow() {
    final precision =
        controller.remainingController.dashboardController.precision.value;
    final code = controller.sudoCardController.selectedSupportedCurrencyCode;

    Widget row(String label, String value, {bool divider = true}) {
      final dark = Theme.of(context).brightness == Brightness.dark;
      final line2 = dark ? AppColorsDark.line2 : AppColors.line2;
      final text = dark ? AppColorsDark.text : AppColors.text;
      final text2 = dark ? AppColorsDark.text2 : AppColors.text2;
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: AppTextStyles.body.copyWith(color: text2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  value,
                  style: AppTextStyles.numMd.copyWith(color: text),
                ),
              ],
            ),
          ),
          if (divider) Divider(height: 1, thickness: 0.5, color: line2),
        ],
      );
    }

    final dark = Theme.of(context).brightness == Brightness.dark;
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;

    return Obx(
      () => SCSurfaceCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LIMITS FROM YOUR TIER',
              style: AppTextStyles.micro.copyWith(color: text3),
            ),
            const SizedBox(height: 12),
            row(
              _t(Strings.amount),
              '${controller.sudoCardController.limitMin.toStringAsFixed(precision)} ${code.value} - ${controller.sudoCardController.limitMax.toStringAsFixed(precision)} ${code.value}',
            ),
            row(
              'Daily limit',
              '${controller.sudoCardController.dailyLimit.value.toStringAsFixed(precision)} ${code.value}',
            ),
            row(
              'Remaining daily',
              '${sudoCardController.getRemainingDailyLimit.value.toStringAsFixed(precision)} ${code.value}',
            ),
            row(
              'Monthly limit',
              '${controller.sudoCardController.monthlyLimit.value.toStringAsFixed(precision)} ${code.value}',
            ),
            row(
              'Remaining monthly',
              '${sudoCardController.getRemainingMonthlyLimit.value.toStringAsFixed(precision)} ${code.value}',
              divider: false,
            ),
          ],
        ),
      ),
    );
  }

  // ─── KYC / first-time create branch (preserved fields + handlers) ───
  Widget _firstTimeCreate(bool dark) {
    var data =
        controller.sudoCardController.dashboardController.dashBoardModel.data;
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;

    return SCSurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _amountField(dark),
          const SizedBox(height: 16),
          _amountChips(dark),
          const SizedBox(height: 20),
          _fieldLabel(_t(Strings.dateOfBirth), text3),
          const SizedBox(height: 7),
          CustomDatePicker(
            selectedDate: controller.selectedDateOfBirth,
            showBorder: true,
          ),
          const SizedBox(height: 16),
          _fieldLabel(_t(Strings.currency), text3),
          const SizedBox(height: 7),
          SupportedCurrencyWidget(
            itemsList: sudoCardController.supportedCurrencyList,
            selectMethod: sudoCardController.selectedSupportedCurrencyCode,
            onChanged: (type) {
              sudoCardController.selectedSupportedCurrencyName.value =
                  type!.currencyName;
              sudoCardController.selectedSupportedCurrencyCode.value =
                  type.currencyCode;
              sudoCardController.selectedSupportedCurrencyRate.value =
                  type.rate.toString();
              sudoCardController.updateLimits();
              _rebuild();
            },
          ),
          const SizedBox(height: 16),
          _fieldLabel(_t(Strings.identityType), text3),
          const SizedBox(height: 7),
          IdentityTypeDropDown(
            itemsList: sudoCardController.identityTypeList,
            selectMethod: sudoCardController.selectedIdentityType,
            onChanged: (option) {
              sudoCardController.selectedIdentityType.value = option!.name;
              sudoCardController.selectedIdentityTypeCode.value = option.value;
              print(sudoCardController.selectedIdentityTypeCode.value);
            },
          ),
          const SizedBox(height: 16),
          SCTextField(
            controller: controller.NumberTextController,
            hint: _t(Strings.number),
            label: _t(Strings.number),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          SCTextField(
            controller: controller.IdentityTextController,
            hint: _t(Strings.identity),
            label: _t(Strings.identity),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _fieldLabel(_t(Strings.fromWallet), text3),
          const SizedBox(height: 7),
          SupportedCurrencyWidget(
            itemsList: RxList(),
            selectMethod: RxString(
                (sudoCardController.supportedCurrencyList.isNotEmpty &&
                        data.userWallet.isNotEmpty)
                    ? '${sudoCardController.supportedCurrencyList.first.currencyName} (${data.userWallet[0].balance.toString()} ${data.userWallet[0].currency.code})'
                    : ''),
            onChanged: (type) {
              sudoCardController.selectedSupportedCurrencyName.value =
                  type!.currencyName;
              sudoCardController.selectedSupportedCurrencyCode.value =
                  type.currencyCode;
            },
          ),
        ],
      ),
    );
  }

  // ─── Standard create branch (preserved fields + handlers) ───────────
  Widget _inputFieldWidget(BuildContext context, bool dark) {
    var data =
        controller.sudoCardController.dashboardController.dashBoardModel.data;
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;

    return SCSurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _amountField(dark),
          const SizedBox(height: 16),
          _amountChips(dark),
          const SizedBox(height: 20),
          _fieldLabel(_t(Strings.currency), text3),
          const SizedBox(height: 7),
          SupportedCurrencyWidget(
            itemsList: sudoCardController.supportedCurrencyList,
            selectMethod: sudoCardController.selectedSupportedCurrencyCode,
            onChanged: (type) {
              sudoCardController.selectedSupportedCurrencyName.value =
                  type!.currencyName;
              sudoCardController.selectedSupportedCurrencyCode.value =
                  type.currencyCode;
              print(sudoCardController.selectedSupportedCurrencyCode.value);
              _rebuild();
            },
          ),
          const SizedBox(height: 16),
          _fieldLabel(_t(Strings.fromWallet), text3),
          const SizedBox(height: 7),
          SupportedCurrencyWidget(
            itemsList: RxList(),
            selectMethod: RxString(
                (sudoCardController.supportedCurrencyList.isNotEmpty &&
                        data.userWallet.isNotEmpty)
                    ? '${sudoCardController.supportedCurrencyList.first.currencyName} (${data.userWallet[0].balance.toString()} ${data.userWallet[0].currency.code})'
                    : ''),
            onChanged: (type) {
              sudoCardController.selectedSupportedCurrencyName.value =
                  type!.currencyName;
              sudoCardController.selectedSupportedCurrencyCode.value =
                  type.currencyCode;
              print(sudoCardController.selectedSupportedCurrencyCode.value);
            },
          ),
        ],
      ),
    );
  }

  // ─── Shared field bits ──────────────────────────────────────────────
  Widget _amountField(bool dark) {
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;
    return SCTextField(
      controller: controller.amountTextController,
      label: _t(Strings.cardAmount),
      hint: _t(Strings.amount),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          _currencyCode,
          style: AppTextStyles.caption.copyWith(color: text2),
        ),
      ),
    );
  }

  Widget _amountChips(bool dark) {
    final available = _availableBalance;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SCChip(
          label: '50',
          selected: _isAmountPreset(50),
          onTap: () => _setAmount(50),
        ),
        SCChip(
          label: '100',
          selected: _isAmountPreset(100),
          onTap: () => _setAmount(100),
        ),
        SCChip(
          label: '500',
          selected: _isAmountPreset(500),
          onTap: () => _setAmount(500),
        ),
        if (available > 0)
          SCChip(
            label: 'Max',
            selected: _isAmountPreset(available),
            onTap: () => _setAmount(available),
          ),
      ],
    );
  }

  Widget _fieldLabel(String text, Color color) {
    return Text(
      text,
      style: AppTextStyles.label.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
