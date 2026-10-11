import 'package:flutter/services.dart';
import "package:TAKARA PAY/views/deposit/controller/deposit_controller.dart";
import "package:TAKARA PAY/base/utils/custom_loading_api.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/inputs/primary_input_filed.dart";

class AuthorizeGatewayScreen extends StatelessWidget {
  AuthorizeGatewayScreen({super.key});

  final controller = Get.put(DepositController());
  final passwordKey = GlobalKey<FormState>();

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
          Get.find<LanguageController>().getTranslation(Strings.debitCardPayment),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(child: _bodyWidget(context)),
    );
  }

  ListView _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.9,
      ),
      physics: const BouncingScrollPhysics(),
      children: [_inputWidget(context), _buttonWidget(context)],
    );
  }

  Form _inputWidget(BuildContext context) {
    return Form(
      key: passwordKey,
      child: Column(
        children: [
          verticalSpace(Dimensions.heightSize * 2),

          PrimaryInputWidget(
            controller: controller.cardNumberController,
            label: Strings.cardNumber,
            hint: "0000 0000 0000 0000",

            keyboardInputType: TextInputType.number,
            // color: CustomColor.whiteColor,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CardNumberFormatter(),
            ],
          ),
          verticalSpace(Dimensions.heightSize),
          PrimaryInputWidget(
            controller: controller.cardExpiryController,
            label: Strings.expirationDate,
            // color: CustomColor.whiteColor,
            hint: "YY/MM",
            keyboardInputType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              ExpiryDateFormatter(),
            ],
          ),
          verticalSpace(Dimensions.heightSize),
          PrimaryInputWidget(
            controller: controller.cardCVCController,
            label: Strings.cvv,

            // color: CustomColor.whiteColor,
            hint: "123",
            keyboardInputType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Container _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 2),
      child: Obx(
        () => controller.isAuthorizeConfirmLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                onPressed: () {
                  if (passwordKey.currentState!.validate()) {
                    controller.automaticAuthorizeProcessApi(context);
                  }
                },
                title: Strings.confirm,
              ),
      ),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (text.length > 2) {
      text = "${text.substring(0, 2)}/${text.substring(2)}";
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final formatted = digitsOnly.replaceAllMapped(
      RegExp(r".{1,4}"),
      (match) => "${match.group(0)} ",
    );
    return TextEditingValue(
      text: formatted.trim(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
