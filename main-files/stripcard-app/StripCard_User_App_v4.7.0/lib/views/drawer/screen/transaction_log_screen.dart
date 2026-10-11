import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/api/model/others/transaction_model.dart";
import "package:TAKARA PAY/views/drawer/controller/transaction_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_chip.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_shimmer.dart";

/// A single, unified transaction-log entry built from any of the four
/// transaction types. The screen merges all of them into one date-sorted
/// list so the user no longer has to switch tabs to see everything; tapping
/// a row reveals the full per-type details.
class _TxEntry {
  final String title;
  final String trx;
  final String amount;
  final String status;
  final DateTime? date;
  final bool isCredit;
  final int filterIndex; // 0 add money, 1 transfer, 2 card, 3 balance
  final List<_Detail> details;

  _TxEntry({
    required this.title,
    required this.trx,
    required this.amount,
    required this.status,
    required this.date,
    required this.isCredit,
    required this.filterIndex,
    required this.details,
  });
}

class _Detail {
  final String label;
  final String value;
  final bool mono;
  final bool copyable;
  const _Detail(this.label, this.value,
      {this.mono = false, this.copyable = false});
}

class TransactionLogScreen extends StatelessWidget {
  TransactionLogScreen({super.key});

  final controller = Get.put(TransactionController());

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
          Get.find<LanguageController>().getTranslation(Strings.transactionLog),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Obx(
          () => controller.isLoading
              ? const SCListSkeleton()
              : _bodyWidget(),
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    final entries = _buildEntries();

    if (entries.isEmpty) {
      return Center(
        child: Text(
          Strings.noRecordFound,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text3),
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        thickness: 1,
        color: AppColors.line2,
      ),
      itemCount: entries.length,
      itemBuilder: (_, i) => _row(entries[i]),
    );
  }

  // ── Merge all four transaction types into one sorted list ────────────────
  List<_TxEntry> _buildEntries() {
    Data? data;
    try {
      data = controller.transactioData.data;
    } catch (_) {
      return [];
    }
    final tx = data?.transactions;
    if (tx == null) return [];

    final entries = <_TxEntry>[];

    String? clean(String? v) => (v == null || v.trim().isEmpty) ? null : v;
    void add(List<_Detail> sink, String label, String? value,
        {bool mono = false, bool copyable = false}) {
      final v = clean(value);
      if (v != null) {
        sink.add(_Detail(label, v, mono: mono, copyable: copyable));
      }
    }

    for (final m in (tx.addMoney ?? <AddMoney>[])) {
      final d = <_Detail>[];
      add(d, Get.find<LanguageController>().getTranslation(Strings.trxID), m.trx, mono: true, copyable: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.amount), m.requestAmount, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.charge), m.totalCharge, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.totalPayable), m.payable, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.currentBalance), m.currentBalance, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.cardNumber), m.cardNumber, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.reason), m.rejectionReason);
      add(d, Get.find<LanguageController>().getTranslation(Strings.status), m.status);
      entries.add(_TxEntry(
        title: clean(m.transactionHeading) ??
            clean(m.transactionType) ??
            Get.find<LanguageController>().getTranslation(Strings.addMoney),
        trx: m.trx ?? '',
        amount: m.requestAmount ?? '',
        status: m.status ?? '',
        date: m.dateTime,
        isCredit: true,
        filterIndex: 0,
        details: d,
      ));
    }

    for (final m in (tx.sendMoney ?? <SendMoney>[])) {
      final d = <_Detail>[];
      add(d, Get.find<LanguageController>().getTranslation(Strings.trxID), m.trx, mono: true, copyable: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.amount), m.requestAmount, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.charge), m.totalCharge, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.totalPayable), m.payable, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.recipientReceived), m.recipientReceived, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.currentBalance), m.currentBalance, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.status), m.status);
      entries.add(_TxEntry(
        title: clean(m.transactionHeading) ??
            clean(m.transactionType) ??
            Get.find<LanguageController>().getTranslation(Strings.transferMoney),
        trx: m.trx ?? '',
        amount: m.requestAmount ?? '',
        status: m.status ?? '',
        date: m.dateTime,
        isCredit: false,
        filterIndex: 1,
        details: d,
      ));
    }

    for (final m in (tx.virtualCard ?? <VirtualCard>[])) {
      final d = <_Detail>[];
      add(d, Get.find<LanguageController>().getTranslation(Strings.trxID), m.trx, mono: true, copyable: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.amount), m.requestAmount, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.charge), m.totalCharge, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.totalPayable), m.payable, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.cardNumber), m.cardNumber, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.currentBalance), m.currentBalance, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.status), m.status);
      entries.add(_TxEntry(
        title: clean(m.transactionType) ?? Get.find<LanguageController>().getTranslation(Strings.virtualCard),
        trx: m.trx ?? '',
        amount: m.payable ?? '',
        status: m.status ?? '',
        date: m.dateTime,
        isCredit: false,
        filterIndex: 2,
        details: d,
      ));
    }

    for (final m in (tx.addSubBalance ?? <AddSubBalance>[])) {
      final d = <_Detail>[];
      add(d, Get.find<LanguageController>().getTranslation(Strings.trxID), m.trx, mono: true, copyable: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.amount), m.receiveAmount, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.charge), m.totalCharge, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.currentBalance), m.currentBalance, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.reason), m.remark);
      add(d, Get.find<LanguageController>().getTranslation(Strings.status), m.status);
      final isCredit = (m.transactionType ?? '').toLowerCase().contains('add') ||
          !(m.transactionType ?? '').toLowerCase().contains('sub');
      entries.add(_TxEntry(
        title: clean(m.transactionHeading) ??
            clean(m.transactionType) ??
            Get.find<LanguageController>().getTranslation(Strings.addSubtractBalance),
        trx: m.trx ?? '',
        amount: m.receiveAmount ?? '',
        status: m.status ?? '',
        date: m.dateTime,
        isCredit: isCredit,
        filterIndex: 3,
        details: d,
      ));
    }

    for (final m in (tx.giftCards ?? <AddMoney>[])) {
      final d = <_Detail>[];
      add(d, Get.find<LanguageController>().getTranslation(Strings.trxID), m.trx, mono: true, copyable: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.amount), m.requestAmount, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.charge), m.totalCharge, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.totalPayable), m.payable, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.currentBalance), m.currentBalance, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.status), m.status);
      entries.add(_TxEntry(
        title: clean(m.transactionHeading) ??
            clean(m.transactionType) ??
            'Gift card',
        trx: m.trx ?? '',
        amount: m.payable ?? m.requestAmount ?? '',
        status: m.status ?? '',
        date: m.dateTime,
        isCredit: false,
        filterIndex: 4,
        details: d,
      ));
    }

    for (final m in (tx.withdrawMoney ?? <AddMoney>[])) {
      final d = <_Detail>[];
      add(d, Get.find<LanguageController>().getTranslation(Strings.trxID), m.trx, mono: true, copyable: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.amount), m.requestAmount, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.charge), m.totalCharge, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.totalPayable), m.payable, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.currentBalance), m.currentBalance, mono: true);
      add(d, Get.find<LanguageController>().getTranslation(Strings.status), m.status);
      entries.add(_TxEntry(
        title: clean(m.transactionHeading) ??
            clean(m.transactionType) ??
            Get.find<LanguageController>().getTranslation(Strings.withdraw),
        trx: m.trx ?? '',
        amount: m.requestAmount ?? m.payable ?? '',
        status: m.status ?? '',
        date: m.dateTime,
        isCredit: false,
        filterIndex: 5,
        details: d,
      ));
    }

    // Newest first; entries without a date sink to the bottom.
    entries.sort((a, b) {
      if (a.date == null && b.date == null) return 0;
      if (a.date == null) return 1;
      if (b.date == null) return -1;
      return b.date!.compareTo(a.date!);
    });
    return entries;
  }

  // ── Row ──────────────────────────────────────────────────────────────────
  Widget _row(_TxEntry e) {
    final subtitle = e.date != null
        ? '${DateFormat.MMM().format(e.date!)} ${DateFormat.d().format(e.date!)} · ${e.trx}'
        : e.trx;

    return InkWell(
      onTap: () => _showDetails(e),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: e.isCredit ? AppColors.accentSoft : AppColors.surface2,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                e.isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                size: 18,
                color: e.isCredit ? AppColors.accent : AppColors.text2,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    e.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppTextStyles.caption.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  e.amount,
                  style: AppTextStyles.numMd.copyWith(
                    color: e.isCredit ? AppColors.accent : AppColors.text,
                  ),
                ),
                if (e.status.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  _statusPill(e.status),
                ],
              ],
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.text3),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('success') || s.contains('complete') || s.contains('approve')) {
      return AppColors.accent;
    }
    if (s.contains('pending') || s.contains('process')) return AppColors.warn;
    if (s.contains('reject') || s.contains('fail') || s.contains('cancel')) {
      return AppColors.danger;
    }
    return AppColors.text3;
  }

  Widget _statusPill(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        status,
        style: AppTextStyles.micro.copyWith(color: color),
      ),
    );
  }

  // ── Details bottom sheet ─────────────────────────────────────────────────
  void _showDetails(_TxEntry e) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.8),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      e.title,
                      style: AppTextStyles.h2.copyWith(color: AppColors.text),
                    ),
                  ),
                  if (e.status.isNotEmpty) _statusPill(e.status),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                itemCount: e.details.length,
                itemBuilder: (_, i) => _detailRow(
                  e.details[i],
                  isLast: i == e.details.length - 1,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _detailRow(_Detail d, {required bool isLast}) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: AppColors.line2, width: 1),
              ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              d.label,
              style: AppTextStyles.label.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    d.value,
                    textAlign: TextAlign.end,
                    style: d.mono
                        ? AppTextStyles.numSm.copyWith(color: AppColors.text)
                        : AppTextStyles.bodyMed.copyWith(color: AppColors.text),
                  ),
                ),
                if (d.copyable) ...[
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: d.value));
                      Get.snackbar(
                        '',
                        Get.find<LanguageController>().getTranslation(Strings.addressCopyTo),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.text,
                        colorText: AppColors.bg,
                        margin: const EdgeInsets.all(12),
                        borderRadius: 12,
                        titleText: const SizedBox.shrink(),
                        duration: const Duration(seconds: 2),
                      );
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(Icons.copy_rounded,
                          size: 15, color: AppColors.text3),
                    ),
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
