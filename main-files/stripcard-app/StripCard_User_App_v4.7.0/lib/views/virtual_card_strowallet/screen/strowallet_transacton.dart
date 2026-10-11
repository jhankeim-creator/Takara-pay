import 'package:intl/intl.dart';
import "package:stripcard/base/utils/custom_loading_api.dart";
import "package:stripcard/views/virtual_card_strowallet/controller/strowallet_transaction_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_shimmer.dart";
import "package:stripcard/base/widgets/design_system/sc_transaction_row.dart";

class StrowalletTransactionHistoryScreen extends StatelessWidget {
  StrowalletTransactionHistoryScreen({super.key});
  final controller = Get.put(StrowalletTransactionController());

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
    var data = controller.strowalletCardTransactionsModel.data.cardTransactions;
    return data.isNotEmpty
        ? RefreshIndicator(
            color: AppColors.accent,
            onRefresh: () async {
              controller.getCardTransactionHistory();
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 0.5,
                color: AppColors.line2,
              ),
              itemBuilder: (context, index) {
                final status = '${data[index].status}'.toLowerCase();
                final isCredit = status.contains('success') ||
                    status.contains('approved') ||
                    status.contains('credit') ||
                    status.contains('completed');
                return SCTransactionRow(
                  title: '${'Trx'} ${data[index].cardId}',
                  subtitle:
                      '${DateFormat.MMM().format(data[index].createdAt)} ${DateFormat.M().format(data[index].tracreatedAt)} · ${data[index].status}',
                  amountText: '${data[index].amount!} ${data[index].currency!}',
                  isCredit: isCredit,
                );
              },
            ),
          )
        : Center(
            child: Text(
              Strings.noRecordFound,
              style: AppTextStyles.body.copyWith(color: AppColors.text2),
            ),
          );
  }
}
