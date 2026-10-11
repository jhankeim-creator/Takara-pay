import 'package:intl/intl.dart';
import "package:TAKARA PAY/views/virtual_card_cardyfie/controller/cardyfie_transaction_log_controller.dart"
    show CardyfieTransactionLogController;

import "package:TAKARA PAY/base/utils/custom_loading_api.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/bottom_navbar/transaction_history_widget.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_shimmer.dart";

part '../cardyfie_transaction/widget/card_transactions_widget.dart';

class CardyfieTransactionLogScreen extends StatelessWidget {
  CardyfieTransactionLogScreen({super.key});
  final controller = Get.put(CardyfieTransactionLogController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
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
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    var data = controller.cardTransactionModelCardyfie.data.cardTransactions;
    return data.isNotEmpty
        ? RefreshIndicator(
            color: AppColors.accent,
            onRefresh: () async {
              controller.getCardTransactionHistory();
            },
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return CardyfieExpandableWidget(
                  amount:
                      '${double.parse(data[index].enterAmount).toStringAsFixed(2)} ${data[index].cardCurrency}',
                  title: data[index].trxType,
                  dateText: DateFormat(
                    'MMM dd, yyyy',
                  ).format(data[index].createdAt),
                  transaction: data[index].ulid,
                  monthText: DateFormat.MMM().format(data[index].createdAt),
                  status: data[index].status, // ✅ New field
                  amountType: data[index].amountType, // ✅ New field
                );
              },
            ),
          )
        : Center(
            child: Text(
              Strings.noRecordFound,
              style: AppTextStyles.body.copyWith(color: AppColors.text3),
            ),
          );
  }
}
