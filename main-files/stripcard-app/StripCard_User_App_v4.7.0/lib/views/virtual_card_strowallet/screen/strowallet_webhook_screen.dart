import 'package:intl/intl.dart';
import "package:TAKARA PAY/base/utils/language/language_controller.dart";

import "package:TAKARA PAY/base/api/model/virtual_card/strowallet_models/strowallet_webhook_model.dart";
import "package:TAKARA PAY/base/utils/custom_loading_api.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/controller/strowallet_webhook_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

class WebhookLogsScreen extends StatelessWidget {
  WebhookLogsScreen({super.key});
  final controller = Get.put(StrowalletWebhookController());

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
          Strings.webhookLogs,
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Obx(() => controller.isLoading
            ? const CustomLoadingAPI()
            : _bodyWidget(context)),
      ),
    );
  }

  _mainListWidget(int i, List<Transaction> data, BuildContext context) {
    RxBool isExpansion = false.obs;
    final status = data[i].status.toLowerCase();
    final isCredit = status.contains('success') ||
        status.contains('approved') ||
        status.contains('completed');
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line2, width: 1),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            onTap: () {
              isExpansion.value = !isExpansion.value;
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data[i].event,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMed
                              .copyWith(color: AppColors.text),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          data[i].transitionId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.text3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    data[i].amount,
                    style: AppTextStyles.numMd.copyWith(
                      color: isCredit ? AppColors.accent : AppColors.text,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() => Icon(
                        isExpansion.value
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: AppColors.text3,
                      )),
                ],
              ),
            ),
          ),
          Obx(() => Visibility(
                visible: isExpansion.value,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                  child: Column(
                    children: [
                      const Divider(
                          height: 1, thickness: 0.5, color: AppColors.line2),
                      _ExpandedItem(
                        title: Get.find<LanguageController>().getTranslation(Strings.transactionId),
                        value: data[i].transitionId,
                      ),
                      _ExpandedItem(
                        title: Get.find<LanguageController>().getTranslation(Strings.cardId),
                        value: data[i].cardId,
                      ),
                      _ExpandedItem(
                        title: Get.find<LanguageController>().getTranslation(Strings.reference),
                        value: data[i].reference,
                      ),
                      if (data[i].eventType ==
                              'virtualcard.transaction.declined' ||
                          data[i].eventType ==
                              'virtualcard.transaction.crossborder') ...[
                        _ExpandedItem(
                          title: Get.find<LanguageController>().getTranslation(Strings.narration),
                          value: data[i].narrative!,
                        ),
                      ],
                      if (data[i].eventType ==
                          'virtualcard.transaction.declined') ...[
                        _ExpandedItem(
                          title: Get.find<LanguageController>().getTranslation(Strings.reason),
                          value: data[i].reason!,
                        ),
                      ],
                      _ExpandedItem(
                        title: Get.find<LanguageController>().getTranslation(Strings.status),
                        value: data[i].status,
                      ),
                      if (data[i].eventType ==
                          'virtualcard.transaction.crossborder') ...[
                        _ExpandedItem(
                          title: Get.find<LanguageController>().getTranslation(Strings.chargedAmount),
                          value: data[i].chargeAmount!,
                        ),
                      ],
                      if (data[i].eventType ==
                          'virtualcard.transaction.declined.terminated') ...[
                        _ExpandedItem(
                          title: Get.find<LanguageController>().getTranslation(Strings.balanceBeforeTermination),
                          value: data[i].balanceBeforeTermination!,
                        ),
                      ],
                      if (data[i].eventType ==
                              'virtualcard.transaction.declined' ||
                          data[i].eventType ==
                              'virtualcard.transaction.crossborder') ...[
                        _ExpandedItem(
                          title: Get.find<LanguageController>().getTranslation(Strings.timeAndDate),
                          value: DateFormat("d-M-yy hh:mm:ss a").format(
                              DateTime.parse(data[i].createdAt!)),
                        ),
                      ]
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    var data = controller.webhookLogModel.data.transactions;
    return data.isNotEmpty
        ? ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            separatorBuilder: (_, index) => const SizedBox(height: 10),
            itemCount: data.length,
            itemBuilder: (_, i) {
              return _mainListWidget(i, data, context);
            },
          )
        : Center(
            child: Text(
              Strings.noRecordFound,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.text2),
            ),
          );
  }
}

class _ExpandedItem extends StatelessWidget {
  const _ExpandedItem({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}
