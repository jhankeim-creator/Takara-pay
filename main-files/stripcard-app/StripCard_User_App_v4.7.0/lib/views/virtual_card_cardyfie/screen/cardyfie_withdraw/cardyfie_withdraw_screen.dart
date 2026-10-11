import "package:stripcard/base/widgets/dropdown/cardyfie_wallet_card_dropdown.dart";
import "package:stripcard/base/api/model/virtual_card/cardyfie_model/my_card_model_cardyfie.dart";
import "package:stripcard/base/utils/custom_loading_api.dart";
import "package:stripcard/views/virtual_card_cardyfie/controller/cardyfie_info_controller.dart";
import "package:stripcard/views/virtual_card_cardyfie/controller/cardyfie_withdraw_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_amount_input.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_numpad.dart";
import "package:stripcard/base/widgets/design_system/sc_surface_card.dart";
part '../cardyfie_withdraw/widget/cardyfire_withdraw_keyboard_widget.dart';

class CardyfieWithdrawScreen extends StatelessWidget {
  CardyfieWithdrawScreen({super.key});
  final controller = Get.put(VirtualCardyfieCardController());
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
          Strings.withdraw,
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [CardyfieWithdrawFundWidget(buttonText: Strings.withdraw)],
    );
  }
}
