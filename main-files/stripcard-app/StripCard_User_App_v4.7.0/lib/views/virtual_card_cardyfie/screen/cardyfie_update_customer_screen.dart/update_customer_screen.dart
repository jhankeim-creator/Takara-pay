import 'package:intl/intl.dart';
import "package:stripcard/views/virtual_card_cardyfie/screen/cardyfie_update_customer_screen.dart/widget/update_image.dart";
import "package:stripcard/base/utils/custom_loading_api.dart";
import "package:stripcard/views/virtual_card_cardyfie/controller/cardyfie_update_customer_controller.dart";
import "package:stripcard/views/profile/controller/update_profile_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_text_field.dart";
import "package:stripcard/base/widgets/inputs/country_picker_input_widget.dart";
import "package:stripcard/base/widgets/dropdown/cardyfie_wallet_card_dropdown.dart";

class UpdateCustomerScreen extends StatelessWidget {
  UpdateCustomerScreen({Key? key}) : super(key: key);
  final controller = Get.put(UpdateCustomerCardyfieController());
  final profileController = Get.put(UpdateProfileController());

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
          Strings.updateCustomer,
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isCreateCardInfoLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      physics: const BouncingScrollPhysics(),
      children: [_inputWidget(context), _buttonWidget(context)],
    );
  }

  Widget _label(String text) => Text(
        text,
        style: AppTextStyles.label.copyWith(color: AppColors.text2),
      );

  _inputWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SCTextField(
                controller: controller.firstNameController,
                hint: Strings.firstName,
                label: Strings.firstName,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SCTextField(
                controller: controller.lastNameController,
                hint: Strings.lastName,
                label: Strings.lastName,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SCTextField(
          readOnly: true,
          controller: controller.emailController,
          hint: Strings.emailAddress,
          label: Strings.emailAddress,
        ),
        const SizedBox(height: 16),
        SCTextField(
          controller: controller.identifyNumberController,
          hint: Strings.identity,
          label: Strings.identity,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        SCTextField(
          controller: controller.houseNumberController,
          hint: Strings.houseNumber,
          label: Strings.houseNumber,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _label(Strings.country),
        const SizedBox(height: 6),
        CountryDropDown(
          selectMethod: controller.selectedCountry,
          itemsList: profileController.userProfileModel.data.countries,
          onChanged: (value) {
            controller.selectedCountry.value = value!.name;
            controller.countryISO2.value = value.iso2;
            print(controller.selectedCountry.value);
          },
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SCTextField(
                controller: controller.cityController,
                hint: Strings.city,
                label: Strings.city,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SCTextField(
                controller: controller.stateController,
                hint: Strings.state,
                label: Strings.state,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SCTextField(
                controller: controller.addressController,
                hint: Strings.address,
                label: Strings.address,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SCTextField(
                controller: controller.zipcodeController,
                hint: Strings.zipCode,
                label: Strings.zipCode,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        //date of birth
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: Get.context!,
              initialDate: DateTime.now(),
              firstDate: DateTime(1930),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              final DateFormat formatter = DateFormat('MM/dd/yyyy');
              final String formattedDate = formatter.format(pickedDate);

              controller.dateOfBirthController.text = formattedDate;
            }

            print(controller.dateOfBirthController.text);
          },
          child: AbsorbPointer(
            child: SCTextField(
              controller: controller.dateOfBirthController,
              helper: Strings.shouldMatchYourID,
              label: Strings.dateOfBirth,
              hint: Strings.dateOfBirth,
              readOnly: true,
              suffixIcon: const Icon(Icons.calendar_today),
            ),
          ),
        ),
        const SizedBox(height: 16),
        //dropdown select type
        _label(Strings.identityType),
        const SizedBox(height: 6),
        CustomDropDown<StringDropdownModel>(
          dropDownColor: AppColors.surface,
          titleTextColor: AppColors.text,
          dropDownHeight: 52,
          hint: controller.selectTypeName.value,
          items: controller.identityList
              .map(
                (e) => StringDropdownModel(title: e['name']!, slug: e['slug']!),
              )
              .toList(),
          onChanged: (value) {
            // Set name
            controller.selectTypeName.value = value!.title;
            controller.selectTypeSlug.value = value.slug!;
          },
        ),

        const SizedBox(height: 24),

        // image picker
        Row(
          children: [
            Expanded(
              child: SelectedImageWidget(
                //  getImage: controller.fontImage.value ,
                imageUrl: controller.fontImage.value,

                labelName: Strings.IdCardImageFont,
                fieldName: "id_front_image",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SelectedImageWidget(
                // getImage: controller.backImage.value ,
                imageUrl: controller.backImage.value,

                labelName: Strings.IdCardImageBack,
                fieldName: "id_back_image",
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        SelectedImageWidget(
          imageUrl: controller.userPhoto.value,
          labelName: Strings.yourPhoto,
          fieldName: "user_image",
        ),
      ],
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 24),
      child: Obx(
        () => controller.isConfirmLoading
            ? const CustomLoadingAPI()
            : SCPrimaryButton(
                label: Strings.submit,
                onPressed: () {
                  print(controller.listFieldName);
                  print(controller.listImagePath);

                  controller.updateCustomerKyc();
                },
              ),
      ),
    );
  }
}
