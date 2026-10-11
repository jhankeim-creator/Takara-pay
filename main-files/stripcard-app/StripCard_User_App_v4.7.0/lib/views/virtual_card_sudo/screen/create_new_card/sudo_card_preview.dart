import "package:TAKARA PAY/base/widgets/others/preview/information_amount_widget.dart";

import "package:TAKARA PAY/views/virtual_card_sudo/controller/create_card/sudo_create_card_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";

class SudoCreateNewCardPreviewScreen extends StatelessWidget {
  SudoCreateNewCardPreviewScreen({super.key});

  final controller = Get.put(SudoCreateCardController());

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
          Strings.preview,
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                )
              : _bodyWidget(context),
        ),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      physics: const BouncingScrollPhysics(),
      children: [
        _amountWidget(context),
        AmountPreviewInfoWidget(),
        _buttonWidget(context),
      ],
    );
  }

  Widget _amountWidget(BuildContext context) {
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
      child: Text(
        "${controller.amountTextController.text} ${controller.sudoCardController.selectedSupportedCurrencyCode.value}",
        textAlign: TextAlign.center,
        style: AppTextStyles.numDisplay.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buttonWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Obx(
        () => SCPrimaryButton(
          label: Strings.confirm,
          loading: controller.isLoading,
          onPressed: () {
            if (controller.sudoCardController.isExtraField == true) {
              controller.firstCreateCardProcess(context);
            } else {
              controller.CrateCardProcess(context);
            }
          },
        ),
      ),
    );
  }
}
