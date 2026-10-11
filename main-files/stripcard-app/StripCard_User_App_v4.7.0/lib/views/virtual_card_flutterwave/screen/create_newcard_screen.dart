import 'package:flutter/services.dart';

import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/views/virtual_card_flutterwave/controller/flutter_wave_card_create_controller.dart";
import "package:TAKARA PAY/views/virtual_card_flutterwave/controller/flutterwave_card_controller.dart";
import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/views/remaining_balance/controller/remaing_balance_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_chip.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_surface_card.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_text_field.dart";

class CreateNewScreen extends StatefulWidget {
  const CreateNewScreen({super.key});

  @override
  State<CreateNewScreen> createState() => _CreateNewScreenState();
}

class _CreateNewScreenState extends State<CreateNewScreen> {
  // Preserved controller registrations from the original widgets — these
  // own all the API-bound state (amount, limits, currency, submit handler).
  late final FlutterWaveCardController controller;
  late final CreateCardController cardChargeController;
  late final RemainingBalanceController remainingController;
  late final DashBoardController dashboardController;

  // New screen-local state — neither the API nor any controller exposes
  // these fields, so they live in the screen until the backend supports
  // named/typed cards.
  final _cardNameController = TextEditingController();
  String _selectedType = 'multi'; // 'multi' | 'single'
  int _step = 0;

  @override
  void initState() {
    super.initState();
    controller = Get.put(FlutterWaveCardController());
    cardChargeController = Get.put(CreateCardController());
    remainingController = Get.put(RemainingBalanceController());
    dashboardController = Get.put(DashBoardController());
    _cardNameController.addListener(_rebuild);
    controller.cardAmountTextController.addListener(_rebuild);
  }

  @override
  void dispose() {
    _cardNameController.removeListener(_rebuild);
    controller.cardAmountTextController.removeListener(_rebuild);
    _cardNameController.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  // Submit — preserves the original button onPressed body verbatim.
  void _onCreate() {
    if (controller.cardAmountTextController.text.isNotEmpty) {
      cardChargeController.goToCreateNewCardPreviewScreen();
    } else {
      CustomSnackBar.error(Strings.plzEnterAmount);
    }
  }

  // Helpers
  double get _availableBalance {
    try {
      final wallets = dashboardController.dashBoardModel.data.userWallet;
      if (wallets.isEmpty) return 0;
      return wallets.first.balance;
    } catch (_) {
      return 0;
    }
  }

  double get _amount =>
      double.tryParse(controller.cardAmountTextController.text) ?? 0;

  bool _isAmountPreset(double v) => _amount == v;

  void _setAmount(double v) {
    final text = v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
    controller.cardAmountTextController.text = text;
    controller.cardAmountTextController.selection =
        TextSelection.collapsed(offset: text.length);
  }

  String get _currencyCode {
    final code = controller.selectedSupportedCurrencyCode.value;
    return code.isEmpty ? 'USD' : code;
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? AppColorsDark.bg : AppColors.bg;
    final text = dark ? AppColorsDark.text : AppColors.text;
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: text),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step--);
            } else {
              Get.back();
            }
          },
        ),
        title: Text(
          'Step ${_step + 1} of 3',
          style: AppTextStyles.caption.copyWith(color: text2),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close_rounded, color: text),
            onPressed: Get.back,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStepIndicator(dark),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _buildStep(dark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(bool dark) {
    final accent = dark ? AppColorsDark.accent : AppColors.accent;
    final line = dark ? AppColorsDark.line : AppColors.line;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          for (int i = 0; i < 3; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 3,
                decoration: BoxDecoration(
                  color: i <= _step ? accent : line,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStep(bool dark) {
    switch (_step) {
      case 0:
        return _buildStepZero(key: const ValueKey('step-0'), dark: dark);
      case 1:
        return _buildStepOne(key: const ValueKey('step-1'), dark: dark);
      default:
        return _buildStepTwo(key: const ValueKey('step-2'), dark: dark);
    }
  }

  // ─── STEP 0 — Purpose & Name ─────────────────────────────────────────
  Widget _buildStepZero({Key? key, required bool dark}) {
    final text = dark ? AppColorsDark.text : AppColors.text;
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;

    return Column(
      key: key,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Get.find<LanguageController>()
                      .getTranslation(Strings.whatsItFor),
                  style: AppTextStyles.h1.copyWith(color: text),
                ),
                const SizedBox(height: 8),
                Text(
                  Get.find<LanguageController>()
                      .getTranslation(Strings.nameAndPickCardType),
                  style: AppTextStyles.body.copyWith(color: text2),
                ),
                const SizedBox(height: 32),
                SCTextField(
                  label: Get.find<LanguageController>()
                      .getTranslation(Strings.cardNameLabel),
                  hint: Get.find<LanguageController>()
                      .getTranslation(Strings.egSubscriptions),
                  controller: _cardNameController,
                ),
                const SizedBox(height: 24),
                Text(
                  Get.find<LanguageController>()
                      .getTranslation(Strings.typeLabel)
                      .toUpperCase(),
                  style: AppTextStyles.micro.copyWith(color: text3),
                ),
                const SizedBox(height: 12),
                _TypeTile(
                  selected: _selectedType == 'multi',
                  icon: Icons.credit_card_outlined,
                  title: Get.find<LanguageController>()
                      .getTranslation(Strings.multiUse),
                  subtitle: Get.find<LanguageController>()
                      .getTranslation(Strings.multiUseDescription),
                  onTap: () => setState(() => _selectedType = 'multi'),
                ),
                const SizedBox(height: 12),
                _TypeTile(
                  selected: _selectedType == 'single',
                  icon: Icons.auto_awesome_outlined,
                  title: Get.find<LanguageController>()
                      .getTranslation(Strings.singleUse),
                  subtitle: Get.find<LanguageController>()
                      .getTranslation(Strings.singleUseDescription),
                  onTap: () => setState(() => _selectedType = 'single'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        _PinnedFooter(
          dark: dark,
          child: SCPrimaryButton(
            label: Get.find<LanguageController>()
                .getTranslation(Strings.continueLabel),
            icon: Icons.arrow_forward_rounded,
            onPressed: _cardNameController.text.trim().isEmpty
                ? null
                : () => setState(() => _step = 1),
          ),
        ),
      ],
    );
  }

  // ─── STEP 1 — Amount + Currency + Limits ─────────────────────────────
  Widget _buildStepOne({Key? key, required bool dark}) {
    final text = dark ? AppColorsDark.text : AppColors.text;
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;

    return Column(
      key: key,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Get.find<LanguageController>()
                      .getTranslation(Strings.howMuchToLoad),
                  style: AppTextStyles.h1.copyWith(color: text),
                ),
                const SizedBox(height: 8),
                Text(
                  Get.find<LanguageController>()
                      .getTranslation(Strings.setCardInitialBalanceAndLimits),
                  style: AppTextStyles.body.copyWith(color: text2),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Get.find<LanguageController>()
                            .getTranslation(Strings.amount),
                        style:
                            AppTextStyles.caption.copyWith(color: text2),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            r'$',
                            style:
                                AppTextStyles.h2.copyWith(color: text2),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            controller.cardAmountTextController.text.isEmpty
                                ? '0'
                                : controller.cardAmountTextController.text,
                            style: AppTextStyles.numDisplay.copyWith(
                              color: text,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    '${Get.find<LanguageController>().getTranslation(Strings.availableUsdBalance)} \$${_availableBalance.toStringAsFixed(2)}',
                    style: AppTextStyles.caption.copyWith(color: text3),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      SCChip(
                        label: r'$50',
                        selected: _isAmountPreset(50),
                        onTap: () => _setAmount(50),
                      ),
                      SCChip(
                        label: r'$100',
                        selected: _isAmountPreset(100),
                        onTap: () => _setAmount(100),
                      ),
                      SCChip(
                        label: r'$500',
                        selected: _isAmountPreset(500),
                        onTap: () => _setAmount(500),
                      ),
                      SCChip(
                        label: Get.find<LanguageController>()
                            .getTranslation(Strings.maxLabel),
                        selected: _availableBalance > 0 &&
                            _isAmountPreset(_availableBalance),
                        onTap: () => _setAmount(_availableBalance),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Obx(() => _buildLimitsCard(dark)),
                const SizedBox(height: 12),
                Obx(() => _buildChargesUnavailable(dark)),
                const SizedBox(height: 16),
                SCTextField(
                  controller: controller.cardAmountTextController,
                  label: Get.find<LanguageController>()
                      .getTranslation(Strings.orEnterCustomAmount),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      r'$',
                      style:
                          AppTextStyles.bodyMed.copyWith(color: text2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        _PinnedFooter(
          dark: dark,
          child: Row(
            children: [
              Expanded(
                child: SCSecondaryButton(
                  label: Get.find<LanguageController>()
                      .getTranslation(Strings.backButtonLabel),
                  onPressed: () => setState(() => _step = 0),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SCPrimaryButton(
                  label: Get.find<LanguageController>()
                      .getTranslation(Strings.continueLabel),
                  icon: Icons.arrow_forward_rounded,
                  onPressed: _amount > 0
                      ? () => setState(() => _step = 2)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Inline warning surfaced when /api/user/my-card/charges fails.
  Widget _buildChargesUnavailable(bool dark) {
    if (!cardChargeController.chargesUnavailable.value) {
      return const SizedBox.shrink();
    }
    final warn = dark ? AppColorsDark.warn : AppColors.warn;
    final warnSoft = dark ? AppColorsDark.warnSoft : AppColors.warnSoft;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: warnSoft,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 16, color: warn),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              Get.find<LanguageController>()
                  .getTranslation(Strings.tierLimitsUnavailable),
              style: AppTextStyles.caption.copyWith(color: warn),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitsCard(bool dark) {
    final daily = controller.dailyLimit.value;
    final monthly = controller.monthlyLimit.value;
    final minTxn = controller.limitMin.value;
    final maxTxn = controller.limitMax.value;
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;
    final line2 = dark ? AppColorsDark.line2 : AppColors.line2;

    return SCSurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Get.find<LanguageController>()
                .getTranslation(Strings.limitsFromYourTier)
                .toUpperCase(),
            style: AppTextStyles.micro.copyWith(color: text3),
          ),
          const SizedBox(height: 12),
          _LimitRow(
            label: Get.find<LanguageController>()
                .getTranslation(Strings.dailyLimit),
            value: '\$${daily.toStringAsFixed(0)}',
          ),
          Divider(height: 1, thickness: 0.5, color: line2),
          _LimitRow(
            label: Get.find<LanguageController>()
                .getTranslation(Strings.monthlyLimit),
            value: '\$${monthly.toStringAsFixed(0)}',
          ),
          Divider(height: 1, thickness: 0.5, color: line2),
          _LimitRow(
            label: Get.find<LanguageController>()
                .getTranslation(Strings.perTransaction),
            value:
                '\$${minTxn.toStringAsFixed(0)} – \$${maxTxn.toStringAsFixed(0)}',
          ),
        ],
      ),
    );
  }

  // ─── STEP 2 — Review ─────────────────────────────────────────────────
  Widget _buildStepTwo({Key? key, required bool dark}) {
    final text = dark ? AppColorsDark.text : AppColors.text;
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;
    final cardName = _cardNameController.text.trim();
    final amountFmt = _amount.toStringAsFixed(2);
    final typeLabel = Get.find<LanguageController>().getTranslation(
      _selectedType == 'multi' ? Strings.multiUse : Strings.singleUse,
    );

    return Column(
      key: key,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Get.find<LanguageController>()
                      .getTranslation(Strings.reviewYourCard),
                  style: AppTextStyles.h1.copyWith(color: text),
                ),
                const SizedBox(height: 8),
                Text(
                  Get.find<LanguageController>()
                      .getTranslation(Strings.thisIsWhatYoureAboutToCreate),
                  style: AppTextStyles.body.copyWith(color: text2),
                ),
                const SizedBox(height: 32),
                _CardPreview(
                  cardName: cardName.isEmpty
                      ? Get.find<LanguageController>()
                          .getTranslation(Strings.cardFallbackLabel)
                      : cardName,
                  amountText: '\$$amountFmt',
                  type: _selectedType,
                ),
                const SizedBox(height: 24),
                SCSurfaceCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _DetailRow(
                        label: Get.find<LanguageController>()
                            .getTranslation(Strings.cardNameLabel),
                        value: cardName,
                      ),
                      _DetailDivider(dark: dark),
                      _DetailRow(
                        label: Get.find<LanguageController>()
                            .getTranslation(Strings.typeLabel),
                        value: typeLabel,
                      ),
                      _DetailDivider(dark: dark),
                      _DetailRow(
                        label: Get.find<LanguageController>()
                            .getTranslation(Strings.initialBalance),
                        value: '\$$amountFmt',
                      ),
                      _DetailDivider(dark: dark),
                      _DetailRow(
                        label: Get.find<LanguageController>()
                            .getTranslation(Strings.currency),
                        value: _currencyCode,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        _PinnedFooter(
          dark: dark,
          child: Row(
            children: [
              Expanded(
                child: SCSecondaryButton(
                  label: Get.find<LanguageController>()
                      .getTranslation(Strings.backButtonLabel),
                  onPressed: () => setState(() => _step = 1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => SCPrimaryButton(
                    label: Get.find<LanguageController>()
                        .getTranslation(Strings.createCard),
                    icon: Icons.check_rounded,
                    loading: cardChargeController.isLoading,
                    onPressed: _onCreate,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ────────────────────────── Sub-widgets ──────────────────────────────────

// Pinned bottom container with a top hairline + safe-area inset so the CTA
// stays visible when the keyboard opens.
class _PinnedFooter extends StatelessWidget {
  final bool dark;
  final Widget child;
  const _PinnedFooter({required this.dark, required this.child});

  @override
  Widget build(BuildContext context) {
    final bg = dark ? AppColorsDark.bg : AppColors.bg;
    final line2 = dark ? AppColorsDark.line2 : AppColors.line2;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomInset),
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: line2, width: 1)),
      ),
      child: child,
    );
  }
}

class _TypeTile extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TypeTile({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark ? AppColorsDark.accent : AppColors.accent;
    final accentInk = dark ? AppColorsDark.accentInk : AppColors.accentInk;
    final surface = dark ? AppColorsDark.surface : AppColors.surface;
    final surface2 = dark ? AppColorsDark.surface2 : AppColors.surface2;
    final line = dark ? AppColorsDark.line : AppColors.line;
    final text = dark ? AppColorsDark.text : AppColors.text;
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;

    final radius = BorderRadius.circular(AppRadius.lg);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: radius,
        border: Border.all(
          color: selected ? accent : line,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              onTap();
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
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
                    child: Icon(icon, size: 20, color: text),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.bodyMed.copyWith(color: text),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(color: text2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? accent : Colors.transparent,
                      shape: BoxShape.circle,
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
      ),
    );
  }
}

class _LimitRow extends StatelessWidget {
  final String label;
  final String value;
  const _LimitRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: dark ? AppColorsDark.text2 : AppColors.text2,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.numMd.copyWith(
              color: dark ? AppColorsDark.text : AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: dark ? AppColorsDark.text2 : AppColors.text2,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMed.copyWith(
              color: dark ? AppColorsDark.text : AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailDivider extends StatelessWidget {
  final bool dark;
  const _DetailDivider({required this.dark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.5,
      thickness: 0.5,
      color: dark ? AppColorsDark.line2 : AppColors.line2,
    );
  }
}

class _CardPreview extends StatelessWidget {
  final String cardName;
  final String amountText;
  final String type;

  const _CardPreview({
    required this.cardName,
    required this.amountText,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final typeLabel = Get.find<LanguageController>()
        .getTranslation(type == 'multi' ? Strings.multiUse : Strings.singleUse)
        .toUpperCase();
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1F2937), Color(0xFF0A0E1A)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'TAKARA PAY · VIRTUAL',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                cardName,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Text(
            '•••• •••• •••• ••••',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 16,
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Get.find<LanguageController>()
                        .getTranslation(Strings.balance)
                        .toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9,
                      letterSpacing: 0.6,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    amountText,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                typeLabel,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  letterSpacing: 0.8,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
