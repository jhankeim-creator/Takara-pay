import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';

import "package:TAKARA PAY/views/virtual_card_cardyfie/controller/cardyfie_info_controller.dart";
import "package:TAKARA PAY/views/virtual_card_flutterwave/controller/flutterwave_card_controller.dart";
import "package:TAKARA PAY/views/virtual_card_stripe/controller/stripe_two_controller.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/controller/strowallelt_info_controller.dart";
import "package:TAKARA PAY/views/virtual_card_sudo/controller/sudo_my_card_controller.dart";
import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_virtual_card.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/utils/card_provider_router.dart";
import "package:TAKARA PAY/base/utils/card_vm.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";

class MyCardScreen extends StatelessWidget {
  MyCardScreen({super.key});

  // Preserved Get.put registrations from the original delegation router.
  // Each per-provider controller's onInit fires its data fetch — keep them
  // registered even though this redesign no longer reads from each model
  // directly (real per-provider card data is a follow-up task).
  final dashboardController = Get.put(DashBoardController());
  final stripeController = Get.put(StripeTwoController());
  final flutterWaveCardController = Get.put(FlutterWaveCardController());
  final sudoController = Get.put(VirtualSudoCardController());
  final strowalletController = Get.put(VirtualStrowalletCardController());
  final cardyfieController = Get.put(VirtualCardyfieCardController());

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? AppColorsDark.bg : AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              _buildHeader(dark),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(() {
                  final loading =
                      sudoController.isLoading ||
                      stripeController.isLoading ||
                      strowalletController.isLoading ||
                      cardyfieController.isLoading ||
                      flutterWaveCardController.isLoading;
                  if (loading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    );
                  }
                  return _buildList(context, dark);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool dark) {
    final textColor = dark ? AppColorsDark.text : AppColors.text;
    final surface = dark ? AppColorsDark.surface : AppColors.surface;
    final line = dark ? AppColorsDark.line : AppColors.line;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Get.find<LanguageController>().getTranslation(Strings.myCard),
            style: AppTextStyles.h1.copyWith(color: textColor),
          ),
          Material(
            color: surface,
            shape: const StadiumBorder(),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () {
                HapticFeedback.selectionClick();
                CardProviderRouter.openCreateCard();
              },
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  shape: StadiumBorder(side: BorderSide(color: line, width: 1)),
                ),
                child: Icon(Icons.add_rounded, size: 20, color: textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, bool dark) {
    // Real per-provider cards from the active virtual system. Never throws and
    // returns [] when nothing is mapped / loaded.
    final cards = ActiveCards.resolve();
    final limit = ActiveCards.resolveLimit();
    final atLimit = limit != null && limit > 0 && cards.length >= limit;

    String currency = 'USD';
    try {
      final data = dashboardController.dashBoardModel.data;
      if (data.userWallet.isNotEmpty) {
        currency = data.userWallet.first.currency.code;
      }
    } catch (_) {
      // Model not loaded — currency falls back to the default below.
    }

    if (cards.isEmpty) {
      return _buildEmptyState(dark, limit);
    }

    return Column(
      children: [
        if (limit != null && limit > 0)
          _CardLimitBanner(used: cards.length, limit: limit, dark: dark),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            physics: const BouncingScrollPhysics(),
            itemCount: cards.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == cards.length) {
                return _CreateCardTile(
                  atLimit: atLimit,
                  onTap: atLimit
                      ? () => _showLimitReached(limit)
                      : CardProviderRouter.openCreateCard,
                );
              }
              final card = cards[index];
              return _CardListRow(
                cardName: card.cardName,
                last4: card.last4,
                currency: currency,
                expiry: card.expiry,
                // No per-card monthly spent/limit is available from any
                // provider model, so the spend bar stays hidden (limit == 0).
                spent: 0,
                limit: 0,
                frozen: card.frozen,
                processing: card.processing,
                gradient: cardGradientFor(
                  kCardVariants[index % kCardVariants.length],
                ),
                onTap:
                    card.onTap ?? () => Get.toNamed(Routes.cardDetailsScreen),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showLimitReached(int limit) {
    Get.snackbar(
      Get.find<LanguageController>().getTranslation(Strings.cardLimitReached),
      'Your plan allows up to $limit ${limit == 1 ? 'card' : 'cards'}. '
      'Close an existing card to create a new one.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.text,
      colorText: AppColors.bg,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  Widget _buildEmptyState(bool dark, int? limit) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      physics: const BouncingScrollPhysics(),
      children: [
        if (limit != null && limit > 0) ...[
          _CardLimitBanner(used: 0, limit: limit, dark: dark),
          const SizedBox(height: 4),
        ],
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: dark ? AppColorsDark.accentSoft : AppColors.accentSoft,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: dark ? AppColorsDark.accent : AppColors.accent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Get.find<LanguageController>().getTranslation(
                        Strings.oneCardPerMerchant,
                      ),
                      style: AppTextStyles.bodyMed.copyWith(
                        color: dark ? AppColorsDark.text : AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Get.find<LanguageController>().getTranslation(
                        Strings.separateCardPerServiceTip,
                      ),
                      style: AppTextStyles.caption.copyWith(
                        color: dark ? AppColorsDark.text2 : AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _CreateCardTile(onTap: CardProviderRouter.openCreateCard),
      ],
    );
  }
}

// ─────────────────────────── Sub-widgets ────────────────────────────────

class _CardListRow extends StatelessWidget {
  final String cardName;
  final String last4;
  final String currency;
  final double spent;
  final double limit;
  final bool frozen;
  final bool processing;
  final List<Color>? gradient;
  final VoidCallback onTap;
  // Optional real expiry ('MM/YY'). Backward-safe: defaults to empty so
  // existing callers that don't supply it keep working.
  final String expiry;

  const _CardListRow({
    required this.cardName,
    required this.last4,
    required this.currency,
    required this.spent,
    required this.limit,
    required this.frozen,
    this.processing = false,
    this.gradient,
    required this.onTap,
    this.expiry = '',
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final spentText = spent.toStringAsFixed(0);
    final limitText = limit.toStringAsFixed(0);
    final progress = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;
    final last4Short = last4.length >= 4
        ? last4.substring(last4.length - 4)
        : (last4.isEmpty ? '••••' : last4);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: dark ? AppColorsDark.surface : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: dark ? AppColorsDark.line2 : AppColors.line2,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Compact card preview — uses the card's own colour so the list
              // mirrors the multi-colour cards on the dashboard.
              Container(
                width: 64,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:
                        gradient ??
                        const [Color(0xFF1F2937), Color(0xFF0A0E1A)],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STRIPCARD',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 6,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.6),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        cardName.length > 10
                            ? '${cardName.substring(0, 10)}…'
                            : cardName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cardName,
                            style: AppTextStyles.bodyMed.copyWith(
                              color: dark ? AppColorsDark.text : AppColors.text,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (processing) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x33F0A33A),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.hourglass_top_rounded,
                                  size: 10,
                                  color: Color(0xFFD98A1F),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  Get.find<LanguageController>().getTranslation(
                                    Strings.processingStatus,
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFD98A1F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (frozen) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x33A0C8FF),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.ac_unit,
                                  size: 10,
                                  color: Color(0xFF6BA4FF),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  Get.find<LanguageController>().getTranslation(
                                    Strings.frozen,
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6BA4FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      expiry.isNotEmpty && expiry != '••/••'
                          ? '•• $last4Short · $currency · $expiry'
                          : '•• $last4Short · $currency',
                      style: AppTextStyles.caption.copyWith(
                        color: dark ? AppColorsDark.text3 : AppColors.text3,
                      ),
                    ),
                    if (limit > 0 && !frozen) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 3,
                          backgroundColor: dark
                              ? AppColorsDark.line
                              : AppColors.line,
                          valueColor: AlwaysStoppedAnimation(
                            dark ? AppColorsDark.accent : AppColors.accent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$$spentText of \$$limitText this month',
                        style: AppTextStyles.caption.copyWith(
                          color: dark ? AppColorsDark.text3 : AppColors.text3,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: dark ? AppColorsDark.text3 : AppColors.text3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateCardTile extends StatelessWidget {
  final VoidCallback onTap;
  final bool atLimit;

  const _CreateCardTile({required this.onTap, this.atLimit = false});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final outline = dark ? AppColorsDark.line : AppColors.line;
    final fg = dark ? AppColorsDark.text2 : AppColors.text2;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: DottedBorder(
          color: outline,
          strokeWidth: 1.5,
          dashPattern: const [6, 4],
          borderType: BorderType.RRect,
          radius: const Radius.circular(AppRadius.lg),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 28),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  atLimit ? Icons.lock_outline : Icons.add_rounded,
                  size: 18,
                  color: fg,
                ),
                const SizedBox(width: 6),
                Text(
                  atLimit
                      ? Get.find<LanguageController>().getTranslation(
                          Strings.cardLimitReached,
                        )
                      : Get.find<LanguageController>().getTranslation(
                          Strings.createNewCard,
                        ),
                  style: AppTextStyles.bodyMed.copyWith(color: fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small informational banner showing how many cards the user has created
/// against their plan's `card_create_limit`.
class _CardLimitBanner extends StatelessWidget {
  final int used;
  final int limit;
  final bool dark;

  const _CardLimitBanner({
    required this.used,
    required this.limit,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    final atLimit = used >= limit;
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;
    final accent = dark ? AppColorsDark.accent : AppColors.accent;
    final progress = limit > 0 ? (used / limit).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.credit_card_rounded, size: 14, color: text3),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '$used of $limit cards created',
                  style: AppTextStyles.caption.copyWith(color: text2),
                ),
              ),
              if (atLimit)
                Text(
                  Get.find<LanguageController>().getTranslation(
                    Strings.limitReached,
                  ),
                  style: AppTextStyles.caption.copyWith(
                    color: text3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 3,
              backgroundColor: dark ? AppColorsDark.line : AppColors.line,
              valueColor: AlwaysStoppedAnimation(atLimit ? text3 : accent),
            ),
          ),
        ],
      ),
    );
  }
}
