import 'dart:async';
import "package:TAKARA PAY/base/utils/custom_loading_api.dart";
import "package:TAKARA PAY/base/utils/custom_switch_loading_api.dart";
import "package:TAKARA PAY/views/virtual_card_cardyfie/controller/cardyfie_details_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_shimmer.dart";
part '../cardyfie_details/widget/address_widget_cardyfie.dart';
part '../cardyfie_details/widget/details_widget.dart';

class CardyfieDetailsScreen extends StatelessWidget {
  CardyfieDetailsScreen({super.key});
  final controller = Get.put(CardyfieDetailsController());
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
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
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        children: [AddressWidgetCardyfie(), CardyfieDetailsWidget()],
      ),
    );
  }
}
