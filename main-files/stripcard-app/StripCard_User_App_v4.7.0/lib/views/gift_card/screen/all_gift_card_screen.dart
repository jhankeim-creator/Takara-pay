import "package:TAKARA PAY/base/utils/custom_loading_api.dart";

import "package:TAKARA PAY/base/utils/local_storage.dart";
import "package:TAKARA PAY/base/api/model/gift_card/gift_card_list_model.dart";
import "package:TAKARA PAY/views/gift_card/controller/all_gift_card_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_network_image.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_shimmer.dart";

class AllGiftCardScreen extends StatelessWidget {
  AllGiftCardScreen({super.key});
  final controller = Get.put(AllGiftCardController());

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
          Get.find<LanguageController>().getTranslation(Strings.buyGiftCard),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(child: _bodyWidget(context)),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: _CountrySelector(
              label: controller.selectedCountry.value,
              onTap: () => _openCountrySheet(context),
            ),
          ),
          if (controller.isLoading) ...[
            const Expanded(child: SCListSkeleton()),
          ] else ...[
            Expanded(
              child: GridView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: 0.82,
                ),
                itemCount: controller.historyList.length,
                itemBuilder: (_, index) {
                  final item = controller.historyList[index];
                  return _ProductTile(
                    logoUrl: item.logoUrls.first,
                    name: item.productName,
                    onTap: () {
                      LocalStorage.saveProductId(
                        id: item.productId.toString(),
                      );
                      controller.productName.value = item.productName;
                      Get.toNamed(Routes.createGiftCardScreen);
                    },
                  );
                },
              ),
            ),
          ],
          Obx(
            () => controller.isMoreLoading
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: CircularProgressIndicator(color: AppColors.accent),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void _openCountrySheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.7),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text(
                    Strings.country,
                    style: AppTextStyles.h2.copyWith(color: AppColors.text),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: controller.countryList.length,
                itemBuilder: (_, i) {
                  final CountryElement c = controller.countryList[i];
                  final selected = c.name == controller.selectedCountry.value;
                  return ListTile(
                    onTap: () {
                      controller.selectedCountry.value = c.name;
                      controller.selectedCountryCode.value = c.iso2;
                      controller.giftCardListModelProcess();
                      Get.back();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    title: Text(
                      c.name,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check, color: AppColors.accent)
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _CountrySelector extends StatelessWidget {
  const _CountrySelector({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.line2, width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.public, size: 18, color: AppColors.text3),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label.isEmpty ? Strings.country : label,
                  style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.expand_more, size: 20, color: AppColors.text3),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.logoUrl,
    required this.name,
    required this.onTap,
  });

  final String logoUrl;
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.line2, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: SCNetworkImage(
                    url: logoUrl,
                    fit: BoxFit.contain,
                    errorIcon: Icons.card_giftcard_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
