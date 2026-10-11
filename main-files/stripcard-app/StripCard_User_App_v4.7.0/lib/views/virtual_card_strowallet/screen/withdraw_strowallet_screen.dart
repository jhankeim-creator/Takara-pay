import "package:TAKARA PAY/base/utils/custom_loading_api.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/controller/add_fund_strowallet_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/inputs/strowallet_fund_keybaord_widget.dart";

/// Withdraw Strowallet card balance back to the wallet
/// (POST /user/strowallet-card/withdraw). Reuses the add-fund UI/controller in
/// withdraw mode so the charge/limit display and numpad stay consistent.
class StrowalletWithdrawScreen extends StatelessWidget {
  StrowalletWithdrawScreen({super.key});
  final controller = Get.put(StrowalletAddFundController());

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
          () => controller.isLoadingCharge
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        StrowalletAddFundWidget(
          buttonText: Strings.proceed,
          isWithdraw: true,
        ),
      ],
    );
  }
}
