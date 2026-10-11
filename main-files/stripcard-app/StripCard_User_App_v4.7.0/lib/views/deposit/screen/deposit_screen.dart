import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/views/app_settings/controller/app_settings_controller.dart";
import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/views/deposit/controller/deposit_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_chip.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_section_header.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_text_field.dart";

// Coerce the API's `dynamic` numeric fields (sometimes "5.0000", sometimes a
// num) into a double without throwing.
double _toNum(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

// Trim trailing zeros: 5.0 -> "5", 1.55 -> "1.55", 2.50 -> "2.5".
String _fmtNum(num v) {
  final d = v.toDouble();
  if (d == d.truncateToDouble()) return d.toStringAsFixed(0);
  return d
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

IconData _iconForAlias(String alias) {
  final a = alias.toLowerCase();
  if (a.contains('apple')) return Icons.apple;
  if (a.contains('google')) return Icons.g_mobiledata;
  if (a.contains('paypal')) return Icons.account_balance_wallet_outlined;
  if (a.contains('stripe') ||
      a.contains('razorpay') ||
      a.contains('flutterwave') ||
      a.contains('authorize')) {
    return Icons.credit_card_outlined;
  }
  if (a.contains('bkash') ||
      a.contains('jazzcash') ||
      a.contains('khalti') ||
      a.contains('mobile')) {
    return Icons.smartphone_outlined;
  }
  if (a.contains('bank') || a.contains('ssl') || a.contains('manual')) {
    return Icons.account_balance_outlined;
  }
  return Icons.payments_outlined;
}

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  late final DepositController controller;
  // ignore: unused_field
  late final AppSettingsController appSettingController;
  late final DashBoardController dashBoardController;

  // Bumped to retrigger the shake animation on limit-violation submits.
  int _shakeGen = 0;

  @override
  void initState() {
    super.initState();
    controller = Get.put(DepositController());
    appSettingController = Get.put(AppSettingsController());
    dashBoardController = Get.put(DashBoardController());
    controller.amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    controller.amountController.removeListener(_onAmountChanged);
    super.dispose();
  }

  void _onAmountChanged() {
    if (mounted) setState(() {});
  }

  void _shake() {
    if (mounted) setState(() => _shakeGen++);
  }

  // Source selection — preserves the original 12-field side effects.
  void _selectSource(dynamic currency) {
    controller.selectedCurrencyName.value = currency.name;
    controller.selectedCurrencyAlias.value = currency.alias;
    controller.selectedCurrencyType.value = currency.type.toString();
    controller.code.value = currency.currencyCode;
    controller.crypto.value = int.parse(currency.crypto);
    controller.selectedFee.value = currency.fixedCharge.toDouble();
    controller.supportedRate.value = currency.rate;
    controller.percentCharge.value = currency.percentCharge.toDouble();
    controller.dallyLimit.value = currency.dailyLimit.toDouble();
    controller.monthlyLimit.value = currency.monthlyLimit.toDouble();
    controller.limitMin.value = currency.minLimit.toDouble();
    controller.limitMax.value = currency.maxLimit.toDouble();
    controller.limitCalculation();
    controller.remainingController.getRemainingBalanceProcess();
  }

  // Submit — preserves the original button onPressed body.
  void _onSubmit() {
    final text = controller.amountController.text;
    if (text.isEmpty) {
      CustomSnackBar.error(Strings.pleaseFillTheAmount);
      return;
    }
    controller.amount.value = double.parse(text);
    if (controller.minLimCal.value <= controller.amount.value &&
        controller.maxLimCal.value >= controller.amount.value) {
      if (controller.selectedCurrencyAlias.value.contains('authorize')) {
        controller.authorizeSubmitProcess();
      } else {
        Get.toNamed(Routes.depositPreviewScreen);
      }
    } else {
      CustomSnackBar.error(Strings.pleaseFollowTheLimit);
      _shake();
    }
  }

  // Helpers ─────────────────────────────────────────────────────────────
  double _walletBalance() {
    try {
      final wallets = dashBoardController.dashBoardModel.data.userWallet;
      if (wallets.isEmpty) return 0;
      return wallets.first.balance;
    } catch (_) {
      return 0;
    }
  }

  double get _amount =>
      double.tryParse(controller.amountController.text) ?? 0;

  bool _isPreset(double v) => _amount == v;

  void _setAmount(num value) {
    final text = value % 1 == 0
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
    controller.amountController.text = text;
    controller.amountController.selection =
        TextSelection.collapsed(offset: text.length);
  }

  String _formatAmount(double v) => NumberFormat('#,##0.00').format(v);

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? AppColorsDark.bg : AppColors.bg;
    final text = dark ? AppColorsDark.text : AppColors.text;
    final line2 = dark ? AppColorsDark.line2 : AppColors.line2;

    return Scaffold(
      backgroundColor: bg,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: text),
          onPressed: Get.back,
        ),
        title: Text(
          Get.find<LanguageController>().getTranslation(Strings.addMoney),
          style: AppTextStyles.bodyMed.copyWith(color: text),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: _buildScrollContent(dark),
                ),
              ),
              _buildPinnedFooter(dark, bg, line2),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildScrollContent(bool dark) {
    final balance = _walletBalance();
    final text = dark ? AppColorsDark.text : AppColors.text;
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Get.find<LanguageController>().getTranslation(Strings.amount),
                style: AppTextStyles.caption.copyWith(color: text2),
              ),
              const SizedBox(height: 8),
              _ShakeOnChange(
                generation: _shakeGen,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      r'$',
                      style: AppTextStyles.h2.copyWith(color: text2),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      controller.amountController.text.isEmpty
                          ? '0'
                          : controller.amountController.text,
                      style: AppTextStyles.numDisplay.copyWith(color: text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            '${Get.find<LanguageController>().getTranslation(Strings.availableUsdBalance)} \$${_formatAmount(balance)}',
            style: AppTextStyles.caption.copyWith(color: text3),
          ),
        ),
        const SizedBox(height: 20),
        SCTextField(
          controller: controller.amountController,
          hint: Get.find<LanguageController>()
              .getTranslation(Strings.orEnterCustomAmount),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          // Defence-in-depth: the controller listener (initState) should
          // already trigger a rebuild on text change. This explicit setState
          // guarantees the hero amount + chip-selection state stay in sync.
          onChanged: (_) => setState(() {}),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              r'$',
              style: AppTextStyles.bodyMed.copyWith(color: text2),
            ),
          ),
        ),
        Obx(() => _buildChargeSummary(dark)),
        const SizedBox(height: 32),
        SCSectionHeader(
          label: Get.find<LanguageController>().getTranslation(Strings.from),
        ),
        const SizedBox(height: 4),
        Obx(() => _buildSourceList(dark)),
      ],
    );
  }

  // White-label friendly summary: shows the selected method's charges,
  // per-transaction limit and conversion rate (replaces the quick-amount
  // chips). Hidden until a source is picked.
  Widget _buildChargeSummary(bool dark) {
    if (controller.selectedCurrencyAlias.value.isEmpty) {
      return const SizedBox.shrink();
    }
    final surface = dark ? AppColorsDark.surface : AppColors.surface;
    final line2 = dark ? AppColorsDark.line2 : AppColors.line2;
    final text = dark ? AppColorsDark.text : AppColors.text;
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;

    final code = controller.code.value;
    final base = controller.baseCurrency.value.isEmpty
        ? 'USD'
        : controller.baseCurrency.value;
    final fee = controller.selectedFee.value;
    final percent = controller.percentCharge.value;
    final rate = controller.supportedRate.value;

    final chargeText = (fee == 0 && percent == 0)
        ? Get.find<LanguageController>().getTranslation(Strings.noCharge)
        : '${_fmtNum(fee)} $code + ${_fmtNum(percent)}%';
    final limitText =
        '${_fmtNum(controller.minLimCal.value)} - ${_fmtNum(controller.maxLimCal.value)} $base';

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: line2, width: 1),
        ),
        child: Column(
          children: [
            _summaryRow(
              Get.find<LanguageController>().getTranslation(Strings.charge),
              chargeText,
              text2,
              text,
            ),
            const SizedBox(height: 10),
            _summaryRow(
              Get.find<LanguageController>()
                  .getTranslation(Strings.transactionLimit),
              limitText,
              text2,
              text,
            ),
            if (code != base && rate > 0) ...[
              const SizedBox(height: 10),
              _summaryRow(
                Get.find<LanguageController>()
                    .getTranslation(Strings.exchangeRate),
                '1 $base = ${_fmtNum(rate)} $code',
                text2,
                text,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color labelColor, Color valueColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: labelColor),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyMed.copyWith(color: valueColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSourceList(bool dark) {
    final sources = controller.currencyList;
    if (sources.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          Get.find<LanguageController>()
              .getTranslation(Strings.noPaymentMethodsAvailable),
          style: AppTextStyles.caption.copyWith(
            color: dark ? AppColorsDark.text2 : AppColors.text2,
          ),
        ),
      );
    }

    final selectedAlias = controller.selectedCurrencyAlias.value;

    return Column(
      children: [
        for (final source in sources)
          _SourceRow(
            source: source,
            selected: source.alias == selectedAlias,
            onTap: () => _selectSource(source),
          ),
      ],
    );
  }

  // Context-aware label — tells the user *why* the button is disabled
  // instead of leaving them to guess.
  String _buttonLabel() {
    final amt = _amount;
    if (amt <= 0) {
      return Get.find<LanguageController>()
          .getTranslation(Strings.enterAnAmount);
    }
    if (controller.selectedCurrencyAlias.value.isEmpty) {
      return Get.find<LanguageController>()
          .getTranslation(Strings.chooseASource);
    }
    return '${Get.find<LanguageController>().getTranslation(Strings.add)} \$${_formatAmount(amt)}';
  }

  bool _canSubmit() =>
      _amount > 0 && controller.selectedCurrencyAlias.value.isNotEmpty;

  Widget _buildPinnedFooter(bool dark, Color bg, Color line2) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomInset),
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          top: BorderSide(color: line2, width: 1),
        ),
      ),
      child: Obx(
        () => SCPrimaryButton(
          label: _buttonLabel(),
          loading: controller.isLoading,
          onPressed: _canSubmit() ? _onSubmit : null,
        ),
      ),
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────

class _SourceRow extends StatelessWidget {
  const _SourceRow({
    required this.source,
    required this.selected,
    required this.onTap,
  });

  final dynamic source;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark ? AppColorsDark.accent : AppColors.accent;
    final accentInk = dark ? AppColorsDark.accentInk : AppColors.accentInk;
    final surface = dark ? AppColorsDark.surface : AppColors.surface;
    final surface2 = dark ? AppColorsDark.surface2 : AppColors.surface2;
    final line2 = dark ? AppColorsDark.line2 : AppColors.line2;
    final text = dark ? AppColorsDark.text : AppColors.text;
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;

    final alias = source.alias.toString();
    final name = source.name.toString();
    final code = source.currencyCode.toString();
    // Fee shown with its currency code AND the percent component, e.g.
    // "Fee 5 AUD + 1%" — far clearer than the old bare "Fee 5".
    final fixed = _fmtNum(_toNum(source.fixedCharge));
    final percent = _fmtNum(_toNum(source.percentCharge));
    final feeText =
        '${Get.find<LanguageController>().getTranslation(Strings.fee)} $fixed $code + $percent%';
    final radius = BorderRadius.circular(AppRadius.lg);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: radius,
              border: Border.all(
                color: selected ? accent : line2,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: surface2,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    _iconForAlias(alias),
                    size: 20,
                    color: text,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.bodyMed.copyWith(color: text),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$code · ${Get.find<LanguageController>().getTranslation(Strings.instant)}',
                        style: AppTextStyles.caption.copyWith(color: text3),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        feeText,
                        style: AppTextStyles.caption.copyWith(color: text3),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? accent : Colors.transparent,
                    border: selected
                        ? null
                        : Border.all(color: text3, width: 1.5),
                  ),
                  child: selected
                      ? Icon(Icons.check, size: 14, color: accentInk)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShakeOnChange extends StatelessWidget {
  const _ShakeOnChange({required this.generation, required this.child});

  final int generation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(generation),
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 250),
      builder: (_, value, c) {
        // 4 oscillations, 3px amplitude, decaying linearly.
        final dx = math.sin(value * 2 * math.pi * 4) * 3 * (1 - value);
        return Transform.translate(offset: Offset(dx, 0), child: c);
      },
      child: child,
    );
  }
}
