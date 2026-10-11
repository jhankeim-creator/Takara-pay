import 'package:shimmer/shimmer.dart';
import "package:stripcard/views/remaining_balance/controller/remaing_balance_controller.dart";
import "package:stripcard/base/utils/language/language_controller.dart";

import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";

/// Limit information card — redesigned to match the app's design system
/// (surface card + design tokens) instead of the old purple block. Labels are
/// resolved through the language controller so they show the translated value.
class LimitInformationWidget extends StatelessWidget {
  LimitInformationWidget({
    super.key,
    this.transactionLimit,
    required this.dailyLimit,
    required this.remainingDailyLimit,
    required this.monthlyLimit,
    required this.remainingMonthLimit,
    this.showDailyLimit = true,
    this.showMonthlyLimit = true,
  });

  final String? transactionLimit;
  final String dailyLimit;
  final String remainingDailyLimit;
  final String monthlyLimit;
  final String remainingMonthLimit;
  final bool showDailyLimit;
  final bool showMonthlyLimit;

  final controller = Get.put(RemainingBalanceController());

  String _t(String key) =>
      Get.find<LanguageController>().getTranslation(key);

  @override
  Widget build(BuildContext context) {
    final hasTxnLimit =
        transactionLimit != null && transactionLimit!.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line2, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.speed_rounded, size: 16, color: AppColors.text3),
              const SizedBox(width: 8),
              Text(
                _t(Strings.limitInformation),
                style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
              ),
            ],
          ),
          if (showDailyLimit) ...[
            const SizedBox(height: 14),
            _row(
              leftLabel: _t(Strings.dailyLimit),
              leftValue: _staticValue(dailyLimit),
              rightLabel: _t(Strings.remainingDailyLimit),
              rightValue: _reactiveValue(remainingDailyLimit),
            ),
          ],
          if (showMonthlyLimit) ...[
            const SizedBox(height: 12),
            _divider(),
            const SizedBox(height: 12),
            _row(
              leftLabel: _t(Strings.monthlyLimit),
              leftValue: _staticValue(monthlyLimit),
              rightLabel: _t(Strings.remainingMonthlyLimit),
              rightValue: _reactiveValue(remainingMonthLimit),
            ),
          ],
          if (hasTxnLimit) ...[
            const SizedBox(height: 12),
            _divider(),
            const SizedBox(height: 12),
            _cell(
              label: _t(Strings.transactionLimit),
              value: _staticValue(transactionLimit!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row({
    required String leftLabel,
    required Widget leftValue,
    required String rightLabel,
    required Widget rightValue,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _cell(label: leftLabel, value: leftValue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _cell(
            label: rightLabel,
            value: rightValue,
            align: CrossAxisAlignment.end,
          ),
        ),
      ],
    );
  }

  Widget _cell({
    required String label,
    required Widget value,
    CrossAxisAlignment align = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        value,
      ],
    );
  }

  Widget _staticValue(String text) => Text(
        text,
        style: AppTextStyles.numMd.copyWith(color: AppColors.text),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  // The "remaining" figures are fetched separately — show a shimmer while the
  // remaining-balance controller is still loading them.
  Widget _reactiveValue(String text) => Obx(
        () => controller.isLoading
            ? Shimmer.fromColors(
                baseColor: AppColors.surface2,
                highlightColor: AppColors.line,
                child: Container(
                  width: 56,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              )
            : _staticValue(text),
      );

  Widget _divider() => Container(height: 1, color: AppColors.line2);
}
