import "package:stripcard/base/utils/local_storage.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/utils/custom_loading_api.dart";
import "package:stripcard/views/kyc/controller/kyc_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_section_header.dart";
import "package:stripcard/base/widgets/design_system/sc_shimmer.dart";

class KycMobileScreenLayout extends StatelessWidget {
  KycMobileScreenLayout({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final KycController controller;
  final formKey = GlobalKey<FormState>();

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
          Get.find<LanguageController>().getTranslation(Strings.kycVerification),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          return controller.isLoading
              ? const SCFormSkeleton()
              : _bodyWidget(context);
        }),
      ),
    );
  }

  // body widget
  Widget _bodyWidget(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              _inputWidget(context),
            ],
          ),
        ),
        _buttonWidget(context),
      ],
    );
  }

  // input widgets
  Widget _inputWidget(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.kycInfoModel.data.kycStatus == 2)
            _statusBanner(
              icon: Icons.hourglass_top_rounded,
              text: Get.find<LanguageController>().getTranslation(Strings.pending),
              color: AppColors.warn,
              soft: AppColors.warnSoft,
            )
          else if (controller.kycInfoModel.data.kycStatus == 1)
            _statusBanner(
              icon: Icons.verified_rounded,
              text: Get.find<LanguageController>().getTranslation(Strings.verified),
              color: AppColors.accent,
              soft: AppColors.accentSoft,
            )
          else ...[
            const SCSectionHeader(label: 'Verification'),
            ...controller.inputFields.map<Widget>((element) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: element as Widget,
              );
            }),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _statusBanner({
    required IconData icon,
    required String text,
    required Color color,
    required Color soft,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: soft,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.h2.copyWith(color: AppColors.text),
          ),
        ],
      ),
    );
  }

  // button widget
  Widget _buttonWidget(BuildContext context) {
    var data = LocalStorage.getKyc();
    return data == 0 || data == 3
        ? Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: SCPrimaryButton(
              label: Get.find<LanguageController>().getTranslation(Strings.submit),
              onPressed: () {
                if (formKey.currentState!.validate()) {}
                controller.submitKycProcess(context: context);
              },
            ),
          )
        : const SizedBox();
  }
}
