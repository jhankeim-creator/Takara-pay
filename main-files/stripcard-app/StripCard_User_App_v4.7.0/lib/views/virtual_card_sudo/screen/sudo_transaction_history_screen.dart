import 'package:intl/intl.dart';

import "package:stripcard/views/virtual_card_sudo/controller/sudo_transaction_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_shimmer.dart";
import "package:stripcard/base/widgets/design_system/sc_surface_card.dart";
import "package:stripcard/base/widgets/design_system/sc_transaction_row.dart";

class SudoTransactionHistoryScreen extends StatelessWidget {
  SudoTransactionHistoryScreen({super.key});
  final controller = Get.put(SudoTransactionController());

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
    var data = controller.cardTransactionsModel.data.cardTransactions.data;

    return data.isNotEmpty
        ? RefreshIndicator(
            color: AppColors.accent,
            backgroundColor: AppColors.surface,
            onRefresh: () async {
              controller.getCardTransactionHistory();
            },
            child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final isCredit = data[index].status
                      .toString()
                      .toLowerCase()
                      .contains('success');
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SCSurfaceCard(
                      padding: EdgeInsets.zero,
                      child: SCTransactionRow(
                        title: '${'Trx'} ${data[index].trx}',
                        subtitle:
                            '${DateFormat.MMM().format(data[index].date)} ${DateFormat.d().format(data[index].date)} · ${data[index].status}',
                        amountText: data[index].amount.toString(),
                        isCredit: isCredit,
                      ),
                    ),
                  );
                }),
          )
        : _emptyState();
  }

  Widget _emptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        SizedBox(height: 0.3.sh),
        Column(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 28,
                color: AppColors.text3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              Strings.noRecordFound,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMed.copyWith(color: AppColors.text2),
            ),
          ],
        ),
      ],
    );
  }
}
