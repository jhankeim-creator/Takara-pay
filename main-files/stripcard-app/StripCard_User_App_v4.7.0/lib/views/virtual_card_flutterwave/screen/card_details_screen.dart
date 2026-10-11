import "package:TAKARA PAY/views/virtual_card_flutterwave/controller/card_details_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_section_header.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_shimmer.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_surface_card.dart";

class CardDetailsScreen extends StatelessWidget {
  CardDetailsScreen({super.key});
  final controller = Get.put(CardDetailsController());

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
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        _amountWidget(context),
        const SizedBox(height: 24),
        const SCSectionHeader(label: 'CARD INFORMATION'),
        _cardDetailsWidget(context),
        const SizedBox(height: 24),
      ],
    );
  }

  _amountWidget(BuildContext context) {
    var data = controller.cardDetailsModel.data;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisAlignment: mainCenter,
        children: [
          Text(
            Strings.currentAmount.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${data.myCards.amount} ${data.baseCurr}',
            textAlign: TextAlign.center,
            style: AppTextStyles.numDisplay.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  _cardDetailsWidget(BuildContext context) {
    var myCards = controller.cardDetailsModel.data.myCards;

    return SCSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          _DetailRow(label: Strings.cardType, value: myCards.cardType),
          const _RowDivider(),
          _DetailRow(label: 'CVV/CVC', value: myCards.cvv, mono: true),
          const _RowDivider(),
          _DetailRow(
            label: 'Expiration',
            value: myCards.expiration,
            mono: true,
          ),
          const _RowDivider(),
          _DetailRow(label: 'City', value: myCards.city),
          const _RowDivider(),
          _DetailRow(label: 'State', value: myCards.state),
          const _RowDivider(),
          _DetailRow(label: 'Address', value: myCards.address),
          const _RowDivider(),
          _DetailRow(label: 'Zip Code', value: myCards.zipCode, mono: true),
          const _RowDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: mainSpaceBet,
              children: [
                Text(
                  Strings.freezeCard,
                  style: AppTextStyles.body.copyWith(color: AppColors.text2),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
      color: AppColors.line2,
    );
  }
}
