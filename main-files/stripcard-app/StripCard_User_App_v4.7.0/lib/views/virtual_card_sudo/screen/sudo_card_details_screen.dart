import "package:TAKARA PAY/views/virtual_card_sudo/controller/sudo_card_details_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_shimmer.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_surface_card.dart";
import "package:TAKARA PAY/base/widgets/virtual_card/cvc_vgs_widget.dart";
import "package:TAKARA PAY/views/virtual_card_sudo/screen/vgs_widget.dart";

class SudoCardDetailsScreen extends StatelessWidget {
  SudoCardDetailsScreen({super.key});
  final controller = Get.put(SudoCardDetailsController());

  get payload => null;
  @override
  Widget build(
    BuildContext context,
  ) {
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

  Widget _bodyWidget(
    BuildContext context,
  ) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        _amountWidget(context),
        const SizedBox(height: 16),
        _cardDetailsWidget(context),
      ],
    );
  }

  Widget _amountWidget(BuildContext context) {
    var data = controller.cardDetailsModel.data;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        mainAxisAlignment: mainCenter,
        children: [
          Text(
            Strings.currentAmount,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            '${data.cardDetails.amount} ${data.baseCurr}',
            textAlign: TextAlign.center,
            style: AppTextStyles.numDisplay.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _cardDetailsWidget(BuildContext context) {
    var myCards = controller.cardDetailsModel.data.cardDetails;
    var cardSecureDate = controller.cardDetailsModel.data.cardSecureDate;

    return SCSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              Strings.cardInformation,
              style: AppTextStyles.h2.copyWith(color: AppColors.text),
            ),
          ),
          const Divider(height: 0.5, thickness: 0.5, color: AppColors.line),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                _DetailRow(
                  label: Strings.cardHolder,
                  value: myCards.cardHolder,
                ),
                _DetailRow(
                  label: Strings.currency,
                  value: myCards.currency,
                ),
                _DetailRow(
                  label: Strings.cardType,
                  value: myCards.type,
                ),
                Obx(
                  () => Visibility(
                    visible: !controller.isRevealedDetails.value,
                    child: _DetailRow(
                      label: Strings.cardNumber,
                      value: myCards.cardPan,
                      mono: true,
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.isRevealedDetails.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: mainSpaceBet,
                        children: [
                          Expanded(
                            child: Text(
                              Strings.cardNumber,
                              style: AppTextStyles.label
                                  .copyWith(color: AppColors.text2),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 20,
                              width: 150,
                              child: VgsIntegrationWidget(
                                environment: cardSecureDate.apiMode,
                                token: cardSecureDate.cardToken,
                                cardId: myCards.cardId,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: !controller.isRevealedDetails.value,
                    child: _DetailRow(
                      label: Strings.cvc,
                      value: myCards.cvv,
                      mono: true,
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.isRevealedDetails.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: mainSpaceBet,
                        children: [
                          Expanded(
                            child: Text(
                              Strings.cvc,
                              style: AppTextStyles.label
                                  .copyWith(color: AppColors.text2),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 20,
                              width: 80,
                              child: VgsCVCIntegrationWidget(
                                environment: cardSecureDate.apiMode,
                                token: cardSecureDate.cardToken,
                                cardId: myCards.cardId,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _DetailRow(
                  label: Strings.expiration,
                  value: "${myCards.expiryMonth}/${myCards.expiryYear}",
                  mono: true,
                ),
                _DetailRow(
                  label: Strings.brand,
                  value: myCards.brand,
                ),
                const Divider(
                    height: 0.5, thickness: 0.5, color: AppColors.line),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: mainSpaceBet,
                    children: [
                      Text(
                        Strings.freezeCard,
                        style: AppTextStyles.body
                            .copyWith(color: AppColors.text2),
                      ),
                      Obx(
                        () => controller.isCardStatusLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.accent,
                                ),
                              )
                            : Switch(
                                activeColor: AppColors.accentInk,
                                activeTrackColor: AppColors.accent,
                                inactiveThumbColor: AppColors.surface,
                                inactiveTrackColor: AppColors.surface2,
                                value: controller.isSelected.value,
                                onChanged: ((value) {
                                  controller.isSelected.toggle();
                                  controller.cardToggle;
                                }),
                              ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    Text(
                      Strings.revealDetails,
                      style:
                          AppTextStyles.body.copyWith(color: AppColors.text2),
                    ),
                    Obx(() => IconButton(
                          icon: Icon(
                            controller.isRevealedDetails.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.text,
                          ),
                          onPressed: () {
                            controller.isRevealedDetails.value =
                                !controller.isRevealedDetails.value;
                          },
                        )),
                  ],
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
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
