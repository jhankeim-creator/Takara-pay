import "package:stripcard/base/utils/language/language_controller.dart";

import "package:stripcard/base/utils/custom_loading_api.dart";
import "package:stripcard/views/gift_card/controller/create_gift_card_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/others/gif_card_preview_widget.dart";

class GifCardPreviewScreen extends StatelessWidget {
  GifCardPreviewScreen({super.key});

  final controller = Get.put(CreateGiftCardController());

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
          Get.find<LanguageController>().getTranslation(Strings.preview),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isBuyLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            children: [
              GifCardPreviewInfoWidget(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: SCPrimaryButton(
            label: Get.find<LanguageController>().getTranslation(Strings.buyNow),
            onPressed: () => controller.createGiftCardApi(),
          ),
        ),
      ],
    );
  }
}
