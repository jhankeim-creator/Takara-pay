import "package:stripcard/base/utils/basic_screen_import.dart";

import "package:stripcard/views/money_transfer/controller/money_transfer_controller.dart";
import "package:stripcard/views/money_transfer/controller/money_transfer_info_controller.dart";
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_spacing.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_shimmer.dart";

class MoneyTransferPreviewScreen extends StatelessWidget {
  MoneyTransferPreviewScreen({super.key});

  final controller = Get.put(MoneyTransferController());
  final infoController = Get.put(MoneyTransferInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Obx(() {
          if (infoController.isLoading) {
            return const SCDetailSkeleton(showHero: false);
          }
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSpacing.xl),
                      _buildAmountHeadline(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildSectionHeader(
                        Get.find<LanguageController>()
                            .getTranslation(Strings.toLabel),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildRecipientCard(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildSectionHeader(
                        Get.find<LanguageController>()
                            .getTranslation(Strings.breakdownLabel),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildBreakdownCard(),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
              _buildConfirmBar(context),
            ],
          );
        }),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.text),
        onPressed: Get.back,
      ),
      title: Text(
        Get.find<LanguageController>().getTranslation(Strings.confirmTransfer),
        style: AppTextStyles.h2.copyWith(color: AppColors.text),
      ),
      centerTitle: true,
    );
  }

  Widget _buildAmountHeadline() {
    final amount = double.tryParse(controller.amountController.text) ?? 0;
    final fmt = amount.toStringAsFixed(2);
    final parts = fmt.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? '.${parts[1]}' : '.00';

    return Column(
      children: [
        Text(
          Get.find<LanguageController>().getTranslation(Strings.sendingLabel),
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                r'$',
                style: AppTextStyles.numLg.copyWith(color: AppColors.text2),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              intPart,
              style: AppTextStyles.numDisplay.copyWith(color: AppColors.text),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                decPart,
                style: AppTextStyles.numLg.copyWith(color: AppColors.text2),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt_rounded, color: AppColors.accent, size: 16),
            const SizedBox(width: 4),
            Text(
              Get.find<LanguageController>()
                  .getTranslation(Strings.instantTransfer),
              style: AppTextStyles.label.copyWith(color: AppColors.text2),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    );
  }

  Widget _buildRecipientCard() {
    final email = controller.receiverEmailController.text.trim();
    final verified = controller.verifiedUser.value;
    final displayName =
        (verified != null && verified.fullName.isNotEmpty)
            ? verified.fullName
            : (email.isEmpty
                ? Get.find<LanguageController>()
                    .getTranslation(Strings.recipientLabel)
                : email);
    final initials = _initialsFromEmail(email);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.surface2,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style:
                      AppTextStyles.bodyMed.copyWith(color: AppColors.text),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  email.isEmpty
                      ? Get.find<LanguageController>()
                          .getTranslation(Strings.stripCardUser)
                      : email,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initialsFromEmail(String email) {
    if (email.isEmpty) return '?';
    final localPart = email.split('@').first;
    if (localPart.isEmpty) return '?';
    return localPart
        .substring(0, localPart.length.clamp(0, 2))
        .toUpperCase();
  }

  Widget _buildBreakdownCard() {
    final amount = double.tryParse(controller.amountController.text) ?? 0;
    final fee = _resolveFee(amount);
    final total = amount + fee;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          _breakdownRow(
            Get.find<LanguageController>().getTranslation(Strings.amount),
            '\$${amount.toStringAsFixed(2)}',
          ),
          _divider(),
          _breakdownRow(
            Get.find<LanguageController>().getTranslation(Strings.fee),
            '\$${fee.toStringAsFixed(2)}',
          ),
          _divider(),
          _breakdownRow(
            Get.find<LanguageController>()
                .getTranslation(Strings.totalDeducted),
            '\$${total.toStringAsFixed(2)}',
            emphasized: true,
          ),
        ],
      ),
    );
  }

  /// Mirrors MoneyTransferController._resolveFee — read fee from the info
  /// model with a try/catch fallback so a failed /info fetch doesn't crash
  /// the preview render. The info model is `late` on its own controller and
  /// would throw LateInitializationError on access if uninitialized.
  double _resolveFee(double amount) {
    try {
      final charge =
          infoController.transferMoneyInfoModel.data.transferMoneyCharge;
      final fixed = (charge.fixedCharge as num).toDouble();
      final percent = (charge.percentCharge as num).toDouble();
      return fixed + (amount * percent / 100);
    } catch (_) {
      return 0.0;
    }
  }

  Widget _breakdownRow(
    String label,
    String value, {
    bool emphasized = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: emphasized
                  ? AppTextStyles.bodyMed.copyWith(color: AppColors.text)
                  : AppTextStyles.label.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.numSm.copyWith(
              color: AppColors.text,
              fontWeight: emphasized ? FontWeight.w600 : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      color: AppColors.line2,
    );
  }

  Widget _buildConfirmBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(
          top: BorderSide(color: AppColors.line2, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => SCPrimaryButton(
              label: controller.isConfirmLoading
                  ? Get.find<LanguageController>()
                      .getTranslation(Strings.sendingEllipsis)
                  : Get.find<LanguageController>()
                      .getTranslation(Strings.confirmTransfer),
              loading: controller.isConfirmLoading,
              onPressed: controller.isConfirmLoading
                  ? null
                  : () => controller.transferMoneyConfirmProcess(context),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: Get.back,
            style: TextButton.styleFrom(foregroundColor: AppColors.text2),
            child: Text(
              Get.find<LanguageController>()
                  .getTranslation(Strings.sendToDifferentPerson),
              style:
                  AppTextStyles.bodyMed.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}
