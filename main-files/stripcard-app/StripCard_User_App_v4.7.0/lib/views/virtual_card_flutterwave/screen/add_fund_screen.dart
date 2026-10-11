import 'dart:math' as math;

import 'package:intl/intl.dart';

import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/views/virtual_card_flutterwave/controller/adfund_controller.dart";
import "package:TAKARA PAY/views/virtual_card_flutterwave/controller/flutter_wave_card_create_controller.dart";
import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_amount_input.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_chip.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_numpad.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_section_header.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_surface_card.dart";

const double _maxAmount = 999999;

class AddFundScreen extends StatefulWidget {
  const AddFundScreen({super.key});

  @override
  State<AddFundScreen> createState() => _AddFundScreenState();
}

class _AddFundScreenState extends State<AddFundScreen> {
  // Preserved controller registrations from AddFundWidget — these own all
  // the API-bound state (amount, charges, limits, navigation).
  late final AddFundController controller;
  late final CreateCardController cardChargesController;
  late final DashBoardController dashBoardController;

  int _shakeGen = 0;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AddFundController());
    cardChargesController = Get.put(CreateCardController());
    dashBoardController = Get.put(DashBoardController());
    controller.amountTextController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    controller.amountTextController.removeListener(_onAmountChanged);
    super.dispose();
  }

  void _onAmountChanged() {
    if (mounted) setState(() {});
  }

  void _shake() {
    if (mounted) setState(() => _shakeGen++);
  }

  // ── Numpad rules — same as Withdraw ───────────────────────────────────
  void _onKey(String key) {
    final current = controller.amountTextController.text;

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
    final current = controller.amountTextController.text;
    if (current.isEmpty) return;
    _setAmount(current.substring(0, current.length - 1));
  }

  void _setAmount(String text) {
    controller.amountTextController.text = text;
    controller.amountTextController.selection =
        TextSelection.collapsed(offset: text.length);
  }

  // ── Submit — preserves the original AddFundWidget proceed handler ──────
  void _onSubmit() {
    if (controller.amountTextController.text.isNotEmpty) {
      Get.toNamed(Routes.addFundPreviewScreen);
    } else {
      CustomSnackBar.error(Strings.plzEnterAmount);
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────
  String get _baseCurr {
    try {
      return cardChargesController.cardChargesModel.data.baseCurr;
    } catch (_) {
      return 'USD';
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
          Strings.fund,
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (cardChargesController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }
          return _buildBody();
        }),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            children: [
              Text(
                Strings.enterAmount,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: 8),
              _ShakeOnChange(
                generation: _shakeGen,
                child: SCAmountInput(
                  controller: controller.amountTextController,
                  currencySymbol: r'$',
                ),
              ),
              const SizedBox(height: 20),
              _buildPresetChips(),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SCSectionHeader(label: 'LIMITS'),
              Obx(() => _buildLimitsCard()),
            ],
          ),
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
          child: _buildSubmitButton(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildPresetChips() {
    final current =
        double.tryParse(controller.amountTextController.text) ?? 0;

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
          label: r'$100',
          selected: current == 100,
          onTap: () => apply(100),
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
      ],
    );
  }

  Widget _buildLimitsCard() {
    final daily = controller.controller.dailyLimit.value;
    final monthly = controller.controller.monthlyLimit.value;
    final baseCurr = _baseCurr;

    return SCSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _LimitRow(
            label: Strings.dailyLimit,
            value: '${_formatAmount(daily)} $baseCurr',
          ),
          const Divider(height: 0.5, thickness: 0.5, color: AppColors.line2),
          _LimitRow(
            label: Strings.monthlyLimit,
            value: '${_formatAmount(monthly)} $baseCurr',
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    final amount =
        double.tryParse(controller.amountTextController.text) ?? 0;
    final label = amount > 0
        ? '${Strings.proceed} \$${_formatAmount(amount)}'
        : Strings.proceed;
    return SCPrimaryButton(
      label: label,
      onPressed: amount > 0 ? _onSubmit : null,
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────

class _LimitRow extends StatelessWidget {
  const _LimitRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: AppTextStyles.numMd.copyWith(color: AppColors.text),
          ),
        ],
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
        final dx = math.sin(value * 2 * math.pi * 4) * 3 * (1 - value);
        return Transform.translate(offset: Offset(dx, 0), child: c);
      },
      child: child,
    );
  }
}
