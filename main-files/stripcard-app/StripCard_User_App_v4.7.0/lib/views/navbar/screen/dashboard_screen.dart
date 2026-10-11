import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import "package:TAKARA PAY/views/virtual_card_cardyfie/controller/cardyfie_info_controller.dart";
import "package:TAKARA PAY/views/virtual_card_flutterwave/controller/flutterwave_card_controller.dart";
import "package:TAKARA PAY/views/virtual_card_stripe/controller/stripe_two_controller.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/controller/strowallelt_info_controller.dart";
import "package:TAKARA PAY/views/virtual_card_sudo/controller/sudo_my_card_controller.dart";
import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/views/navbar/controller/navbar_controller.dart";
import "package:TAKARA PAY/views/navbar/controller/usefull_link_controller.dart";
import "package:TAKARA PAY/base/utils/data/categories_stripe_data.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/utils/card_provider_router.dart";
import "package:TAKARA PAY/base/utils/card_vm.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_avatar.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_section_header.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_shimmer.dart";
import "package:TAKARA PAY/base/widgets/design_system/error_state_widget.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_surface_card.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_transaction_row.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_virtual_card.dart";

String _relativeTime(DateTime t) {
  final now = DateTime.now();
  final diff = now.difference(t);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24 && now.day == t.day) {
    return 'Today, ${DateFormat.Hm().format(t)}';
  }
  if (diff.inDays < 2) return 'Yesterday';
  if (diff.inDays < 7) return DateFormat('EEE').format(t);
  return DateFormat('MMM d').format(t);
}

String _greetingTimeOfDay() {
  final h = DateTime.now().hour;
  if (h < 12) return 'morning';
  if (h < 17) return 'afternoon';
  return 'evening';
}

// "GIFT-CARD" → "Gift card", "TOP-UP" → "Top up", etc.
String _humanize(String raw) {
  if (raw.isEmpty) return raw;
  final parts = raw.toLowerCase().split(RegExp(r'[-_\s]+'));
  if (parts.isEmpty) return raw;
  return parts.first[0].toUpperCase() +
      parts.first.substring(1) +
      (parts.length > 1 ? ' ${parts.skip(1).join(' ')}' : '');
}

// Vibrant per-card colours (shared with the card-list screen) so each card has
// its own background instead of every card looking the same dark block.
const List<SCCardVariant> _cardVariants = kCardVariants;

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  // Preserved controller registrations — these were field initializers in the
  // original screen; each Get.put fires the controller's onInit which loads
  // its provider-specific state. Keep all of them even where the new visual
  // doesn't read from them so the existing data fetches still happen.
  final dashBoardController = Get.put(DashBoardController());
  final myCardController = Get.put(StripeTwoController());
  final stripTwoController = Get.put(StripeTwoController());
  final sudoCardController = Get.put(VirtualSudoCardController());
  final flutterWaveCardController = Get.put(FlutterWaveCardController());
  final cardyfieCardController = Get.put(VirtualCardyfieCardController());
  final useFullLinkController = Get.put(UseFullLinkController());
  final strowalletCardController = Get.put(VirtualStrowalletCardController());

  // Local UI state.
  final _balanceVisible = true.obs;

  // ── Refresh handler — preserved verbatim from the original. ────────────
  Future<void> _onRefresh() async {
    await dashBoardController.getDashboardData().then((value) {
      final system = dashBoardController.dashBoardModel.data.activeVirtualSystem;
      if (system == 'flutterwave') {
        flutterWaveCardController.getCardData();
      } else if (system == 'sudo') {
        sudoCardController.getCardData();
      } else if (system == 'strowallet') {
        strowalletCardController.getStrowalletCardData();
      } else if (system == 'cardyfie') {
        cardyfieCardController.getCardyfieCardData();
      } else {
        stripeCardController.getStripeCardData();
      }
    });
  }

  // ── Nav helpers ────────────────────────────────────────────────────────
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
      body: Obx(() {
        if (dashBoardController.isLoading) {
          return const SafeArea(child: SCDetailSkeleton(showHero: true));
        }
        // Fetch failed (no network / server / API issue) and we have no data —
        // show a recoverable error state instead of crashing on the late model.
        if (!dashBoardController.hasData) {
          return SafeArea(child: _buildErrorState());
        }
        return SafeArea(
          child: RefreshIndicator(
            color: AppColors.accent,
            backgroundColor: AppColors.surface,
            onRefresh: _onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              children: [
                _buildHeader(),
                _buildBalanceCard(),
                _buildQuickActions(),
                _buildCardsSection(),
                _buildActivitySection(context),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Recoverable error state shown when the dashboard fetch fails and there's
  // no data to render. Keeps the app usable (English, no red crash) and lets
  // the user retry once connectivity / the API is back.
  Widget _buildErrorState() {
    return ErrorStateWidget(
      scrollable: true,
      topSpacing: 0.22.sh,
      primaryButton: true,
      title: Get.find<LanguageController>()
          .getTranslation(Strings.dashboardLoadFailedTitle),
      message: Get.find<LanguageController>()
          .getTranslation(Strings.checkConnectionAndRetry),
      retryLabel: Get.find<LanguageController>().getTranslation(Strings.retry),
      loading: dashBoardController.isLoading,
      onRetry: () => dashBoardController.getDashboardData(),
    );
  }

  // ──────────────────── SECTION 1 — HEADER ─────────────────────
  Widget _buildHeader() {
    final user = dashBoardController.dashBoardModel.data.user;
    final firstName = user.firstname;
    final lastName = user.lastname;
    final initials =
        '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) {
                  final dark =
                      Theme.of(context).brightness == Brightness.dark;
                  final fullName = '$firstName $lastName'.trim();
                  final shownInitials = fullName.isEmpty
                      ? '?'
                      : fullName
                          .split(' ')
                          .map((s) => s.isNotEmpty ? s[0] : '')
                          .take(2)
                          .join()
                          .toUpperCase();
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: dark
                          ? AppColorsDark.surface2
                          : AppColors.surface2,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: dark ? AppColorsDark.line2 : AppColors.line2,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      shownInitials,
                      style: AppTextStyles.label.copyWith(
                        color: dark ? AppColorsDark.text : AppColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Good ${_greetingTimeOfDay()}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                  Text(
                    firstName.isEmpty ? 'there' : firstName,
                    style: AppTextStyles.bodyMed.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _HeaderIconButton(
                icon: Icons.notifications_none,
                showDot: false,
                onTap: () => _goToTab(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────── SECTION 2 — BALANCE CARD ───────────────
  Widget _buildBalanceCard() {
    final wallets = dashBoardController.dashBoardModel.data.userWallet;
    if (wallets.isEmpty) {
      return const SizedBox.shrink();
    }

    final primary = wallets.first;
    final balance = primary.balance;
    final currencyCode = primary.currency.code;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${Get.find<LanguageController>().getTranslation(Strings.totalBalance)} · $currencyCode',
                  style: AppTextStyles.caption.copyWith(color: Colors.white70),
                ),
                Obx(
                  () => GestureDetector(
                    onTap: () =>
                        _balanceVisible.value = !_balanceVisible.value,
                    behavior: HitTestBehavior.opaque,
                    child: Icon(
                      _balanceVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _balanceVisible.value
                    ? _AnimatedBalance(
                        key: const ValueKey('shown'),
                        balance: balance,
                      )
                    : const _HiddenBalance(key: ValueKey('hidden')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────── SECTION 3 — QUICK ACTIONS ──────────────
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Row(
        children: [
          Expanded(
            child: _QuickAction(
              icon: Icons.south_rounded,
              label: 'Add',
              gradient: const [Color(0xFF22C55E), Color(0xFF15803D)],
              onPressed: () => Get.toNamed(Routes.depositScreen),
            ),
          ),
          Expanded(
            child: _QuickAction(
              icon: Icons.swap_horiz_rounded,
              label: 'Send',
              gradient: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
              onPressed: () => Get.toNamed(Routes.moneyTransferScreen),
            ),
          ),
          Expanded(
            child: _QuickAction(
              icon: Icons.north_rounded,
              label: 'Withdraw',
              gradient: const [Color(0xFFF59E0B), Color(0xFFB45309)],
              onPressed: () => Get.toNamed(Routes.withdrawScreen),
            ),
          ),
          Expanded(
            child: _QuickAction(
              icon: Icons.card_giftcard_rounded,
              label: 'Gift card',
              gradient: const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
              onPressed: () => Get.toNamed(Routes.giftCardScreen),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────── SECTION 4 — YOUR CARDS ─────────────────
  Widget _buildCardsSection() {
    // Subscribe (this runs inside the body Obx) to the ACTIVE provider's load
    // revision so the section rebuilds the moment its async card fetch lands.
    // Without this, ActiveCards.resolve() reads a non-reactive late model and
    // the section was intermittently stuck on the empty placeholder whenever
    // the fetch finished after first paint.
    switch (dashBoardController.activeVirtualSystem.value.toLowerCase()) {
      case 'sudo':
        sudoCardController.cardsRevision.value;
        break;
      case 'flutterwave':
        flutterWaveCardController.cardsRevision.value;
        break;
      case 'strowallet':
        strowalletCardController.cardsRevision.value;
        break;
      case 'cardyfie':
        cardyfieCardController.cardsRevision.value;
        break;
      case 'stripe':
        stripeCardController.cardsRevision.value;
        break;
    }

    // Real per-provider cards from the active virtual system. Returns [] (and
    // never throws) when no provider is mapped or the provider model hasn't
    // loaded yet — in which case we fall back to the empty placeholder.
    final cards = ActiveCards.resolve();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SCSectionHeader(
            label: 'YOUR CARDS',
            trailing: SCGhostButton(
              label: 'See all',
              onPressed: () => _goToTab(3),
              fullWidth: false,
            ),
          ),
          const SizedBox(height: 12),
          if (cards.isEmpty)
            _buildEmptyCardPlaceholder()
          else
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                itemCount: cards.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final card = cards[i];
                  return SizedBox(
                    width: 280,
                    child: GestureDetector(
                      onTap: card.onTap ?? () => _goToTab(3),
                      child: SCVirtualCard(
                        cardName: card.cardName,
                        last4: card.last4,
                        balance: card.balance,
                        expiry: card.expiry,
                        frozen: card.frozen,
                        network: card.network,
                        variant: _cardVariants[i % _cardVariants.length],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDashboardTxnRow(BuildContext context, dynamic tx) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final isCredit = tx.type.toString() == '+';

    final rawTitle = tx.transactionType.toString();
    final title = _humanize(rawTitle);

    final relative = _relativeTime(tx.dateTime as DateTime);
    final trxRaw = tx.trx.toString();
    final shortRef = trxRaw.length > 12
        ? '${trxRaw.substring(0, 12)}…'
        : trxRaw;
    final subtitle = shortRef.isEmpty ? relative : '$relative · $shortRef';

    final amountStr = tx.requestAmount.toString();
    // requestAmount may include the currency code (e.g. "10.00 USD") and/or
    // a leading sign — strip everything that isn't a digit or dot before
    // parsing, then take abs() so the explicit `+`/`−` prefix below is the
    // sole source of truth for direction.
    final cleaned = amountStr.replaceAll(RegExp(r'[^\d.]'), '');
    final amountValue = double.tryParse(cleaned)?.abs();
    final formattedAmount = amountValue != null
        ? amountValue.toStringAsFixed(2)
        : amountStr;
    final sign = isCredit ? '+' : '−'; // U+2212 minus

    // Currency code: model has no per-transaction currency, so we fall back
    // to the user's primary wallet currency for the suffix.
    final wallets = dashBoardController.dashBoardModel.data.userWallet;
    final currency = wallets.isNotEmpty ? wallets.first.currency.code : '';

    final amountColor = isCredit
        ? (dark ? AppColorsDark.accent : AppColors.accent)
        : (dark ? AppColorsDark.text : AppColors.text);
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;
    final textColor = dark ? AppColorsDark.text : AppColors.text;
    final accentSoft =
        dark ? AppColorsDark.accentSoft : AppColors.accentSoft;
    final surface2 = dark ? AppColorsDark.surface2 : AppColors.surface2;
    final accent = dark ? AppColorsDark.accent : AppColors.accent;

    return InkWell(
      onTap: () => Get.toNamed(Routes.transactionLogScreen),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading 36×36 circle: credit shows accent-tinted incoming
            // arrow; debit shows the merchant's first letter on a neutral
            // surface. The Transaction model exposes no merchant logo URL,
            // so the letter avatar is always the fallback.
            ClipOval(
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                color: isCredit ? accentSoft : surface2,
                child: isCredit
                    ? Icon(
                        Icons.south_west_rounded,
                        size: 16,
                        color: accent,
                      )
                    : Text(
                        title.isEmpty ? '?' : title.characters.first,
                        style: AppTextStyles.label.copyWith(color: textColor),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title.isEmpty ? rawTitle : title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMed.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(color: text3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$sign$formattedAmount',
                  style: AppTextStyles.numMd.copyWith(color: amountColor),
                ),
                if (currency.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Text(
                    currency,
                    style: AppTextStyles.caption.copyWith(color: text3),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCardPlaceholder() {
    return GestureDetector(
      onTap: CardProviderRouter.openCreateCard,
      child: DottedBorder(
        color: AppColors.line,
        borderType: BorderType.RRect,
        radius: const Radius.circular(AppRadius.lg),
        dashPattern: const [6, 4],
        strokeWidth: 1,
        child: SizedBox(
          height: 180,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_card,
                size: 28,
                color: AppColors.text3,
              ),
              const SizedBox(height: 8),
              Text(
                Get.find<LanguageController>()
                    .getTranslation(Strings.createYourFirstCard),
                style: AppTextStyles.label.copyWith(
                  color: AppColors.text2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────── SECTION 5 — RECENT ACTIVITY ────────────
  Widget _buildActivitySection(BuildContext context) {
    final transactions =
        dashBoardController.dashBoardModel.data.transactions;
    final shown = transactions.take(5).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SCSectionHeader(
            label:
                Get.find<LanguageController>().getTranslation(Strings.recentActivity),
            trailing: SCGhostButton(
              label: Get.find<LanguageController>().getTranslation(Strings.seeAll),
              onPressed: () => Get.toNamed(Routes.transactionLogScreen),
              fullWidth: false,
            ),
          ),
          const SizedBox(height: 8),
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
                    Get.find<LanguageController>()
                        .getTranslation(Strings.noActivityYet),
                    style: AppTextStyles.bodyMed.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Get.find<LanguageController>()
                        .getTranslation(Strings.transactionsWillShowHere),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
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
                    _buildDashboardTxnRow(context, shown[i]),
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
      ),
    );
  }
}

// ─────────────────────── helpers / sub-widgets ──────────────────────────

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.showDot = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.line, width: 0.5),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            children: [
              Center(
                child: Icon(icon, size: 20, color: AppColors.text),
              ),
              if (showDot)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: SizedBox(
                    width: 8,
                    height: 8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedBalance extends StatelessWidget {
  const _AnimatedBalance({super.key, required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: balance),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (_, value, __) {
        final formatted = NumberFormat('#,##0.00').format(value);
        final parts = formatted.split('.');
        final intPart = parts[0];
        final decPart = parts.length > 1 ? '.${parts[1]}' : '.00';

        return Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              r'$',
              style: AppTextStyles.h2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              intPart,
              style: AppTextStyles.numDisplay.copyWith(color: Colors.white),
            ),
            Text(
              decPart,
              style: AppTextStyles.bodyMed.copyWith(color: Colors.white70),
            ),
          ],
        );
      },
    );
  }
}

class _HiddenBalance extends StatelessWidget {
  const _HiddenBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          r'$',
          style: AppTextStyles.h2.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '••••••',
          style: AppTextStyles.numDisplay.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class _QuickAction extends StatefulWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.gradient,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  // Two-stop gradient painted on the tile; the first colour also tints the
  // drop shadow for a polished, cohesive look.
  final List<Color> gradient;

  @override
  State<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<_QuickAction> {
  double _scale = 1.0;

  void _setScale(double s) {
    if (_scale != s) setState(() => _scale = s);
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = dark ? AppColorsDark.text2 : AppColors.text2;

    return GestureDetector(
      onTapDown: (_) => _setScale(0.95),
      onTapUp: (_) {
        _setScale(1.0);
        HapticFeedback.lightImpact();
        widget.onPressed();
      },
      onTapCancel: () => _setScale(1.0),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.gradient,
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient.first.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(widget.icon, size: 24, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: labelColor),
            ),
          ],
        ),
      ),
    );
  }
}

