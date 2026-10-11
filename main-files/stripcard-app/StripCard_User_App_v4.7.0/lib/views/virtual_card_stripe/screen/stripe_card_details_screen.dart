import "package:TAKARA PAY/views/virtual_card_stripe/controller/stripe_details_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_section_header.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_shimmer.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_surface_card.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_virtual_card.dart";

class StripeCardDetailsScreen extends StatelessWidget {
  StripeCardDetailsScreen({super.key});
  final controller = Get.put(StripeCardDetailsController());

  get payload => null;

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
          Strings.details,
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading
              ? const SCDetailSkeleton(showHero: true)
              : _bodyWidget(context),
        ),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      physics: const BouncingScrollPhysics(),
      children: [
        _cardPreview(),
        const SizedBox(height: 24),
        const SCSectionHeader(label: 'CARD INFORMATION'),
        _cardDetailsWidget(context),
        const SizedBox(height: 20),
        const SCSectionHeader(label: 'CONTROLS'),
        _controlsWidget(context),
      ],
    );
  }

  Widget _cardPreview() {
    return Obx(() {
      final myCards = controller.cardDetailsModel.data.cardDetails;
      final reveal = controller.isShowSensitive.value;
      final pan = reveal ? controller.cardPlan.value : myCards.cardPan;
      final last4 = pan.length >= 4 ? pan.substring(pan.length - 4) : pan;
      return SCVirtualCard(
        cardName: myCards.cardHolder,
        last4: last4,
        expiry: '${myCards.expiryMonth}/${myCards.expiryYear}',
        frozen: !myCards.status,
      );
    });
  }

  Widget _cardDetailsWidget(BuildContext context) {
    return Obx(() {
      final myCards = controller.cardDetailsModel.data.cardDetails;
      final reveal = controller.isShowSensitive.value;

      return SCSurfaceCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _DetailRow(label: Strings.cardHolder, value: myCards.cardHolder),
            const _RowDivider(),
            _DetailRow(label: Strings.currency, value: myCards.currency),
            const _RowDivider(),
            _DetailRow(label: Strings.cardType, value: myCards.type),
            const _RowDivider(),
            _DetailRow(
              label: Strings.cardNumber,
              value: reveal ? controller.cardPlan.value : myCards.cardPan,
              mono: true,
            ),
            const _RowDivider(),
            _DetailRow(
              label: Strings.cvc,
              value: reveal ? controller.cardCVC.value : myCards.cvv,
              mono: true,
            ),
            const _RowDivider(),
            _DetailRow(
              label: Strings.expiration,
              value: "${myCards.expiryMonth}/${myCards.expiryYear}",
              mono: true,
            ),
            const _RowDivider(),
            _DetailRow(label: Strings.brand, value: myCards.brand),
          ],
        ),
      );
    });
  }

  Widget _controlsWidget(BuildContext context) {
    return SCSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Reveal details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.revealDetails,
                  style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
                ),
                Obx(
                  () => controller.isLoading || controller.isSensitiveLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.accent,
                          ),
                        )
                      : InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            controller.isShowSensitive.value =
                                !controller.isShowSensitive.value;
                            if (controller.isShowSensitive.value == false) {
                              controller.getCardDetailsData();
                            } else {
                              controller.revealShowProcess();
                            }
                            print(controller.isShowSensitive.value);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              controller.isShowSensitive.value == false
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 22,
                              color: AppColors.text2,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const _RowDivider(),
          // Freeze card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.freezeCard,
                  style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
                ),
                Obx(
                  () => controller.isCardStatusLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.accent,
                          ),
                        )
                      : Switch(
                          activeColor: AppColors.accent,
                          value: controller.isSelected.value,
                          onChanged: ((value) {
                            controller.isSelected.value =
                                !controller.isSelected.value;
                            controller.cardToggle;
                          }),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.mono = false,
  });

  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: mono
                  ? AppTextStyles.numSm.copyWith(color: AppColors.text)
                  : AppTextStyles.bodyMed.copyWith(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 0.5,
      thickness: 0.5,
      color: AppColors.line,
    );
  }
}
