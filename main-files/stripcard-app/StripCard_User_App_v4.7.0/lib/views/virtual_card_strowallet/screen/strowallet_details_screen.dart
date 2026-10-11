import "package:TAKARA PAY/base/utils/custom_loading_api.dart";
import "package:TAKARA PAY/base/utils/custom_switch_loading_api.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/controller/strowallet_details_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_shimmer.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_surface_card.dart";

class StrowalletCardDetailsScreen extends StatelessWidget {
  StrowalletCardDetailsScreen({super.key});
  final controller = Get.put(StrowalletCardDetailsController());

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

  _bodyWidget(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      physics: const BouncingScrollPhysics(),
      children: [
        _actionButtons(context),
        const SizedBox(height: 16),
        _cardDetailsWidget(context),
      ],
    );
  }

  // Fund (wallet → card) and Withdraw (card → wallet) entry points. The active
  // card id was already set on the shared controller when this card was opened.
  Widget _actionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SCPrimaryButton(
            label: Strings.fund,
            icon: Icons.add_card_outlined,
            onPressed: () => Get.toNamed(Routes.strowalletAddFundScreen),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SCSecondaryButton(
            label: Strings.withdraw,
            icon: Icons.account_balance_wallet_outlined,
            onPressed: () => Get.toNamed(Routes.strowalletWithdrawScreen),
          ),
        ),
      ],
    );
  }

  _cardDetailsWidget(BuildContext context) {
    var myCards = controller.cardDetailsModel.data.myCards;

    return SCSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              Strings.cardInformation,
              style: AppTextStyles.h2.copyWith(color: AppColors.text),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.line2),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                _DetailRow(
                  label: Strings.amount,
                  value: myCards.amount.toString(),
                  mono: true,
                ),
                _DetailRow(label: Strings.cardId, value: myCards.cardId),
                _DetailRow(
                  label: Strings.customerId,
                  value: myCards.cardUserId,
                ),

                ///>>>>>>>> card plan
                Visibility(
                  visible: controller.isShowSensitive.value == false,
                  child: _DetailRow(
                    label: Strings.cardType,
                    value: myCards.cardBrand,
                  ),
                ),

                Visibility(
                  visible: controller.isShowSensitive.value == true,
                  child: _DetailRow(
                    label: Strings.cardNumber,
                    value: controller.cardPlan.value,
                    mono: true,
                  ),
                ),

                ///>>>>>>>> card cvc
                _DetailRow(label: Strings.cvc, value: myCards.cvv, mono: true),

                _DetailRow(
                  label: Strings.expiration,
                  value: myCards.expiry,
                  mono: true,
                ),
                _DetailRow(label: Strings.city, value: myCards.city),
                _DetailRow(label: Strings.state, value: myCards.state),
                _DetailRow(
                  label: Strings.zipCode,
                  value: myCards.zipCode,
                  mono: true,
                ),

                _DetailRow(
                  label: Strings.billingCountry,
                  value: Strings.unitedState,
                ),
                _DetailRow(
                  label: Strings.billingCity,
                  value: Strings.miami,
                ),
                _DetailRow(
                  label: Strings.billingStreet,
                  value: '3401 N. Miami, Ave. Ste 230',
                ),
                _DetailRow(
                  label: Strings.billingZipCode,
                  value: '33127',
                  mono: true,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    Text(
                      Strings.freezeCard,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    Obx(
                      () => controller.isCardStatusLoading
                          ? const CustomSwitchLoading(
                              color: AppColors.accent,
                            )
                          : Switch(
                              activeColor: AppColors.accent,
                              inactiveThumbColor: AppColors.text3,
                              // "Freeze Card" → ON means the card IS frozen.
                              // isSelected tracks the ACTIVE state (status==true),
                              // so the frozen state is its inverse. Without this
                              // the toggle read backwards vs the home "FROZEN"
                              // badge (frozen card showed the switch OFF).
                              value: !controller.isSelected.value,
                              onChanged: ((value) {
                                controller.isSelected.value =
                                    !controller.isSelected.value;
                                controller.cardToggle;
                              }),
                            ),
                    ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
