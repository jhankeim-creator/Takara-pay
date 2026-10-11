import 'package:intl/intl.dart';
import "package:stripcard/base/api/model/virtual_card/cardyfie_model/my_card_model_cardyfie.dart"
    show UserWallet, SupportedCurrency;
import "package:stripcard/views/profile/controller/update_profile_controller.dart";
import "package:stripcard/base/widgets/inputs/strowallet_fund_keybaord_widget.dart";
import "package:stripcard/base/utils/custom_loading_api.dart";
import "package:stripcard/views/virtual_card_cardyfie/controller/cardyfie_info_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_surface_card.dart";
import "package:stripcard/base/widgets/design_system/sc_section_header.dart";
import "package:stripcard/base/widgets/design_system/sc_virtual_card.dart";
import "package:stripcard/base/widgets/dropdown/cardyfie_wallet_card_dropdown.dart";
import "package:stripcard/base/widgets/inputs/country_picker_input_widget.dart";
import "package:stripcard/base/widgets/inputs/image_widget.dart";
import "package:stripcard/base/widgets/inputs/input_with_text.dart";
import "package:stripcard/base/widgets/inputs/primary_input_filed.dart";
import "package:stripcard/base/widgets/inputs/primary_text_input_widget.dart";
import "package:stripcard/base/widgets/inputs/strowallet_flipcard.dart";
import "package:stripcard/views/kyc/screen/kyc_dynamic_image_widget.dart";
import "package:stripcard/views/virtual_card_cardyfie/screen/cardyfie_create_card_screen/widget/selected_image_widget.dart";
part '../cardyfie_create_card_screen/widget/cardyfie_create_customer_widget.dart';
part '../cardyfie_create_card_screen/widget/cardyfie_create_card_widget.dart';
part '../cardyfie_create_card_screen/widget/pending_status.dart';

class CrateCardyfieScreen extends StatelessWidget {
  CrateCardyfieScreen({super.key});

  final controller = Get.put(VirtualCardyfieCardController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.text),
          onPressed: Get.back,
        ),
        title: Text(
          controller
                      .createCardPageInfoModelCardyfie
                      .data
                      .customerExistStatus ==
                  false
              ? Strings.createCard
              : Strings.createCardCustomer,
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child:
            controller.isCreateCardInfoLoading ||
                controller.isLoading ||
                controller.isBuyCardLoading
            ? const CustomLoadingAPI()
            : _bodyWidget(context),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    if (controller.createCardPageInfoModelCardyfie.data.customerExistStatus ==
        false) {
      return CreateCustomerWidget();
    } else {
      if (controller
              .createCardPageInfoModelCardyfie
              .data
              .customerExist
              .status ==
          "APPROVED") {
        return CardyfieCreateCardWidget();
      } else {
        return const CardyfiePendingWidget();
      }
    }
  }
}

// ─── Shared sticky bottom CTA footer ──────────────────────────────────────
// Top hairline + safe-area inset so the CTA stays visible when the keyboard
// opens. Mirrors the gold-standard FlutterWave _PinnedFooter.
class _PinnedFooter extends StatelessWidget {
  final Widget child;
  const _PinnedFooter({required this.child});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.line2, width: 1)),
      ),
      child: child,
    );
  }
}
