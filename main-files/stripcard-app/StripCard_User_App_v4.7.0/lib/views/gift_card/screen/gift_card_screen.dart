import "package:stripcard/base/utils/custom_loading_api.dart";

import "package:stripcard/base/api/model/gift_card/my_gift_card_model.dart";
import "package:stripcard/views/gift_card/controller/gift_card_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/widgets/design_system/sc_network_image.dart";
import "package:stripcard/base/widgets/design_system/sc_shimmer.dart";

class GiftCardScreen extends StatelessWidget {
  GiftCardScreen({super.key});
  final controller = Get.put(GiftCardController());

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
          Get.find<LanguageController>().getTranslation(Strings.giftCards),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.allGiftCardScreen),
        backgroundColor: AppColors.accent,
        elevation: 0,
        child: const Icon(Icons.add_rounded, color: AppColors.accentInk),
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
    final cards = controller.myGiftCardModel.data.giftCards;

    return RefreshIndicator(
      color: AppColors.accent,
      onRefresh: () async {
        controller.getMyCardInfoApi();
      },
      child: cards.isEmpty
          ? _emptyState()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: cards.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) => _GiftCardTile(giftCard: cards[index]),
            ),
    );
  }

  Widget _emptyState() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 120),
        Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: const Icon(
            Icons.card_giftcard_outlined,
            size: 30,
            color: AppColors.text3,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          Get.find<LanguageController>().getTranslation(Strings.noGiftCardsYet),
          textAlign: TextAlign.center,
          style: AppTextStyles.h2.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: 6),
        Text(
          Get.find<LanguageController>()
              .getTranslation(Strings.tapPlusToBuyFirstGiftCard),
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _GiftCardTile extends StatelessWidget {
  const _GiftCardTile({required this.giftCard});

  final GiftCard giftCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line2, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SCNetworkImage(
            url: giftCard.cardImage,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
            radius: AppRadius.md,
            backgroundColor: AppColors.surface2,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  giftCard.cardName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 2),
                Text(
                  '${Strings.trxID}: ${giftCard.trxId}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${giftCard.cardTotalPrice} ${giftCard.walletCurrency}',
            style: AppTextStyles.numMd.copyWith(color: AppColors.text),
          ),
        ],
      ),
    );
  }
}
