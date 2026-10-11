import 'package:intl/intl.dart';

import "package:stripcard/views/virtual_card_flutterwave/controller/transaction_history_conntroller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_shimmer.dart";
import "package:stripcard/base/widgets/design_system/sc_transaction_row.dart";

class TransactionHistoryScreen extends StatelessWidget {
  TransactionHistoryScreen({super.key});
  final controller = Get.put(TransactionHistoryController());

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
          Strings.transactionHistory,
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading
              ? const SCListSkeleton()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    var data = controller.cardTransactionsModel.data.cardTransactions;

    if (data.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            Strings.noRecordFound,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.accent,
      backgroundColor: AppColors.surface,
      onRefresh: () async {
        controller.getCardTransactionHistory();
      },
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: data.length,
        separatorBuilder: (_, __) => const Divider(
          height: 0.5,
          thickness: 0.5,
          color: AppColors.line,
        ),
        itemBuilder: (context, index) {
          final txn = data[index];
          final isCredit = txn.status.toLowerCase() == 'success' ||
              txn.status.toLowerCase() == 'approved' ||
              txn.status.toLowerCase() == 'completed';
          return SCTransactionRow(
            title: 'Trx ${txn.trx}',
            subtitle:
                '${DateFormat.MMMd().format(txn.date)} · ${txn.status}',
            amountText: txn.amount,
            isCredit: isCredit,
          );
        },
      ),
    );
  }
}
