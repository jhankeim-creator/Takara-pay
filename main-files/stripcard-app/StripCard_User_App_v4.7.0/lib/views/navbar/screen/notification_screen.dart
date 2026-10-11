import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import "package:stripcard/views/navbar/controller/dashboard_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/widgets/design_system/sc_shimmer.dart";

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final dashBoardController = Get.put(DashBoardController());

  Future<void> _onRefresh() async {
    await dashBoardController.getDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? AppColorsDark.bg : AppColors.bg;
    final text = dark ? AppColorsDark.text : AppColors.text;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        // No leading on the tab variant — the notification screen lives
        // inside the bottom-nav shell (Activity tab). When accessed via a
        // direct route (Get.toNamed), Navigator.canPop will be true and a
        // back arrow appears.
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: text),
                onPressed: Get.back,
              )
            : null,
        automaticallyImplyLeading: Navigator.canPop(context),
        centerTitle: false,
        title: Text(
          Get.find<LanguageController>()
              .getTranslation(Strings.notificationsTitle),
          style: AppTextStyles.h2.copyWith(color: text),
        ),
        // No "Mark all read" — Transaction model has no read state.
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          if (dashBoardController.isLoading &&
              !dashBoardController.hasLoadedOnce.value) {
            return const SCListSkeleton();
          }
          return RefreshIndicator(
            color: dark ? AppColorsDark.accent : AppColors.accent,
            backgroundColor: dark ? AppColorsDark.surface : AppColors.surface,
            onRefresh: _onRefresh,
            child: _buildBody(context, dark),
          );
        }),
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool dark) {
    List transactions = const [];
    String currency = 'USD';
    try {
      final data = dashBoardController.dashBoardModel.data;
      transactions = data.transactions;
      if (data.userWallet.isNotEmpty) {
        currency = data.userWallet.first.currency.code;
      }
    } catch (_) {
      // Model not loaded yet — fall through to empty list.
    }

    if (transactions.isEmpty) {
      return _buildEmptyState(dark);
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _NotificationRow(
        notification: transactions[i],
        currency: currency,
      ),
    );
  }

  Widget _buildEmptyState(bool dark) {
    final surface2 = dark ? AppColorsDark.surface2 : AppColors.surface2;
    final text = dark ? AppColorsDark.text : AppColors.text;
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;

    return ListView(
      // ListView (not Center) so RefreshIndicator can pull-to-refresh on
      // an empty screen.
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(40, 80, 40, 100),
      children: [
        Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: surface2,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            size: 28,
            color: text3,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          Get.find<LanguageController>()
              .getTranslation(Strings.noNotificationsYet),
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMed.copyWith(color: text),
        ),
        const SizedBox(height: 4),
        Text(
          Get.find<LanguageController>()
              .getTranslation(Strings.notificationsEmptySubtitle),
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: text2),
        ),
      ],
    );
  }
}

// ───────────────────────── Sub-widgets ──────────────────────────────────

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.notification,
    required this.currency,
  });

  final dynamic notification;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColorsDark.surface : AppColors.surface;
    final line2 = dark ? AppColorsDark.line2 : AppColors.line2;
    final text = dark ? AppColorsDark.text : AppColors.text;
    final text2 = dark ? AppColorsDark.text2 : AppColors.text2;
    final text3 = dark ? AppColorsDark.text3 : AppColors.text3;

    final type = notification.transactionType.toString();
    final amount = notification.requestAmount.toString();
    final ref = notification.trx.toString();
    final remark = notification.remark.toString();
    final dt = notification.dateTime as DateTime;
    final radius = BorderRadius.circular(AppRadius.lg);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: () {
          HapticFeedback.selectionClick();
          Get.toNamed(Routes.transactionLogScreen);
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: radius,
            border: Border.all(color: line2, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _toneBg(type, dark),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  _iconFor(type),
                  size: 20,
                  color: _toneFg(type, dark),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            _titleFor(type, amount, currency),
                            style: AppTextStyles.bodyMed.copyWith(
                              color: text,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _relativeTime(dt),
                          style: AppTextStyles.caption.copyWith(
                            color: text3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _subtitleFor(remark, ref),
                      style: AppTextStyles.caption.copyWith(color: text2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // No unread dot — Transaction model has no read state.
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Helpers ──────────────────────────────────────

IconData _iconFor(String? type) {
  final t = (type ?? '').toUpperCase();
  if (t.contains('GIFT')) return Icons.card_giftcard_outlined;
  if (t.contains('ADD') || t.contains('DEPOSIT')) {
    return Icons.arrow_downward_rounded;
  }
  if (t.contains('WITHDRAW')) return Icons.arrow_upward_rounded;
  if (t.contains('TRANSFER') || t.contains('SEND')) {
    return Icons.swap_horiz_rounded;
  }
  if (t.contains('CARD')) return Icons.credit_card_outlined;
  if (t.contains('SECURITY') || t.contains('LOGIN')) {
    return Icons.shield_outlined;
  }
  if (t.contains('KYC') || t.contains('VERIFY')) {
    return Icons.verified_user_outlined;
  }
  return Icons.notifications_outlined;
}

Color _toneBg(String? type, bool dark) {
  final t = (type ?? '').toUpperCase();
  if (t.contains('SECURITY') || t.contains('LOGIN')) {
    return dark ? AppColorsDark.dangerSoft : AppColors.dangerSoft;
  }
  if (t.contains('ADD') || t.contains('DEPOSIT') || t.contains('GIFT')) {
    return dark ? AppColorsDark.accentSoft : AppColors.accentSoft;
  }
  if (t.contains('WITHDRAW')) {
    return dark ? AppColorsDark.warnSoft : AppColors.warnSoft;
  }
  return dark ? AppColorsDark.surface2 : AppColors.surface2;
}

Color _toneFg(String? type, bool dark) {
  final t = (type ?? '').toUpperCase();
  if (t.contains('SECURITY') || t.contains('LOGIN')) {
    return dark ? AppColorsDark.danger : AppColors.danger;
  }
  if (t.contains('ADD') || t.contains('DEPOSIT') || t.contains('GIFT')) {
    return dark ? AppColorsDark.accent : AppColors.accent;
  }
  if (t.contains('WITHDRAW')) {
    return dark ? AppColorsDark.warn : AppColors.warn;
  }
  return dark ? AppColorsDark.text : AppColors.text;
}

String _titleFor(String type, String amount, String currency) {
  final t = type.toUpperCase();
  if (t.contains('ADD') || t.contains('DEPOSIT')) {
    return '$amount $currency added to your wallet';
  }
  if (t.contains('WITHDRAW')) {
    return '$amount $currency withdrawal initiated';
  }
  if (t.contains('GIFT')) {
    return 'Gift card created · $amount $currency';
  }
  if (t.contains('TRANSFER') || t.contains('SEND')) {
    return 'Transfer of $amount $currency';
  }
  if (t.contains('CARD')) {
    return 'Virtual card update';
  }
  if (t.contains('SECURITY') || t.contains('LOGIN')) {
    return 'New sign-in to your account';
  }
  return _humanize(t);
}

String _subtitleFor(String remark, String ref) {
  if (remark.isNotEmpty) return remark;
  if (ref.isNotEmpty) return 'Ref: $ref';
  return '';
}

String _humanize(String raw) {
  if (raw.isEmpty) return raw;
  final parts = raw.toLowerCase().split(RegExp(r'[-_\s]+'));
  if (parts.isEmpty) return raw;
  return parts.first[0].toUpperCase() +
      parts.first.substring(1) +
      (parts.length > 1 ? ' ${parts.skip(1).join(' ')}' : '');
}

String _relativeTime(DateTime t) {
  final now = DateTime.now();
  final diff = now.difference(t);
  if (diff.inMinutes < 1) return 'now';
  if (diff.inHours < 1) return '${diff.inMinutes}m';
  if (diff.inDays < 1) return '${diff.inHours}h';
  if (diff.inDays < 7) return '${diff.inDays}d';
  return DateFormat('MMM d').format(t);
}
