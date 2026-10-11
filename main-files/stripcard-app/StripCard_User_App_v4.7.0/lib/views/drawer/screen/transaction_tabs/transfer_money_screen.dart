import 'package:intl/intl.dart';
import "package:TAKARA PAY/views/drawer/controller/transaction_controller.dart";
import "package:TAKARA PAY/base/api/model/others/transaction_model.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_transaction_row.dart";

class SendMoneyLogScreen extends StatelessWidget {
  const SendMoneyLogScreen({Key? key, required this.controller})
      : super(key: key);
  final TransactionController controller;

  @override
  Widget build(BuildContext context) {
    var data = controller.transactioData.data!.transactions!.sendMoney;
    if (data == null || data.isEmpty) {
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
      padding: const EdgeInsets.fromLTRB(6, 12, 6, 24),
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        thickness: 1,
        color: AppColors.line2,
      ),
      itemCount: data.length,
      itemBuilder: (_, i) => _mainListWidget(i, data, context),
    );
  }

  Widget _mainListWidget(int index, List<SendMoney> data, BuildContext context) {
    final item = data[index];
    return SCTransactionRow(
      title: item.transactionType!,
      subtitle:
          '${DateFormat.MMM().format(item.dateTime!)} ${DateFormat.d().format(item.dateTime!)} · ${item.trx!}',
      amountText: item.requestAmount.toString(),
      isCredit: false,
    );
  }
}
