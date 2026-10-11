part of "../cardyfie_create_card_screen.dart";

class CreateCustomerWidget extends StatelessWidget {
  CreateCustomerWidget({super.key});
  final controller = Get.put(VirtualCardyfieCardController());
  final profileController = Get.put(UpdateProfileController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              _introHeader(),
              const SizedBox(height: 24),
              const SCSectionHeader(label: 'Personal details'),
              _personalSection(context),
              const SizedBox(height: 12),
              const SCSectionHeader(label: 'Address'),
              _addressSection(context),
              const SizedBox(height: 12),
              const SCSectionHeader(label: 'Identity'),
              _identitySection(context),
              const SizedBox(height: 20),
              const SCSectionHeader(label: 'Documents'),
              _documentsSection(context),
            ],
          ),
        ),
        _footer(context),
      ],
    );
  }

  // ─── Intro headline + subtitle ───────────────────────────────────────
  Widget _introHeader() {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        Text(
          Strings.createCardCustomer,
          style: AppTextStyles.h1.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: 8),
        Text(
          Strings.shouldMatchYourID,
          style: AppTextStyles.body.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }

  // ─── Personal details ────────────────────────────────────────────────
  Widget _personalSection(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        Row(
          children: [
            Expanded(
              child: PrimaryInputWidget(
                controller: controller.firstNameController,
                hint: Strings.firstName,
                label: Strings.firstName,
              ),
            ),
            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: PrimaryInputWidget(
                controller: controller.lastNameController,
                hint: Strings.lastName,
                label: Strings.lastName,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize),
        PrimaryInputWidget(
          controller: controller.emailController,
          hint: Strings.emailAddress,
          label: Strings.emailAddress,
        ),
        verticalSpace(Dimensions.heightSize),
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
            child: PrimaryInputWidget(
              controller: controller.dateOfBirthController,
              optionalLabel: Strings.shouldMatchYourID,
              label: Strings.dateOfBirth,
              hint: Strings.dateOfBirth,
              isValidator: true,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Address ──────────────────────────────────────────────────────────
  Widget _addressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        Text(
          Strings.country,
          style: AppTextStyles.label.copyWith(color: AppColors.text2),
        ),
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
        verticalSpace(Dimensions.heightSize),
        Row(
          children: [
            Expanded(
              child: PrimaryInputWidget(
                controller: controller.cityController,
                hint: Strings.city,
                label: Strings.city,
              ),
            ),
            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: PrimaryInputWidget(
                controller: controller.stateController,
                hint: Strings.state,
                label: Strings.state,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize),
        Row(
          children: [
            Expanded(
              child: PrimaryInputWidget(
                controller: controller.addressController,
                hint: Strings.address,
                label: Strings.address,
              ),
            ),
            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: PrimaryInputWidget(
                controller: controller.zipcodeController,
                hint: Strings.zipCode,
                label: Strings.zipCode,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize),
        PrimaryInputWidget(
          controller: controller.houseNumberController,
          hint: Strings.houseNumber,
          label: Strings.houseNumber,
          keyboardInputType: TextInputType.number,
        ),
      ],
    );
  }

  // ─── Identity ─────────────────────────────────────────────────────────
  Widget _identitySection(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        Obx(
          () => CustomDropDown<StringDropdownModel>(
            title: Strings.identityType,
            hint: controller.selectTypeName.value,
            items: controller.identityList
                .map(
                  (e) =>
                      StringDropdownModel(title: e['name']!, slug: e['slug']!),
                )
                .toList(),
            onChanged: (value) {
              // Set name
              controller.selectTypeName.value = value!.title;
              controller.selectTypeSlug.value = value.slug!;
            },
          ),
        ),
        verticalSpace(Dimensions.heightSize),
        PrimaryInputWidget(
          controller: controller.identifyNumberController,
          hint: Strings.identity,
          label: Strings.identity,
          keyboardInputType: TextInputType.number,
        ),
      ],
    );
  }

  // ─── Documents (image uploads) ───────────────────────────────────────
  Widget _documentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        Row(
          crossAxisAlignment: crossStart,
          children: [
            Expanded(
              child: SelectedImageWidget(
                labelName: Strings.IdCardImageFont,
                fieldName: "id_front_image",
              ),
            ),
            horizontalSpace(Dimensions.widthSize),
            Expanded(
              child: SelectedImageWidget(
                labelName: Strings.IdCardImageBack,
                fieldName: "id_back_image",
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize),
        SelectedImageWidget(
          labelName: Strings.yourPhoto,
          fieldName: "user_image",
        ),
      ],
    );
  }

  // ─── Sticky submit footer ────────────────────────────────────────────
  Widget _footer(BuildContext context) {
    return _PinnedFooter(
      child: Obx(
        () => SCPrimaryButton(
          label: Strings.submit,
          icon: Icons.arrow_forward_rounded,
          loading: controller.isCustomerCreateLoading,
          onPressed: () {
            print(controller.listFieldName);
            print(controller.listImagePath);

            controller.customerCreateProcess();
          },
        ),
      ),
    );
  }
}
