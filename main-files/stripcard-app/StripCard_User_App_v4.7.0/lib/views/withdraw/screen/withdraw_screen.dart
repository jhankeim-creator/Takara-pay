import 'dart:math' as math;

import 'package:intl/intl.dart';

import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/views/navbar/controller/dashboard_controller.dart";
import "package:stripcard/views/withdraw/controller/withdraw_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/widgets/design_system/sc_amount_input.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_chip.dart";
import "package:stripcard/base/widgets/design_system/sc_numpad.dart";
import "package:stripcard/base/widgets/design_system/sc_section_header.dart";
import "package:stripcard/base/widgets/design_system/sc_shimmer.dart";
import "package:stripcard/base/widgets/design_system/sc_surface_card.dart";

const double _maxAmount = 1000000;

IconData _iconForAlias(String alias) {
  final a = alias.toLowerCase();
  if (a.contains('apple')) return Icons.apple;
  if (a.contains('bank') ||
      a.contains('ssl') ||
      a.contains('bkash') ||
      a.contains('manual')) {
    return Icons.account_balance_outlined;
  }
  if (a.contains('stripe') ||
      a.contains('paypal') ||
      a.contains('razorpay') ||
      a.contains('flutterwave') ||
      a.contains('authorize')) {
    return Icons.credit_card_outlined;
  }
  return Icons.payments_outlined;
}

class MoneyOutScreen extends StatefulWidget {
  const MoneyOutScreen({super.key});

  @override
  State<MoneyOutScreen> createState() => _MoneyOutScreenState();
}

class _MoneyOutScreenState extends State<MoneyOutScreen> {
  late final MoneyOutController controller;
  late final DashBoardController dashBoardController;

  int _shakeGen = 0;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MoneyOutController());
    dashBoardController = Get.put(DashBoardController());
    controller.moneyOutAmountTextController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    controller.moneyOutAmountTextController.removeListener(_onAmountChanged);
    super.dispose();
  }

  void _onAmountChanged() {
    if (mounted) setState(() {});
  }

  void _shake() {
    if (mounted) setState(() => _shakeGen++);
  }

  // ── Numpad rules — same as Add money ──────────────────────────────────
  void _onKey(String key) {
    final current = controller.moneyOutAmountTextController.text;

    if (key == '.') {
      if (current.contains('.') || current.isEmpty) {
        _shake();
        return;
      }
      _setAmount('$current.');
      return;
    }

    if (current.contains('.')) {
      final parts = current.split('.');
      if (parts.length == 2 && parts[1].length >= 2) {
        _shake();
        return;
      }
    }

    String next = current.isEmpty ? key : '$current$key';
    if (next.startsWith('00')) next = next.substring(1);

    final asDouble = double.tryParse(next);
    if (asDouble != null && asDouble > _maxAmount) {
      _shake();
      return;
    }

    _setAmount(next);
  }

  void _onBackspace() {
    final current = controller.moneyOutAmountTextController.text;
    if (current.isEmpty) return;
    _setAmount(current.substring(0, current.length - 1));
  }

  void _setAmount(String text) {
    controller.moneyOutAmountTextController.text = text;
    controller.moneyOutAmountTextController.selection =
        TextSelection.collapsed(offset: text.length);
  }

  // ── Destination — preserves the original simple onChanged body ────────
  void _selectDestination(dynamic currency) {
    controller.selectedCurrencyName.value = currency.name;
    controller.selectedCurrencyAlias.value = currency.alias;
  }

  // ── Submit — preserves the original handler ───────────────────────────
  void _onSubmit() {
    final amount =
        double.tryParse(controller.moneyOutAmountTextController.text) ?? 0;
    final balance = _walletBalance();
    if (amount > balance) {
      _shake();
      CustomSnackBar.error(Strings.amountExceedsAvailableBalance);
      return;
    }
    controller.manualPaymentGetGatewaysProcess();
  }

  // ── Helpers ───────────────────────────────────────────────────────────
  double _walletBalance() {
    try {
      final wallets = dashBoardController.dashBoardModel.data.userWallet;
      if (wallets.isEmpty) return 0;
      return wallets.first.balance;
    } catch (_) {
      return 0;
    }
  }

  String _walletSymbol() {
    try {
      final wallets = dashBoardController.dashBoardModel.data.userWallet;
      if (wallets.isEmpty) return r'$';
      return wallets.first.currency.symbol;
    } catch (_) {
      return r'$';
    }
  }

  String _formatAmount(double v) => NumberFormat('#,##0.00').format(v);

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
          Get.find<LanguageController>().getTranslation(Strings.withdraw),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading) {
            return const SCListSkeleton();
          }
          return _buildBody();
        }),
      ),
    );
  }

  Widget _buildBody() {
    final balance = _walletBalance();
    final symbol = _walletSymbol();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            children: [
              Text(
                Get.find<LanguageController>().getTranslation(Strings.withdraw),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                ),
              ),
              const SizedBox(height: 8),
              _ShakeOnChange(
                generation: _shakeGen,
                child: SCAmountInput(
                  controller: controller.moneyOutAmountTextController,
                  currencySymbol: r'$',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Get.find<LanguageController>()
                        .getTranslation(Strings.available),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                  Text(
                    '$symbol${_formatAmount(balance)}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildPresetChips(balance),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SCSectionHeader(
            label: Get.find<LanguageController>().getTranslation(Strings.toLabel),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() => _buildDestinationList()),
        ),
        const Spacer(),
        Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              top: BorderSide(color: AppColors.line, width: 0.5),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SCNumpad(onKey: _onKey, onBackspace: _onBackspace),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Obx(() => _buildSubmitButton()),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildPresetChips(double balance) {
    final current =
        double.tryParse(controller.moneyOutAmountTextController.text) ?? 0;

    void apply(double value) {
      _setAmount(NumberFormat('#0.##').format(value));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SCChip(
          label: r'$50',
          selected: current == 50,
          onTap: () => apply(50),
        ),
        const SizedBox(width: 8),
        SCChip(
          label: r'$200',
          selected: current == 200,
          onTap: () => apply(200),
        ),
        const SizedBox(width: 8),
        SCChip(
          label: r'$500',
          selected: current == 500,
          onTap: () => apply(500),
        ),
        const SizedBox(width: 8),
        SCChip(
          label: Get.find<LanguageController>().getTranslation(Strings.all),
          selected: balance > 0 && current == balance,
          onTap: () => apply(balance),
        ),
      ],
    );
  }

  Widget _buildDestinationList() {
    final destinations = controller.allCurrencyList;
    final selectedAlias = controller.selectedCurrencyAlias.value;

    return Column(
      children: [
        for (int i = 0; i < destinations.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _DestinationRow(
            currency: destinations[i],
            selected: destinations[i].alias == selectedAlias,
            onTap: () => _selectDestination(destinations[i]),
          ),
        ],
        if (destinations.isNotEmpty) const SizedBox(height: 10),
        SCSurfaceCard(
          padding: const EdgeInsets.all(14),
          onTap: () => Get.toNamed(Routes.moneyOutManualPaymentScreen),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.add,
                  size: 20,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Get.find<LanguageController>()
                          .getTranslation(Strings.externalAccount),
                      style: AppTextStyles.bodyMed.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Get.find<LanguageController>().getTranslation(
                          Strings.addANewBankOrWireDestination),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.text3,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final amount =
        double.tryParse(controller.moneyOutAmountTextController.text) ?? 0;
    final hasDest = controller.selectedCurrencyAlias.value.isNotEmpty;
    final canTap = amount > 0 && hasDest;
    final withdrawText =
        Get.find<LanguageController>().getTranslation(Strings.withdraw);
    final label = amount > 0
        ? '$withdrawText \$${_formatAmount(amount)}'
        : withdrawText;
    return SCPrimaryButton(
      label: label,
      loading: controller.isInsertLoading,
      // Note: the over-balance check happens inside _onSubmit so the user
      // gets the shake/snackbar feedback rather than a silently-disabled
      // button when they hit the wall.
      onPressed: canTap ? _onSubmit : null,
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────

class _DestinationRow extends StatelessWidget {
  const _DestinationRow({
    required this.currency,
    required this.selected,
    required this.onTap,
  });

  final dynamic currency;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final alias = currency.alias.toString();
    final code = currency.currencyCode.toString();
    final fee = currency.fixedCharge.toString();
    final radius = BorderRadius.circular(AppRadius.lg);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: radius,
        border: Border.all(
          color: selected ? AppColors.accent : AppColors.line,
          width: selected ? 1.5 : 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(
                      _iconForAlias(alias),
                      size: 20,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currency.name.toString(),
                          style: AppTextStyles.bodyMed.copyWith(
                            color: AppColors.text,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$code · Instant · Fee $fee',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _RadioIndicator(selected: selected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  const _RadioIndicator({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.accent : Colors.transparent,
        shape: BoxShape.circle,
        border: selected
            ? null
            : Border.all(color: AppColors.text3, width: 1.5),
      ),
      child: selected
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
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
        final dx = math.sin(value * 2 * math.pi * 4) * 3 * (1 - value);
        return Transform.translate(offset: Offset(dx, 0), child: c);
      },
      child: child,
    );
  }
}
