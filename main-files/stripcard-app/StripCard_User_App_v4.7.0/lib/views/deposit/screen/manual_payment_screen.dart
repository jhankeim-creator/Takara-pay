import 'package:flutter_html/flutter_html.dart';

import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/views/deposit/controller/deposit_controller.dart";
import "package:stripcard/views/deposit/controller/manual_gateway_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_section_header.dart";
import "package:stripcard/base/widgets/design_system/sc_shimmer.dart";
import "package:stripcard/base/widgets/design_system/sc_surface_card.dart";

class ManualPaymentScreen extends StatelessWidget {
  ManualPaymentScreen({super.key});

  final controller = Get.put(ManualPaymentController());
  final depositController = Get.put(DepositController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didpop, pop) async {
        Get.offAllNamed(Routes.dashboardScreen);
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.text),
            onPressed: () {
              Get.offAllNamed(Routes.dashboardScreen);
            },
          ),
          title: Text(
            Strings.manualPayment,
            style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
          ),
        ),
        body: SafeArea(
          child: Obx(
            () => controller.isLoading
                ? const SCFormSkeleton()
                : _bodyWidget(context),
          ),
        ),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          _descriptionWidget(context),
          const SizedBox(height: 20),
          SCSectionHeader(label: Strings.manualPayment),
          // Dynamic input fields are constructed in the controller — render
          // them as-is to preserve their controller bindings & file-pick
          // callbacks.
          ...controller.inputFields.map((element) => element).toList(),
          const SizedBox(height: 24),
          _buttonWidget(context),
        ],
      ),
    );
  }

  Widget _buttonWidget(BuildContext context) {
    return Obx(
      () => SCPrimaryButton(
        label: Strings.confirm.tr,
        loading: controller.isConfirmLoading,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            if (controller.listImagePath.isNotEmpty) {
              controller.manualPaymentProcess(context);
            } else {
              CustomSnackBar.error(Strings.imagePathRequired);
            }
          }
        },
      ),
    );
  }

  Widget _descriptionWidget(BuildContext context) {
    final data = controller.manualPaymentGetGatewayModel.data;
    return SCSurfaceCard(
      color: AppColors.accentSoft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Html(
        data: data.details,
      ),
    );
  }
}
