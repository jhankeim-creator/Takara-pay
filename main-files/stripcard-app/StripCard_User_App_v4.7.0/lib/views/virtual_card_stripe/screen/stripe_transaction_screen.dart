import 'package:intl/intl.dart';

import "package:stripcard/views/virtual_card_stripe/controller/stripe_transaction_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_shimmer.dart";
import "package:stripcard/base/widgets/design_system/sc_transaction_row.dart";

class StripeTransactionHistoryScreen extends StatelessWidget {
  StripeTransactionHistoryScreen({super.key});
  final controller = Get.put(StripeTransactionController());

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

  Widget _bodyWidget(BuildContext context) {
    var data = controller.stripeCardTransactionsModel.data.cardTransactions;

    return data.isNotEmpty
        ? RefreshIndicator(
            color: AppColors.accent,
            backgroundColor: AppColors.surface,
            onRefresh: () async {
              controller.getCardTransactionHistory();
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (_, __) => const Divider(
                height: 0.5,
                thickness: 0.5,
                color: AppColors.line,
              ),
              itemBuilder: (context, index) {
                final dateText = DateFormat.M().format(data[index].date);
                final monthText = DateFormat.MMMM().format(data[index].date);
                return SCTransactionRow(
                  title: '${'Trx'} ${data[index].trx}',
                  subtitle: '${data[index].status} · $monthText $dateText',
                  amountText: '${data[index].amount}',
                  isCredit: false,
                );
              },
            ),
          )
        : Center(
            child: Text(
              Strings.noRecordFound,
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.copyWith(color: AppColors.text2),
            ),
          );
  }
}
