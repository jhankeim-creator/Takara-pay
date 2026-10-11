import 'dart:math' as math;

import 'package:intl/intl.dart';

import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/views/navbar/controller/navbar_controller.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_section_header.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_shimmer.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_surface_card.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_transaction_row.dart";

String _relativeTime(DateTime t) {
  final now = DateTime.now();
  final diff = now.difference(t);
  if (diff.inMinutes < 1) {
    return Get.find<LanguageController>().getTranslation(Strings.justNow);
  }
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24 && now.day == t.day) {
    return '${Get.find<LanguageController>().getTranslation(Strings.today)}, ${DateFormat.Hm().format(t)}';
  }
  if (diff.inDays < 2) {
    return Get.find<LanguageController>().getTranslation(Strings.yesterday);
  }
  if (diff.inDays < 7) return DateFormat('EEE').format(t);
  return DateFormat('MMM d').format(t);
}

class _CurrencyPalette {
  const _CurrencyPalette(this.color, this.soft);
  final Color color;
  final Color soft;
}

_CurrencyPalette _paletteFor(String code) {
  switch (code) {
    case 'USD':
      return const _CurrencyPalette(AppColors.accent, AppColors.accentSoft);
    case 'EUR':
      return const _CurrencyPalette(AppColors.text2, AppColors.neutralSoft);
    case 'GBP':
      return const _CurrencyPalette(AppColors.warn, AppColors.warnSoft);
    default:
      return const _CurrencyPalette(AppColors.accent, AppColors.accentSoft);
  }
}

class MyWalletScreen extends StatelessWidget {
  MyWalletScreen({super.key});

  final dashBoardController = Get.put(DashBoardController());

  // Local UI state — the controller has no selected-currency observable,
  // so we keep one here. Empty string means "use the first wallet".
  final _selectedCurrencyCode = ''.obs;

  String _resolveSelected(List wallets) {
    final selected = _selectedCurrencyCode.value;
    if (selected.isNotEmpty &&
        wallets.any((w) => w.currency.code == selected)) {
      return selected;
    }
    return wallets.isNotEmpty ? wallets.first.currency.code : '';
  }

  void _goToTab(int index) {
    final navbar = Get.isRegistered<NavbarController>()
        ? Get.find<NavbarController>()
        : Get.put(NavbarController());
    navbar.selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          // Wallet is a sub-destination inside the navbar shell (page[1]),
          // not a pushed route — so Get.back() has nothing to pop. Return to
          // the Home tab instead.
          onPressed: () => _goToTab(0),
        ),
        title: Text(
          Get.find<LanguageController>().getTranslation(Strings.myWallet),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.text, size: 22),
            onPressed: () => Get.toNamed(Routes.depositScreen),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (dashBoardController.isLoading) {
            return const SCDetailSkeleton(showHero: true);
          }
          return _buildBody();
        }),
      ),
    );
  }

  Widget _buildBody() {
    final data = dashBoardController.dashBoardModel.data;
    final wallets = data.userWallet;
    final transactions = data.transactions;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTotalCard(wallets),
          const SizedBox(height: 20),
          SCSectionHeader(
            label: Get.find<LanguageController>().getTranslation(
              Strings.currencies,
            ),
          ),
          Obx(() => _buildCurrencyList(wallets)),
          const SizedBox(height: 24),
          Obx(() => _buildActions(data, _resolveSelected(wallets))),
          const SizedBox(height: 24),
          Obx(
            () => _buildRecentSection(transactions, _resolveSelected(wallets)),
          ),
          const SizedBox(height: 100), // floating nav clearance
        ],
      ),
    );
  }

  // ── Total card ─────────────────────────────────────────────────────────
  Widget _buildTotalCard(List wallets) {
    // Naive sum across wallets — controller exposes no exchange-rate logic
    // so this is a literal sum, labelled "USD equivalent" per spec. Wire a
    // real conversion when a rates API is available.
    final total = wallets.fold<double>(0, (sum, w) => sum + w.balance);
    final fmtTotal = NumberFormat('#,##0.00').format(total);
    final parts = fmtTotal.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? '.${parts[1]}' : '.00';

    return SCSurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Get.find<LanguageController>().getTranslation(
              Strings.totalUsdEquivalent,
            ),
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                r'$',
                style: AppTextStyles.h2.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                intPart,
                style: AppTextStyles.numDisplay.copyWith(color: AppColors.text),
              ),
              Text(
                decPart,
                style: AppTextStyles.bodyMed.copyWith(color: AppColors.text2),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _AllocationBar(wallets: wallets, total: total),
          const SizedBox(height: 10),
          _AllocationLegend(wallets: wallets, total: total),
        ],
      ),
    );
  }

  // ── Currency list ─────────────────────────────────────────────────────
  Widget _buildCurrencyList(List wallets) {
    if (wallets.isEmpty) {
      return SCSurfaceCard(
        child: Text(
          Get.find<LanguageController>().getTranslation(Strings.noWalletsYet),
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
      );
    }

    final selectedCode = _resolveSelected(wallets);

    return Column(
      children: [
        for (int i = 0; i < wallets.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _CurrencyRow(
            wallet: wallets[i],
            selected: wallets[i].currency.code == selectedCode,
            onTap: () => _selectedCurrencyCode.value = wallets[i].currency.code,
          ),
        ],
      ],
    );
  }

  // ── Actions ───────────────────────────────────────────────────────────
  Widget _buildActions(dynamic data, String selectedCode) {
    final canAdd = data.moduleAccess.addMoney == true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SCSectionHeader(
          label:
              '${selectedCode.isEmpty ? '' : '$selectedCode '}'
              '${Get.find<LanguageController>().getTranslation(Strings.actions)}',
        ),
        Row(
          children: [
            Expanded(
              child: SCPrimaryButton(
                label: Get.find<LanguageController>().getTranslation(
                  Strings.add,
                ),
                icon: Icons.add,
                onPressed: canAdd
                    ? () => Get.toNamed(Routes.depositScreen)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SCSecondaryButton(
                label: Get.find<LanguageController>().getTranslation(
                  Strings.send,
                ),
                icon: Icons.north_east,
                onPressed: () => _goToTab(2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Recent activity ───────────────────────────────────────────────────
  Widget _buildRecentSection(List transactions, String selectedCode) {
    // Transaction model has no currency field, so we cannot actually filter
    // by selectedCode. Rendering the latest 5 unfiltered for now; once the
    // backend tags transactions with currency, swap this for a where().
    final shown = transactions.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SCSectionHeader(
          label: selectedCode.isEmpty
              ? Get.find<LanguageController>().getTranslation(
                  Strings.recentInWallet,
                )
              : '${Get.find<LanguageController>().getTranslation(Strings.recentIn)} $selectedCode',
        ),
        if (shown.isEmpty)
          SCSurfaceCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  size: 32,
                  color: AppColors.text3,
                ),
                const SizedBox(height: 12),
                Text(
                  Get.find<LanguageController>().getTranslation(
                    Strings.noActivityYet,
                  ),
                  style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 4),
                Text(
                  Get.find<LanguageController>().getTranslation(
                    Strings.transactionsWillShowHere,
                  ),
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          )
        else
          SCSurfaceCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (int i = 0; i < shown.length; i++) ...[
                  _walletTxnRow(shown[i]),
                  if (i != shown.length - 1)
                    const Divider(
                      height: 0.5,
                      thickness: 0.5,
                      indent: 60,
                      color: AppColors.line,
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _walletTxnRow(dynamic tx) {
    final isCredit = tx.type.toString() == '+';
    final title = tx.transactionType.toString();
    final relative = _relativeTime(tx.dateTime as DateTime);
    final trx = tx.trx.toString();
    final subtitle = trx.isEmpty ? relative : '$relative · $trx';
    final sign = isCredit ? '+' : '−';
    return SCTransactionRow(
      title: title,
      subtitle: subtitle,
      amountText: '$sign${tx.requestAmount}',
      isCredit: isCredit,
      onTap: () => Get.toNamed(Routes.transactionLogScreen),
    );
  }
}

// ─────────────────────── sub-widgets ──────────────────────────────────────

class _AllocationBar extends StatelessWidget {
  const _AllocationBar({required this.wallets, required this.total});

  final List wallets;
  final double total;

  @override
  Widget build(BuildContext context) {
    final positive = wallets
        .where((w) => w.balance > 0)
        .toList(growable: false);
    if (positive.isEmpty || total <= 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(height: 8, color: AppColors.line),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: SizedBox(
        height: 8,
        child: Row(
          children: [
            for (int i = 0; i < positive.length; i++)
              Expanded(
                flex: math.max(1, (positive[i].balance * 100).round()),
                child: Container(
                  color: _paletteFor(positive[i].currency.code).color,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AllocationLegend extends StatelessWidget {
  const _AllocationLegend({required this.wallets, required this.total});

  final List wallets;
  final double total;

  @override
  Widget build(BuildContext context) {
    if (wallets.isEmpty || total <= 0) return const SizedBox.shrink();

    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        for (final w in wallets)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _paletteFor(w.currency.code).color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${w.currency.code} ${((w.balance / total) * 100).round()}%',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
      ],
    );
  }
}

class _CurrencyRow extends StatelessWidget {
  const _CurrencyRow({
    required this.wallet,
    required this.selected,
    required this.onTap,
  });

  final dynamic wallet;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = _paletteFor(wallet.currency.code.toString());
    final radius = BorderRadius.circular(AppRadius.lg);
    final fmt = NumberFormat('#,##0.00');

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
                      color: palette.soft,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      wallet.currency.symbol.toString(),
                      style: AppTextStyles.bodyMed.copyWith(
                        color: palette.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          wallet.currency.name.toString(),
                          style: AppTextStyles.bodyMed.copyWith(
                            color: AppColors.text,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          wallet.currency.code.toString(),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    fmt.format(wallet.balance),
                    style: AppTextStyles.numLg.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w500,
                    ),
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
