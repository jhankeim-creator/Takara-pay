import 'package:carousel_slider/carousel_slider.dart';
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/screen/card_widget.dart";
import "package:TAKARA PAY/base/utils/custom_loading_api.dart";
import "package:TAKARA PAY/views/virtual_card_cardyfie/controller/cardyfie_info_controller.dart";
import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
part '../cardyfie_card_screen/widget/cardyfie_card_slider.dart';
part '../cardyfie_card_screen/widget/cardyfie_category_widget.dart';

class CardyfieCardScreen extends StatelessWidget {
  const CardyfieCardScreen({super.key, required this.controller});
  final VirtualCardyfieCardController controller;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading
          ? const CustomLoadingAPI()
          : _bodyWidget(context),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return _cardyfieCardWidget(context);
  }

  _cardyfieCardWidget(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            mainAxisAlignment: mainCenter,
            mainAxisSize: mainMin,
            children: [CardyfieCardSlider(), CardyfieCategoryWidget()],
          ),
        ),
        if (controller.cardyfieCardModel.data.cardCreateAction) ...[
          _buttonWidget(context),
        ],
      ],
    );
  }

  _buttonWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: SCPrimaryButton(
        label: Strings.createANewCard,
        icon: Icons.add_rounded,
        onPressed: () {
          Get.toNamed(Routes.crateCardyfieScreen);
        },
      ),
    );
  }
}
